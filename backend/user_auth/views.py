from rest_framework import viewsets, status
from rest_framework.decorators import action
from .serializers import UserSerializers
from rest_framework.response import Response
from firebase_admin import firestore, auth
from django.contrib.auth import get_user_model
from django.conf import settings
import requests

db = firestore.client()

class UserViewSet(viewsets.ViewSet):
    User = get_user_model()

    def get_user_by_firebase(self, user_id):
        try:
            user = auth.get_user(user_id)
            return user
        except auth.UserNotFoundError:
            return None
        
    def check_user_exists(self, email):
        try:
            user = auth.get_user_by_email(email)
            return True
        except auth.UserNotFoundError:
            return False
        
    def _create_firestore_user(seft, uid, username, email):
        user_info = {
            "uid": uid,
            "email": email,
            "display_name": username,
        }

        # check user exist
        user_ref = db.collection("users").document(uid)
        user_doc = user_ref.get()

        if not user_doc.exists:
            extra_info = {
                "role": "user",                          
                "phone": "", 
                "photo_url": '',   
                "created_at": firestore.SERVER_TIMESTAMP,
                'update_at': firestore.SERVER_TIMESTAMP,            
            }
            user_ref.set({**user_info, **extra_info})
            user_data = user_ref.get().to_dict()
        else:
            user_data = user_doc.to_dict()
                    
        return user_data
    
    def _firebase_signin(seft, email, password):
        url = f"https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key={settings.FIREBASE_API_KEY}"
        payload = {
            "email": email,
            "password": password,
            "returnSecureToken": True
        }
        r = requests.post(url, json=payload)
        data = r.json()

        if "error" in data:
            raise Exception(data["error"]["message"])
        
        id_token = data["idToken"]
        decoded_token = auth.verify_id_token(id_token)
        uid = decoded_token["uid"]
        user_record = auth.get_user(uid)

        return {
            "id_token": id_token,
            "uid": user_record.uid,
            "email": user_record.email,
            "display_name": user_record.display_name,
            "phone_number": user_record.phone_number,
            "photo_url": user_record.photo_url
        }


    @action(detail=False, methods=['post'])
    def signup(self,request):
        serializer = UserSerializers(data = request.data)
        if not serializer.is_valid():
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST) 
        
        data = serializer.validated_data
        username = data['username']
        email = data['email']
        password = data['password']

        try:
            if self.check_user_exists(email):
                return Response({"message": "Tài khoản đã tồn tại"}, status=status.HTTP_400_BAD_REQUEST)

            user_record = auth.create_user(
                email = email,
                password = password,
                display_name = username
            )

            self._create_firestore_user(user_record.uid, username, email)

            return Response({"message": "Tạo người dùng thành công"}, status=status.HTTP_200_OK)

        except Exception as e:
            return Response({'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)
    
    @action(detail= False, methods=['post'])    
    def signin(self, request):
        data = request.data
        email = data.get('email', None)
        password = data.get('password', None)

        if not email or not password:
            return Response({"error": "Email và mật khẩu không được để trống"}, status=status.HTTP_401_UNAUTHORIZED)
        
        try:
            user_info = self._firebase_signin(email, password)
            return Response({"user": user_info}, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({"error": 'Email hoặc mật khẩu không đúng'}, status=status.HTTP_401_UNAUTHORIZED)
        
    @action(detail= False, methods=['post'])    
    def google_signin(self,request):
        id_token = request.data.get("id_token")
        if not id_token:
            return Response({"error": "Cần có id_token"}, status=400)

        try:
            decoded_token = auth.verify_id_token(id_token)
            uid = decoded_token["uid"]
            email = decoded_token.get("email", "")
            username = decoded_token.get("name", "")

            user_info = self._create_firestore_user(uid, email, username)

            return Response({"user": user_info}, status= status.HTTP_200_OK)
        except Exception as e:
            return Response({"error": str(e)}, status=status.HTTP_401_UNAUTHORIZED)   

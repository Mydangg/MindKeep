from backend import settings
from django.shortcuts import render
from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from firebase_admin import firestore, auth
from django.contrib.auth import get_user_model
from user_auth.views import UserViewSet
from django.core.mail import send_mail
from permission.authentication import FirebaseAuthentication
from rest_framework.permissions import IsAuthenticated

db = firestore.client()

class ProfileViewSet(viewsets.ViewSet):
    authentication_classes = [FirebaseAuthentication]
    permission_classes = [IsAuthenticated]

    @action(detail= True, methods=['post']) 
    def delete_profile(self, request, pk=None):
        user = request.user
        try:
            auth.delete_user(user.uid)
            db.collection('users').document(user.uid).delete()
            return Response({"message": "Xóa tài khoản thành công"}, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({"error": str(e)},status=status.HTTP_500_INTERNAL_SERVER_ERROR)

    @action(detail= True, methods=['post'])    
    def update_profile(self, request, pk=None):
        user = request.user
        try:
            user_viewset = UserViewSet()
            data = request.data

            if not data:
                return Response({"error": "Dữ liệu không hợp lệ"}, status=status.HTTP_400_BAD_REQUEST)
            
            email = data.get('email')
            display = data.get('display_name')
            if not user_viewset.get_user_by_firebase(pk):
                return Response({"error": "Tài khoản không đã tồn tại"}, status=status.HTTP_400_BAD_REQUEST)

            auth.update_user(
                user.uid,
                email = email,
                display_name = display,
            )

            # db.collection('users').document(user.uid).update({
            #     'email': email,
            #     'display_name': display,
            #     'updated_at': firestore.SERVER_TIMESTAMP
            # })

            update_data = {
                'email': email,
                'display_name': display,
                'updated_at': firestore.SERVER_TIMESTAMP
            }

            if 'emergency_name' in data:
                update_data['emergency_name'] = data.get('emergency_name')

            if 'emergency_phone' in data:
                update_data['emergency_phone'] = data.get('emergency_phone')

            db.collection('users').document(user.uid).update(update_data)

            doc = db.collection('users').document(user.uid).get()
            if not doc.exists:
                return Response({"error": "Không tìm thấy người dùng"}, status=status.HTTP_404_NOT_FOUND)

            return Response({"user": doc.to_dict(), "message":"Cập nhập thành công"},status=status.HTTP_200_OK)
        except Exception as e:
            return Response({"error": str(e)},status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        
    @action(detail= False, methods=['post'])
    def send_feedback(self, request):
        user = request.user
        try:
            if not request.data:
                return Response({"error": "Dữ liệu không hợp lệ"}, status=status.HTTP_400_BAD_REQUEST)
            
            content = request.data.get('content')
            send_mail(
                subject='Feedback từ người dùng',
                message=content,
                from_email= settings.EMAIL_HOST_USER ,
                recipient_list= [user.email],
                fail_silently=False,
            )

            return Response({'message': 'Đã gửi thành công'}, status=status.HTTP_200_OK)
        
        except Exception as e:
            return Response({"error": str(e)},status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        
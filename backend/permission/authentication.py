from rest_framework.authentication import BaseAuthentication
from rest_framework import permissions
from firebase_admin import auth as firebase_auth
from rest_framework import exceptions


class FirebaseUser:
    def __init__(self, record):
        self.uid = record.uid
        self.email = record.email
        self.is_authenticated = True
class FirebaseAuthentication(BaseAuthentication, permissions.BasePermission):
    def authenticate(self, request):
        id_token = request.headers.get('Authorization')
        if not id_token:
            return None

        if id_token.startswith("Bearer "):
            id_token = id_token.split(" ")[1]

        try:
            decoded_token = firebase_auth.verify_id_token(id_token)
        except Exception:
            raise exceptions.AuthenticationFailed("Thông báo token không hợp lệ")
    
        try:
            request.firebase_claims = decoded_token 
            user_record = firebase_auth.get_user(decoded_token['uid'])
        except Exception:
            raise exceptions.AuthenticationFailed("Người dùng không tồn tại")

        firebase_user = FirebaseUser(user_record)
        request.firebase_claims = decoded_token
        return (firebase_user, None)


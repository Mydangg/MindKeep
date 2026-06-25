from rest_framework import permissions

class IsFirebaseAuthenticated(permissions.BasePermission):

    def has_permission(self, request, view):
        return bool(request.user and getattr(request.user, 'is_authenticated', False))
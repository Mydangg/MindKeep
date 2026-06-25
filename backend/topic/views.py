from django.shortcuts import render
from rest_framework.response import Response
from rest_framework import viewsets, status
from rest_framework import viewsets
from firebase_admin import firestore
from backend.utils.firestore_utils import serialize_doc
from permission.authentication import FirebaseAuthentication
from rest_framework.permissions import IsAuthenticated

db = firestore.client()
# Create your views here.
class TopicViewSet(viewsets.ModelViewSet):
    authentication_classes = [FirebaseAuthentication]
    permission_classes = [IsAuthenticated] 

    def list(self, request):
        try:
            doc_ref = db.collection('topics').get()
            topics = [serialize_doc(doc) for doc in doc_ref]
            return Response({"result": topics}, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({"error": str(e)},status=status.HTTP_500_INTERNAL_SERVER_ERROR)
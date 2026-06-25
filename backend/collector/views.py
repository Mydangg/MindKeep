from rest_framework import viewsets, status
from collector.serializers import ColectorSerializers
from permission.authentication import FirebaseAuthentication
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from datetime import datetime
from firebase_admin import firestore

db = firestore.client()

ACTION_CORE = {
    "view": 0.5,
    "like": 1,
    "save": 2
}
# Create your views here.
class CollectorView(viewsets.GenericViewSet,viewsets.ViewSet):
    authentication_classes = [FirebaseAuthentication]
    permission_classes = [IsAuthenticated]

# user behavior(view, like, save)
    def create(self, request):
        user = request.user
        serializer = ColectorSerializers(request.data)
        if not serializer.is_valid():
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        data = serializer.validated_data
        action = data['action']
        article_id = data['article_id']

        try:
            socre = ACTION_CORE[action]
            timestamp = datetime.utcnow

            doc_id = f"{user.uid}_{article_id}"
            doc_ref = db.collection('interactions').document(doc_id)
            doc_ref.set({
                "user_id" : user.uid,
                "article_id": article_id,
                "action": action,
                "score": socre,
                "timestamp": timestamp
            }, merge= True)

            return Response({"result": "Lưu hành vi thành công"}, status=status.HTTP_200_OK)

        except Exception as e:
            return Response({"error": str(e)},status=status.HTTP_500_INTERNAL_SERVER_ERROR)

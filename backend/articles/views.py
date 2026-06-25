import traceback
from rest_framework.response import Response
from rest_framework import viewsets, status
from firebase_admin import firestore
from backend.utils.firestore_utils import serialize_doc
from permission.authentication import FirebaseAuthentication
from rest_framework.permissions import IsAuthenticated
from rest_framework.decorators import action
from datetime import datetime

db = firestore.client()

class ArticlesView(viewsets.GenericViewSet,viewsets.ViewSet):
    authentication_classes = [FirebaseAuthentication]
    permission_classes = [IsAuthenticated]   

    def list(self,request):
        user = request.user
        try:
            doc_ref = db.collection('articles').limit(3).get()
            articles = [serialize_doc(doc) for doc in doc_ref]

            liked_ids = self.get_like_article_ids(user.uid)
            saved_ids = self.get_save_article_ids(user.uid)
            articles = self.attach_liked(articles, liked_ids, saved_ids)
            return Response({"result": articles}, status=status.HTTP_200_OK)
        except Exception as e:
            traceback.print_exc()
            return Response({"error": str(e)},status=status.HTTP_500_INTERNAL_SERVER_ERROR)

    def retrieve(self, request, pk=None):
        try:
            doc_ref = db.collection('articles').document(pk).get()
            if not doc_ref.exists:
                return Response({"error": "Dữ liệu không có"}, status=status.HTTP_400_BAD_REQUEST)
            
            return  Response({"result" : serialize_doc(doc_ref)}, status=status.HTTP_200_OK) 
        except Exception as e:
            traceback.print_exc()
            return Response({"error": str(e)},status=status.HTTP_500_INTERNAL_SERVER_ERROR)

    def attach_liked(self,articles, like_ids, save_ids):
        for article in articles :
            article['liked'] = article['id'] in like_ids
            article['saved'] = article['id'] in save_ids

        return articles

    def get_like_article_ids(self,user_id):
        likes = db.collection('article_like')\
                .where('user_id', '==', user_id)\
                .stream()
        return {doc.to_dict()['article_id'] for doc in likes}
    
    def get_save_article_ids(self, user_id):
        saves = db.collection('article_save')\
                .where('user_id','==', user_id)\
                .stream()
        return {doc.to_dict()['article_id'] for doc in saves}
    
    @action(detail=True, methods=['get'])
    def list_by_topic(self, request, pk=None):
        user = request.user
        try:
            doc_ref = db.collection('articles')
            col_ref = doc_ref.where('topic_id', '==', int(pk)).stream()
            articles = [serialize_doc(doc) for doc in col_ref]

            liked_ids = self.get_like_article_ids(user.uid)
            saved_ids = self.get_save_article_ids(user.uid)
            articles = self.attach_liked(articles, liked_ids, saved_ids)

            if articles: 
                return Response({"result": articles}, status=status.HTTP_200_OK)
            else:
                return Response({"error": "Bài viết không tồn tại"}, status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            traceback.print_exc()
            return Response({"error": str(e)},status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        
    # Extract the article with the highest number of like
    @action(detail=False, methods=['get'])
    def top_article_like(self,request):
        user = request.user
        try:
            top_ref = db.collection('articles')\
                    .order_by('like_count', direction = firestore.Query.DESCENDING)\
                    .limit(1)\
                    .stream()
        
            top_articles = [serialize_doc(doc) for doc in top_ref]
            liked_ids = self.get_like_article_ids(user.uid)
            saved_ids = self.get_save_article_ids(user.uid)
            top_articles = self.attach_liked(top_articles, liked_ids, saved_ids)

            if not top_articles:
                return Response({"error": "Dữ liệu không có"}, status=status.HTTP_404_NOT_FOUND)
            
            return Response({"result": top_articles}, status=status.HTTP_200_OK)
        
        except Exception as e:
            return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

    @action(detail=False, methods=['get'])
    def search(self, request):
        user = request.user
        query_text = request.query_params.get('q', '').strip()
        if not query_text:
             return Response({"error": "Vui lòng nhập từ khóa tìm kiếm"}, status=status.HTTP_400_BAD_REQUEST)
        
        try:
            title_ref = db.collection('articles')
            title_query = title_ref.order_by('title')\
                .start_at([query_text])\
                .end_at([query_text + u'\uf8ff'])\
                .limit(20)\
                .stream()
            title_results = [doc.to_dict() for doc in title_query]

            tag_ref = db.collection('articles')
            tag_query = tag_ref.order_by('tags')\
                .start_at([query_text])\
                .end_at([query_text + u'\uf8ff'])\
                .limit(20)\
                .stream()
            tag_results = [doc.to_dict() for doc in tag_query]

            results_dict = {a['id']: a for a in title_results + tag_results}
            results = list(results_dict.values()) 
            
            liked_ids = self.get_like_article_ids(user.uid)
            saved_ids = self.get_save_article_ids(user.uid)
            result_search = self.attach_liked(results, liked_ids, saved_ids)

            return Response({"result": result_search}, status=status.HTTP_200_OK)
        
        except Exception as e:
            return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

    def update_like_count(self, article_id, change):
        
        if not article_id: return
        try:
            print('hi')
            article_ref = db.collection('articles').document(str(article_id))
            article_ref.update({
                'like_count' : firestore.Increment(change)
            })
        except Exception as e:
            raise e

    @action(detail=True, methods=['post'])
    def toggle_like(self, request, pk=None):
        user = request.user
        article_id = int(pk)

        try:
            like_query = db.collection('article_like') \
                            .where('user_id', '==', user.uid) \
                            .where('article_id', '==', article_id) \
                            .limit(1)\
                            .stream()

            existing_like = None
            for doc in like_query:
                existing_like = doc
                break

            if existing_like is None:
                new_doc_ref = db.collection('article_like').document()
                new_doc_ref.set({
                    "user_id": user.uid,
                    "article_id": article_id,
                    "created_at": firestore.SERVER_TIMESTAMP
                })
                
                self.update_like_count(article_id, 1)

                result = Response({
                    "liked": True
                }, status=status.HTTP_200_OK)

            else:
                db.collection('article_like').document(existing_like.id).delete()
                self.update_like_count(article_id, -1)

                result = Response({
                    "liked": False,
                }, status=status.HTTP_200_OK)

            return result

        except Exception as e:
            return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
    
    @action(detail=True, methods=['post'])
    def toggle_save(self, request, pk=None):
        user = request.user

        article_id = int(pk)

        try:
            save_query = db.collection('article_save') \
                .where('user_id', '==', user.uid) \
                .where('article_id', '==', article_id) \
                .limit(1)\
                .stream()
                       
            existing_save = None
            for doc in save_query:
                existing_save = doc
                break

            if existing_save is None:
                new_doc_ref = db.collection('article_save').document()
                new_doc_ref.set({
                    "user_id": user.uid,
                    "article_id": article_id,
                    "created_at": firestore.SERVER_TIMESTAMP
                })

                result = Response({
                    "save": True
                }, status=status.HTTP_200_OK)

            else:
                db.collection('article_save').document(existing_save.id).delete()

                result = Response({
                    "save": False,
                }, status=status.HTTP_200_OK)

            return result
        except Exception as e:
            return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

    @action(detail=True, methods=['GET'])
    def get_recommended_articles(self, request, pk=None):
        user = request.user
        try:
            article_id = str(pk)
            doc_ref = db.collection('articles')
            current_doc = doc_ref.document(article_id).get().to_dict()
            current_tags = set(current_doc['tags'])

            all_articles = doc_ref.stream()
            recommendations = []

            for doc in all_articles:
                data = doc.to_dict()
                if str(data['id']) == article_id: 
                    continue
                if current_tags.intersection(set(data['tags'])):
                    recommendations.append(data)
            
            liked_ids = self.get_like_article_ids(user.uid)
            saved_ids = self.get_save_article_ids(user.uid)
            propose_articles = self.attach_liked(recommendations[:5], liked_ids, saved_ids)
    
            return Response({"result": propose_articles }, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
    
    # Helper: response list article_id
    def get_article_ids_like_by_user_helper(self, user):
        liked_docs = (
            db.collection('article_like')
            .where('user_id', '==', user.uid)
            .order_by('created_at', direction=firestore.Query.DESCENDING)
            .stream()
        )
        article_ids = [doc.to_dict()['article_id'] for doc in liked_docs]
        return article_ids

    # Response for API
    @action(detail=False, methods=['get'])
    def get_articles_like_by_user(self, request):
        user = request.user
        try:
            article_ids = self.get_article_ids_like_by_user_helper(user)  # call helper

            articles = []
            for i in range(0, len(article_ids), 10):
                chunk = article_ids[i:i + 10]
                doc_ids = [str(article_id) for article_id in chunk]
                docs = db.collection('articles').where('__name__', 'in', doc_ids).stream()
                articles.extend([serialize_doc(doc) for doc in docs])

            liked_ids = set(article_ids)
            saved_ids = set(self.get_save_article_ids(user.uid))

            return Response(
                {"result": self.attach_liked(articles, liked_ids, saved_ids)},
                status=status.HTTP_200_OK
            )
        except Exception as e:
            print("ERROR get_articles_like_by_user:", e)
            return Response({"error": str(e)},  status=status.HTTP_500_INTERNAL_SERVER_ERROR)
     
        
    def get_article_ids_save_by_user_helper(self, user):
        saved_docs = (
            db.collection('article_save')
            .where('user_id', '==', user.uid)
            .order_by('created_at', direction=firestore.Query.DESCENDING)
            .stream()
        )
        article_ids = [doc.to_dict()['article_id'] for doc in saved_docs]
        return article_ids
        
    def create(self, request):
        try:
            data = request.data

            docs = db.collection("articles") \
                .order_by("id", direction=firestore.Query.DESCENDING) \
                .limit(1) \
                .get()

            if docs:
                last_id = docs[0].to_dict().get("id", 0)
                new_id = int(last_id) + 1
            else:
                new_id = 1

            doc_ref = db.collection("articles").document(str(new_id))

            tags = data.get("tags", [])
            if isinstance(tags, str):
                tags = [tags]

            article = {
                "id": new_id,
                "title": data.get("title", ""),
                "description": data.get("description", ""),
                "content": data.get("content", ""),
                "imageUrl": data.get("imageUrl", ""),
                "author": data.get("author", "Người dùng"),
                "topic_id": int(data.get("topic_id", 1)),
                "publishedAt": datetime.now().isoformat(),
                "liked": False,
                "saved": False,
                "like_count": 0,
                "tags": tags,
                "source": "MindKeep",
                "url": ""
            }

            doc_ref.set(article)

            return Response(
                {
                    "message": "Thêm bài viết thành công",
                    "result": article
                },
                status=status.HTTP_201_CREATED
            )

        except Exception as e:
            traceback.print_exc()
            return Response(
                {"error": str(e)},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )   
    @action(detail=False, methods=['get'])
    def get_articles_save_by_user(self, request):
        user = request.user
        try:
            article_ids = self.get_article_ids_save_by_user_helper(user)

            articles = []
            for i in range(0, len(article_ids), 10):
                chunk = article_ids[i:i + 10]
                doc_refs = [
                    db.collection('articles').document(str(article_id))
                    for article_id in chunk
                ]

                docs = (
                    db.collection('articles')
                    .where('__name__', 'in', doc_refs)
                    .stream()
                )
                articles.extend([serialize_doc(doc) for doc in docs])

            liked_ids = set(article_ids)
            saved_ids = set(self.get_save_article_ids(user.uid))

            return Response(
                {"result": self.attach_liked(articles, liked_ids, saved_ids)},
                status=status.HTTP_200_OK
            )
        except Exception as e:
            print("ERROR get_artitcles_like_by_user:", e)
            return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
    

from itertools import chain
from typing import Counter
from django.shortcuts import render
from firebase_admin import firestore
import numpy as np
from rest_framework import viewsets
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework import status
from articles.views import ArticlesView
from permission.authentication import FirebaseAuthentication
from rest_framework.permissions import IsAuthenticated

db = firestore.client()

# Create your views here.
class RecommenderViewSet(viewsets.ViewSet):
    authentication_classes = [FirebaseAuthentication]
    permission_classes = [IsAuthenticated]

    @action(detail= False, methods=['get'])    
    def recommend(self, request):
        try:
            # get all articles user liked/saved
            article_viewset = ArticlesView()
            user_liked = article_viewset.get_article_ids_like_by_user_helper(request.user)
            user_saved = article_viewset.get_article_ids_save_by_user_helper(request.user)  # saved = share
            user_interacted = list(set(user_liked + user_saved))
            if not user_interacted:
                return Response({"recommendations": []}, status=200)
            user_interacted_set = set(user_interacted)

            # get all articles and their tags
            articles_docs = db.collection('articles').stream()
            article_tags = {}
            article_data = {}
            for doc in articles_docs:
                data = doc.to_dict()
                article_tags[data['id']] = data.get('tags', [])
                article_data[data['id']] = data  # save article data for later use

            #  change tags to vectors
            all_tags = list(set(chain.from_iterable(article_tags.values())))
            tag_index = {tag: i for i, tag in enumerate(all_tags)}

            def vectorize(tags):
                vec = np.zeros(len(all_tags), dtype=int)
                for t in tags:
                    if t in tag_index:
                        vec[tag_index[t]] = 1
                return vec

            article_vectors = {aid: vectorize(tags) for aid, tags in article_tags.items()}

            # get user actions (like/share)
            user_actions_ref = db.collection('article_like').where('user_id', '==', request.user.uid)
            user_actions_docs = user_actions_ref.stream()
            user_actions = {doc.to_dict()['article_id']: doc.to_dict().get('action', 'like') for doc in user_actions_docs}

            # filter candidate articles
            user_tags = set(chain.from_iterable(article_tags.get(aid, []) for aid in user_interacted))
            candidate_articles = {aid: vec for aid, vec in article_vectors.items()
                                  if aid not in user_interacted_set and user_tags.intersection(article_tags.get(aid, []))}

            # compute similarity scores
            def cosine_sim(v1, v2):
                return np.dot(v1, v2) / (np.linalg.norm(v1) * np.linalg.norm(v2) + 1e-9)

            scores = Counter()
            for item in user_interacted:
                vec_item = article_vectors.get(item)
                if vec_item is None:
                    continue  # article not found, skip
                weight = 2 if user_actions.get(item) == "share" else 1
                for aid, vec in candidate_articles.items():
                    scores[aid] += cosine_sim(vec_item, vec) * weight

            # get top 3 recommendations
            top_articles = [aid for aid, _ in scores.most_common(3)]
            recommended = []

            for aid in top_articles:
                if aid in article_data:  # article_data contains all article info
                    data = article_data[aid].copy()  
                    data['liked'] = aid in user_liked
                    data['saved'] = aid in user_saved
                    recommended.append(data)

            return Response({"recommendations": recommended}, status=200)

        except Exception as e:
            return Response({"error": str(e)}, status=500)
        
from rest_framework.routers import DefaultRouter
from .views import RecommenderViewSet

router = DefaultRouter(trailing_slash=False)
router.register('', RecommenderViewSet,'recommender')

urlpatterns = router.urls
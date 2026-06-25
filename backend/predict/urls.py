from rest_framework.routers import DefaultRouter
from .views import PredictAIViewSet

router = DefaultRouter(trailing_slash=False)
router.register('', PredictAIViewSet,'predict')

urlpatterns = router.urls

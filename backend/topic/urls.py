from rest_framework.routers import DefaultRouter
from .views import TopicViewSet

router = DefaultRouter(trailing_slash=False)
router.register('', TopicViewSet,'topic')

urlpatterns = router.urls
from rest_framework.routers import DefaultRouter
from .views import ProfileViewSet

router = DefaultRouter(trailing_slash=False)
router.register('', ProfileViewSet,'user')

urlpatterns = router.urls
from rest_framework.routers import DefaultRouter
from .views import PsychTestViewSet

router = DefaultRouter(trailing_slash=False)
router.register('', PsychTestViewSet,'test')

urlpatterns = router.urls
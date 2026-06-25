from rest_framework.routers import DefaultRouter
from .views import CollectorView

router = DefaultRouter(trailing_slash=False)
router.register('', CollectorView,'collector')
urlpatterns = router.urls

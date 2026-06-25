from rest_framework.routers import DefaultRouter
from .views import ArticlesView

router = DefaultRouter(trailing_slash=False)
router.register('', ArticlesView, basename='articles')

urlpatterns = router.urls
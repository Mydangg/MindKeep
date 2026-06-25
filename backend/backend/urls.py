from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/auth/', include('user_auth.urls')),
    path('api/profile/', include('user.urls')),
    path('api/predict/', include('predict.urls')),
    path('api/test/', include('psych_test.urls')),
    path('api/articles/', include('articles.urls')),
    path('api/topics/', include('topic.urls')),
    path('api/collector/', include('collector.urls')),
    path('api/recommender/', include('recommender.urls')),
]

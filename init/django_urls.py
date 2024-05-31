# urls.py
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import ReservationViewSet, UserViewSet, MovieViewSet

router = DefaultRouter()
router.register(r'reservations', ReservationViewSet)
router.register(r'users', UserViewSet)
router.register(r'movies', MovieViewSet)

urlpatterns = [
    path('', include(router.urls)),
]
    
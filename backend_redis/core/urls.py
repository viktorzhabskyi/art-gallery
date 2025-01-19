from django.urls import path
from . import views

urlpatterns = [
    path('redis/test_connection/', views.test_connection, name='test_connection'),
]

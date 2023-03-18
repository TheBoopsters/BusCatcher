from django.urls import path, include
from rest_framework_nested import routers

from . import views

router = routers.DefaultRouter()
router.register(r'buses', views.BusViewSet, basename='buses')
router.register(r'routes', views.RouteViewSet, basename='routes')

routes_router = routers.NestedSimpleRouter(router, r'routes', lookup='route')
routes_router.register(r'stops', views.StopViewSet, basename='route-stops')

urlpatterns = [
    path('', include(router.urls)),
    path('', include(routes_router.urls)),
    path('api-auth/', include('rest_framework.urls', namespace='rest_framework')),
]

from django.shortcuts import render
from rest_framework import viewsets, views
from .models import Bus, Route, Stop
from .serializers import BusSerializer, RouteSerializer, RouteListSerializer, StopSerializer
from .permissions import IsSuperUser, IsAnonymous

class NestedModelViewSet(viewsets.ModelViewSet):
    """
    Nested model view sets can access all parent object IDs in their context.
    """
    def get_serializer_context(self):
        context = super().get_serializer_context()

        for key, value in self.kwargs.items():
            if key.endswith('_pk'):
                context[f'{key[:-3]}_id'] = value

        return context
    
    def get_permissions(self):
        if self.action in ('retrieve', 'list'):
            self.permission_classes = [IsAnonymous]
        else:
            self.permission_classes = [IsSuperUser]

        return super().get_permissions()

class BusViewSet(NestedModelViewSet):
    """
    API endpoint that allows buses to be viewed or edited.
    """
    serializer_class = BusSerializer

    def get_queryset(self):
        return Bus.objects.order_by('name')

class RouteViewSet(NestedModelViewSet):
    """
    API endpoint that allows routes to be viewed or edited.
    """
    def get_queryset(self):
        return Route.objects.order_by('name')

    def get_serializer_class(self):
        if self.action == 'list':
            return RouteListSerializer

        return RouteSerializer

class StopViewSet(NestedModelViewSet):
    """
    API endpoint that allows stops to be viewed or edited.
    """
    serializer_class = StopSerializer

    def get_queryset(self):
        return Stop.objects.filter(route=self.kwargs['route_pk']).order_by('order_id')
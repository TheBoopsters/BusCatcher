from django.db.models.query_utils import Q
from django.core.cache import cache
from rest_framework import serializers
from .models import Bus, Route, Stop
from buscatcher import settings
import googlemaps
import json

class RouteListSerializer(serializers.ModelSerializer):

    class Meta:
        model = Route
        exclude = []
        depth = 1

    def create(self, validated_data):
        if Route.objects.filter(name=self.initial_data['name']).exists():
            raise serializers.ValidationError({'name': ['A route with this name already exists!']})

        return super().create(validated_data)

    def update(self, instance, validated_data):
        name = validated_data.get('name')

        if instance.name != name and Route.objects.filter(name=name).exists():
            raise serializers.ValidationError({'name': ['A route with this name already exists!']})
    
        return super().update(instance, validated_data)

class StopSerializer(serializers.ModelSerializer):

    class Meta:
        model = Stop
        exclude = ['route']
        depth = 1

    def create(self, validated_data):
        route_id = self.context['route_id']
        validated_data['route'] = Route.objects.get(pk=route_id)

        if Stop.objects.filter(route_id=route_id, name=self.initial_data['name']).exists():
            raise serializers.ValidationError({'name': ['A stop with this name already exists!']})

        return super().create(validated_data)

    def update(self, instance, validated_data):
        name = validated_data.get('name')

        if instance.name != name and Stop.objects.filter(route_id=instance.route_id, name=name).exists():
            raise serializers.ValidationError({'name': ['A stop with this name already exists!']})
    
        return super().update(instance, validated_data)

class RouteSerializer(RouteListSerializer):
    stops = StopSerializer(source='stop_set', many=True, read_only=True)
    polylines = serializers.SerializerMethodField('query_polyline')

    def format_step_hash(self, step):
        return f'{step.name}-{step.latitude}-{step.longitude}'

    def query_polyline(self, obj):
        stops = list(obj.stop_set.all())

        if len(stops) < 2:
            return None

        hash_key = hash('\n'.join([self.format_step_hash(step) for step in stops]))
        cache_key = f'polyline-{hash_key}'
        polyline = cache.get(cache_key, None)

        if polyline:
            return polyline

        first_stop = stops[0]
        last_stop = stops[-1]
        intermediate_stops = stops[1:-1]

        client = googlemaps.Client(key=settings.GOOGLE_MAPS_KEY)
        directions = client.directions(
            origin=self.format_latitude(first_stop),
            destination=self.format_latitude(last_stop),
            mode='driving',
            waypoints=[self.format_latitude(stop) for stop in intermediate_stops],
            alternatives=False
        )
        route = directions[0]
        polyline = route['overview_polyline']['points']

        cache.set(cache_key, polyline)

        return polyline

    def format_latitude(self, stop):
        return f'{stop.latitude},{stop.longitude}'

class RelatedRouteField(serializers.PrimaryKeyRelatedField):

    def get_queryset(self):
        return Route.objects.all()

class BusSerializer(serializers.ModelSerializer):
    route = RouteListSerializer(read_only=True)
    route_id = RelatedRouteField(source='route', write_only=True)

    class Meta:
        model = Bus
        exclude = []
        depth = 1

    def create(self, validated_data):
        if Bus.objects.filter(name=self.initial_data['name']).exists():
            raise serializers.ValidationError({'name': ['A bus with this name already exists!']})

        return super().create(validated_data)

    def update(self, instance, validated_data):
        name = validated_data.get('name')

        if instance.name != name and Bus.objects.filter(name=name).exists():
            raise serializers.ValidationError({'name': ['A bus with this name already exists!']})
    
        return super().update(instance, validated_data)

from django.db.models.query_utils import Q
from rest_framework import serializers
from .models import Bus, Route, Stop

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

        if Stop.objects.filter(name=self.initial_data['name']).exists():
            raise serializers.ValidationError({'name': ['A stop with this name already exists!']})

        return super().create(validated_data)

    def update(self, instance, validated_data):
        name = validated_data.get('name')

        if instance.name != name and Stop.objects.filter(name=name).exists():
            raise serializers.ValidationError({'name': ['A stop with this name already exists!']})
    
        return super().update(instance, validated_data)

class RouteSerializer(RouteListSerializer):
    stops = StopSerializer(source='stop_set', many=True, read_only=True)

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

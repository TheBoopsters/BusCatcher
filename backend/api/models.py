from django.db import models

class Route(models.Model):
    id = models.BigAutoField(primary_key=True)
    name = models.CharField(max_length=255)

    class Meta:
        constraints = [
            models.UniqueConstraint(fields=['name'], name='unique_route_name')
        ]
    
    def __str__(self):
        return f'Route {self.name}'

class Stop(models.Model):
    id = models.BigAutoField(primary_key=True)
    route = models.ForeignKey(Route, on_delete=models.CASCADE)
    name = models.CharField(max_length=255)
    order_id = models.IntegerField()
    latitude = models.DecimalField(max_digits=22, decimal_places=16, blank=True, null=True)
    longitude = models.DecimalField(max_digits=22, decimal_places=16, blank=True, null=True)

    class Meta:
        constraints = [
            models.UniqueConstraint(fields=['route', 'name'], name='unique_stop_name')
        ]

class Bus(models.Model):
    id = models.BigAutoField(primary_key=True)
    route = models.ForeignKey(Route, on_delete=models.CASCADE)
    number = models.CharField(max_length=255)
    name = models.CharField(max_length=255)

    class Meta:
        constraints = [
            models.UniqueConstraint(fields=['name'], name='unique_bus_name')
        ]
# Generated by Django 4.1.7 on 2023-03-18 23:16

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0002_bus_number'),
    ]

    operations = [
        migrations.RemoveConstraint(
            model_name='stop',
            name='unique_stop_name',
        ),
        migrations.AddConstraint(
            model_name='stop',
            constraint=models.UniqueConstraint(fields=('route', 'name'), name='unique_stop_name'),
        ),
    ]

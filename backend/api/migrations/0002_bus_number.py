# Generated by Django 4.1.7 on 2023-03-18 12:13

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0001_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='bus',
            name='number',
            field=models.CharField(default='', max_length=255),
            preserve_default=False,
        ),
    ]
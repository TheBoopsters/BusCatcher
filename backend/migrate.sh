#!/bin/sh
set -e

python3 -OO manage.py makemigrations api
python3 -OO manage.py migrate
#python3 -OO manage.py collectstatic
#!/bin/sh

# Apply database migrations
echo "Apply database migrations"
/usr/local/bin/python manage.py migrate

# Start server
echo "Starting server"
/usr/local/bin/python manage.py runserver 0.0.0.0:8000

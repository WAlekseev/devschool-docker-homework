# docker_homework
# 1 Лекция
Написать Dockerfile для frontend, собрать и запустить

## Ответ

### Dockerfile
```
# # # # # # # # # 
#  Build Stage  #
# # # # # # # # # 

# Latest node and alpine as base image
FROM node:alpine as builder 

# Working directory
WORKDIR '/app'

# Copy the dependencies file for npm
COPY package.json .

# Install dependencies
RUN npm install

# Copy frontend code
COPY . .

# Build the project for production
RUN npm run build 

# # # # # # # # #
#  Final Stage  #
# # # # # # # # #

# Build final image for production
FROM nginx:alpine

#Copy production build files from builder phase to nginx
COPY --from=builder /app/build /usr/share/nginx/html

#Copy virtual host configuration file
COPY config/default.conf /etc/nginx/conf.d/default.conf
```
### Build and run
```
# Build image 
docker build -t devschool/frontend .

# Test image
docker run -p 3000:80 devschool/frontend .
```
# 2 Лекция
Написать Dockerfile для lib_catalog, postgresql, собрать и запустить
## Ответ

### Dockerfile for lib_catalog (backend)
```
# # # # # # # # # # 
#  Backend build  #
# # # # # # # # # # 

# Pull official python image
FROM python:3.9.7-alpine

# Working directory
WORKDIR /usr/src/app

# Environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Update pip, setuptools and install base dependencies
RUN pip install --upgrade pip && \
    pip install --upgrade setuptools && \
    apk add --update --no-cache libpq

# Install extra dependencies for backend
COPY ./requirements.txt .

RUN apk add --update --no-cache --virtual .build-deps postgresql-dev libxml2-dev libxslt-dev libxslt gcc libc-dev && \
    pip install --no-cache-dir -r requirements.txt && \
    apk --purge del .build-deps

# Copy frontend code
COPY . .

#CMD ["/usr/local/bin/python", "manage.py", "runserver", "0.0.0.0:8000"]
```

### Dockerfile for postgres (database)
```
# # # # # # # # # #
#  Postgres image #
# # # # # # # # # #

FROM postgres

COPY postgres.conf /etc/postgresql/
```
### Build and run 
```
# Build image 
docker build -t devschool/backend .

# Run postgresql
docker run --name database -p 5432:5432 -e POSTGRES_PASSWORD=django -e POSTGRES_USER=django -e POSTGRES_DATABASE=django -d postgres

# Test image
docker run -p 8000:8000 --name lib_catalog devschool/backend

```


# 3 Лекция
Написать docker-compose.yaml, для всего проекта, собрать и запустить

## Ответ

### docker-compose.yml
```
version: '3.8'
services: 
  # APP FRONTEND
  front:
    build:
      context: ./frontend
#      args:
#        - BACKEND_URL='${APP_API_URL}'
    ports: 
        - 3000:80
    depends_on: 
        - backend

  # BACKEND
  backend:
    build:
      context: ./lib_catalog
#      args: 
#         - DB_HOST=${DB_HOST}
#         - DB_DATABASE=${DB_NAME}
#         - DB_USERNAME=${DB_USER}
#         - DB_PASS=${DB_PASSWORD}'
#         - BACKEND_URL=${APP_API_URL}
    command: /bin/sh -c "python manage.py migrate && python manage.py runserver 0.0.0.0:8000"
    ports: 
        - 8000:8000
    depends_on:
        - database

  # DATABASE
  database:
    build:
      context: ./db
    image: postgres:12-alpine
#    volumes: 
#        - postgres_data:/var/lib/postgresql/data/
    ports: 
        - 5432:5432
    environment: 
        - POSTGRES_DB=${DB_NAME}
        - POSTGRES_USER=${DB_USER}
        - POSTGRES_PASSWORD=${DB_PASSWORD}
        - POSTGRES_HOST_AUTH_METHOD=trust
#volumes:
#   postgres_data:
```

### Run
```
docker-compose up
```

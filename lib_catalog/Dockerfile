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
#RUN apk add --update --no-cache postgresql-dev py3-lxml py3-libxml2 libxml2-dev libxml2 libxml2-utils libxslt-dev libxslt gcc g++ libc-dev libffi-dev python3-dev

RUN apk add --update --no-cache --virtual .build-deps postgresql-dev libxml2-dev libxslt-dev libxslt gcc libc-dev && \
    pip install --no-cache-dir -r requirements.txt && \
    apk --purge del .build-deps

# Copy frontend code
COPY . .

#CMD ["/usr/local/bin/python", "manage.py", "runserver", "0.0.0.0:8000"]

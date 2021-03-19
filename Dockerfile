FROM python:3.7

WORKDIR /home/werkspot

RUN apt-get update
RUN apt-get install -y -qq jq
RUN pip install --upgrade pip

COPY requirements.txt /tmp/requirements.txt

RUN pip install -r /tmp/requirements.txt

RUN dbt --version

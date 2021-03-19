FROM python:3.7

WORKDIR /home/werkspot

RUN apt-get update
RUN apt-get install -y -qq jq
RUN pip install --upgrade pip

COPY requirements.txt /tmp/requirements.txt

COPY models /home/werkspot/models
COPY scripts /home/werkspot/scripts
COPY event_log.csv /home/werkspot/event_log.csv
COPY dbt_project.yml /home/werkspot/dbt_project.yml
COPY profiles.yml /home/werkspot/profiles.yml
COPY bin/provision.sh /home/werkspot/bin/provision.sh

RUN pip install -r /tmp/requirements.txt

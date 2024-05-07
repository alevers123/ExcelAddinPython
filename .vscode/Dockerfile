FROM ubuntu:latest as base

WORKDIR /usr/src/app
COPY ./requirements.txt ./requirements.txt
# RUN pip3 install --break-system-packages --no-cache-dir -r requirements.txt
RUN apt-get update
RUN xargs apt install -y <./requirements.txt 
ENV FLASK_ENV="docker"
ENV FLASK_APP=app.py
EXPOSE 5000

FROM base as develop
ARG GID
ARG UID 
ARG UNAME 
ARG BLA
RUN echo ${BLA}
RUN echo "${UNAME}, ${UID}, ${GID}" 
RUN echo "hallo"
RUN apt-get update && apt install -y sudo && apt install -y adduser &&\ 
groupadd -g ${GID} -o ${UNAME} && \
sudo adduser --ingroup ${UNAME} -u ${UID} --disabled-password --gecos "" ${UNAME} && \
echo "${UNAME} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
USER ${UNAME}

FROM base as debug
# RUN pip install ptvsd debugpy
# Keeps Python from generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE 1
# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED 1

# FROM base as prod
# RUN pip install gunicorn
# COPY . .
# CMD ["gunicorn", "--reload", "--bind", "0.0.0.0:5000", "app:app"]
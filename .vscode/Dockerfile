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
ARG WORKSP=/home/${UNAME}/workspace
RUN echo ${WORKSP}
RUN apt-get update && apt install -y sudo && apt install -y adduser && \ 
groupadd -g ${GID} -o ${UNAME} && \
sudo adduser --ingroup ${UNAME} -u ${UID} --disabled-password --gecos "" ${UNAME} && \
echo "${UNAME} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && mkdir ${WORKSP} && mkdir ${WORKSP}/.vscode 
COPY  --from=vscode ./launch.json ${WORKSP}/.vscode/
USER ${UNAME}
WORKDIR ${WORKSP} 

FROM base as debug
# RUN pip install ptvsd debugpy
# Keeps Python from generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE 1
# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED 1
COPY --from=prv_certificate ./key.pem /etc/ssl/private/
COPY --from=prv_certificate ./certificate.crt /etc/ssl/public
RUN mkdir flask_context
COPY --from=dbg_web_server ./.flaskenv /flask_context
ENTRYPOINT [ "python3", "-m", "debugpy", "--listen", "0.0.0.0:5678",  ]
# FROM base as prod
# RUN pip install gunicorn
# COPY . .
# CMD ["gunicorn", "--reload", "--bind", "0.0.0.0:5000", "app:app"]
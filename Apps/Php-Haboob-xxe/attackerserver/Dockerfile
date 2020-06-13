FROM python:2.7
COPY ./src /app
WORKDIR /app
ARG LPORT
ENV SERVERLPORT=${LPORT}
RUN apt-get update && apt-get install -y netcat
ENTRYPOINT python -m SimpleHTTPServer ${SERVERLPORT} 2>&1 | tee httplog.txt

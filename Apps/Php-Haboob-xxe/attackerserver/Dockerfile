FROM python:2.7
COPY ./src /app
WORKDIR /app
ARG LPORT
ENV SERVERLPORT=${LPORT}
ENTRYPOINT python -m SimpleHTTPServer ${SERVERLPORT}
#ENTRYPOINT ["python", "-m", "SimpleHTTPServer", "${SERVERLPORT}"]

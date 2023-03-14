FROM golang
RUN git clone https://github.com/HLOverflow/aws-mock-metadata.git
WORKDIR /go/aws-mock-metadata/
RUN touch .env
ENV APP_PORT=8111
ENV ROLE_NAME=mock-user
RUN make build
ENTRYPOINT bin/aws-mock-metadata --mock-instance-profile=true --app-port ${APP_PORT} --role-name ${ROLE_NAME}

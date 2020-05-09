FROM golang
RUN git clone https://github.com/priorax/mock-ec2-metadata.git
WORKDIR /go/mock-ec2-metadata/
RUN make deps && make
ENTRYPOINT /go/mock-ec2-metadata/bin/mock-ec2-metadata_0.4.1_linux_amd64

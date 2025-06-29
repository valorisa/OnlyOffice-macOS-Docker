FROM ubuntu:25.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && \
    apt-get install -y python python3 sudo wget curl git build-essential \
    ca-certificates locales && \
    locale-gen en_US.UTF-8

RUN rm /usr/bin/python && ln -s /usr/bin/python2 /usr/bin/python

WORKDIR /build_tools

COPY . /build_tools

CMD ["sh", "-c", "cd tools/linux && python3 ./automate.py desktop"]

FROM centos:centos7

# This dockerfile is used to generate a immutable testing environment for jenkinsinfra/k8s project

MAINTAINER Olblak <me@olblak.com>

LABEL description="Testing environment for jenkinsinfra/k8s"

RUN adduser docker -m

RUN \
    yum update -y && \
    yum install -y make gpg openssh-clients epel-release && \
    yum clean all

RUN \
    yum update -y && \
    yum install -y bats git&& \
    yum clean all


USER docker

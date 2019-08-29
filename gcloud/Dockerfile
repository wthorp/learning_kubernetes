
##################################################
## THIS IS THE BUILD, NON-DEPLOYED DOCKER STAGE ##
##################################################

#FROM google/cloud-sdk:latest AS build
FROM golang:1.12.9-alpine3.10 AS build

RUN apk update
RUN apk upgrade

# GCLOUD AND GSUTIL
ARG CLOUD_SDK_VERSION=255.0.0
ENV CLOUD_SDK_VERSION=$CLOUD_SDK_VERSION
ENV PATH /google-cloud-sdk/bin:$PATH
RUN /sbin/apk --no-cache add curl python py-crcmod bash libc6-compat openssh-client git gnupg
RUN curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz
RUN tar xzf google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz
RUN rm google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz
#RUN gcloud config set core/disable_usage_reporting true
#RUN gcloud config set component_manager/disable_update_check true
#RUN gcloud config set metrics/environment github_docker_image

#KOPS
ARG KOPS_VERSION=1.12.2
ENV KOPS_VERSION=$KOPS_VERSION
RUN curl -Lo kops https://github.com/kubernetes/kops/releases/download/${KOPS_VERSION}/kops-linux-amd64 && \
    chmod +x ./kops && \
    mv ./kops /usr/local/bin/

#KUBECTL
ARG KUBECTL_VERSION=v1.15.1
ENV KUBECTL_VERSION=$KUBECTL_VERSION
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/

#HELM
ARG HELM_VERSION=2.14.2
ENV HELM_VERSION=$HELM_VERSION
RUN curl -L https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz | tar -xz && \
    chmod +x ./linux-amd64/helm && \
    mv ./linux-amd64/helm /usr/local/bin/helm && \
    mv ./linux-amd64/tiller /usr/local/bin/tiller && \
    rm -r linux-amd64 && \
    # init plugin directories
    helm init --client-only && \
    helm plugin install https://github.com/databus23/helm-diff --version master

#CFSSL
ARG CFSSL_VERSION=1.2
ENV CFSSL_VERSION=$CFSSL_VERSION
RUN wget -q https://pkg.cfssl.org/R${CFSSL_VERSION}/cfssl_linux-amd64 \
        https://pkg.cfssl.org/R${CFSSL_VERSION}/cfssljson_linux-amd64 && \
    chmod +x cfssl_linux-amd64 cfssljson_linux-amd64 && \
    mv cfssl_linux-amd64 /usr/local/bin/cfssl && \
    mv cfssljson_linux-amd64 /usr/local/bin/cfssljson

# runtime bind local kube configs, so kubectl works
VOLUME /root/.kube

COPY ./gcloud/test-script.sh .

# Bash
CMD [ "/bin/bash"]

FROM alpine
LABEL maintainer="codesenju@gmail.com"
RUN apk add --no-cache \
        bash \
        py-pip \
        terraform \
      #  openssh-keygen \
      #  openssl \
 && pip install --upgrade \
        pip \
        awscli
WORKDIR /project-folder
# copy all .tf files to project-folder
COPY *.tf . 

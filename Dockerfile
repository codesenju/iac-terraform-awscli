FROM alpine
LABEL maintainer="codesenju@gmail.com"
#WORKDIR /opt/terraform
#RUN wget -o /tmp/terraform.zip https://releases.hashicorp.com/terraform/0.12.28/terraform_0.12.28_linux_amd64.zip
#COPY terraform_0.12.28_linux_amd64.zip /tmp/terraform.zip
#RUN unzip /tmp/terraform.zip -d /opt/terraform && apk add ca-certificates curl
#COPY main.tf .

#RUN chmod -R 777 /opt/terraform && ./terraform init

RUN apk add --no-cache \
        bash \
        py-pip \
        terraform \
 && pip install --upgrade \
        pip \
        awscli
WORKDIR /project-folder
#RUN chmod -R 777 /project-folder
#RUN chmod -R 777 /root
COPY *.tf .
#ENTRYPOINT [ "/bin/bash" ]

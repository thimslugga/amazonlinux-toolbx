FROM public.ecr.aws/amazonlinux/amazonlinux:2

ENV NAME=amznlinux2-toolbox VERSION=2
LABEL com.github.containers.toolbox="true" \
  com.github.debarshiray.toolbox="true" \
  name="$NAME" \
  version="$VERSION" \
  usage="This image is meant to be used with the toolbox command" \
  summary="Base image for creating Amazon Linux 2 toolbox containers"

COPY README.md /

RUN sed -i '/tsflags=nodocs/d' /etc/yum.conf

COPY packages /
RUN yum -y install $(<packages)

COPY extra-packages /
RUN amazon-linux-extras install -y $(<extra-packages)

COPY missing-docs /
RUN yum -y reinstall $(<missing-docs)

RUN rm /{packages,extra-packages,missing-docs}

RUN yum clean all

RUN sed -i -e 's/ ALL$/ NOPASSWD:ALL/' /etc/sudoers
RUN echo 'Defaults lecture="never"' > /etc/sudoers.d/disable-sudo-lecture

RUN echo VARIANT_ID=container >> /etc/os-release
RUN ln -s /etc/os-release /usr/lib/os-release

CMD /bin/sh

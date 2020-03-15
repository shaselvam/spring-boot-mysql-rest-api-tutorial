FROM centos:centos7

# Yum workaround to stalled mirror
RUN sed -i -e 's/enabled=1/enabled=0/g' /etc/yum/pluginconf.d/fastestmirror.conf
RUN sed -i -e 's$\#baseurl\=http\:\/\/mirror.centos.org\/centos\/\$releasever\/updates\/\$basearch\/$baseurl\=http\:\/\/mirror.centos.org\/centos\/\$releasever\/updates\/\$basearch\/$g' /etc/yum.repos.d/CentOS-Base.repo

RUN rm -f /var/lib/rpm/__*
RUN rpm --rebuilddb -v -v
RUN yum clean all

ENV CA_CERTIFICATES_JAVA_VERSION 20140324

RUN yum -y update nss nss-softokn nss-softokn-freebl nss-util sqlite
RUN yum -v install -y \
    wget \
    zip \
    openssh-client \
    unzip \
    java-1.8.0-openjdk \
    && yum clean all

COPY target/*jar /home/ec2-user/

RUN chmod -R 777 /home/ec2-user/

# Expose ports.
EXPOSE 8080
EXPOSE 443

WORKDIR /home/ec2-user
CMD ["java", "-jar", "easy-notes-1.0.0.jar"]

FROM centos:latest
MAINTAINER yilisa <915961521@qq.com>

##
#set env here
##
ENV RABBITMQ_VERSION 3.3.5

##
#step 0: pre
##
RUN yum install -y epel-release yum-axelget
RUN yum -y update

##
#step 1: ssh
##
#install ssh
RUN yum -y install openssh-server openssh-clients
#generate ssh key
RUN ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key && \
    ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key && \
    ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key && \
    ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key && \
    RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
#configure: no password login
RUN cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \ 
    sed -i 's/session    required     pam_loginuid.so/#session    required     pam_loginuid.so/g' /etc/pam.d/sshd && \
    cd ~/.ssh/ && \
    touch config && \
    echo "StrictHostKeyChecking no" >> ~/.ssh/config
 
##
#step 2: rabbitmq
##
#install rabbitmq and configure       
RUN yum install rabbitmq-server -y && \
    rabbitmq-plugins enable rabbitmq_management && rabbitmq-plugins enable rabbitmq_management_agent

# ssh port: 22
# rabbitmq related ports :4369 5671 5672 25672
EXPOSE 15672 5672 25672 22

CMD ["rabbitmq-server"]

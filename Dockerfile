FROM centos:latest

WORKDIR /opt/work

USER root

ENV LANG en_US.UTF-8 
ENV LANGUAGE en_US:en 
ENV LC_ALL en_US.UTF-8

ENV TZ=Asia/Taipei
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN yum -y install vim tmux crontabs java-1.8.0-openjdk-devel openssh openssh-server sudo \
    && yum clean all \ 
    && useradd -ms /bin/bash  golden && echo "golden:golden07611" | chpasswd \
    && chmod u+w /etc/sudoers \ 
    && echo 'golden ALL=(ALL) ALL' >> /etc/sudoers \
    && chmod u-w /etc/sudoers \
    && sed -i '17s/.*/Port 2022/' /etc/ssh/sshd_config \
    && sed -i '46s/.*/PermitRootLogin no/' /etc/ssh/sshd_config \
    && sed -i '104s/.*/UsePAM no/' /etc/ssh/sshd_config \
    && mkdir /automnt \
    && mkdir /automnt/hanktemp \ 
    && /usr/bin/ssh-keygen -A    

CMD ["/usr/sbin/sshd", "-D"]

EXPOSE 2022



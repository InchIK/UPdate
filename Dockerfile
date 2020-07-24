FROM centos:7
MAINTAINER kungyc@gmail.com

USER root

#設定語系
RUN yum install kde-l10n-Chinese -y
RUN yum install glibc-common -y
RUN localedef -c -f UTF-8 -i zh_TW zh_TW.utf8
RUN echo "export LC_ALL=zh_TW.UTF-8" >> /etc/profile
RUN source /etc/profile
RUN echo "LANG="zh_TW.UTF-8"" >> /etc/locale.conf
ENV LANG zh_TW.UTF-8
ENV LC_ALL zh_TW.UTF-8
 
#設定時區
ENV TZ=Asia/Taipei
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

#設定變數
ARG ROOT_PW
ARG USER_PW

RUN yum -y install vim tmux crontabs java-1.8.0-openjdk-devel openssh openssh-server sudo \
    && yum clean all \ 
    && useradd -ms /bin/bash  golden && echo "golden:$USER_PW" | chpasswd \
    && echo "root:$ROOT_PW" | chpasswd \
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



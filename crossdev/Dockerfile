FROM debian:11-slim

ARG DEBIAN_FRONTEND=noninteractive
ARG TZ=Asia/Shanghai

ENV LANG C.UTF-8

SHELL [ "/bin/bash", "-c" ]

# 安装系统常用工具
ADD ./script/base.sh /tmp/base.sh
RUN /tmp/base.sh

# 配置BASH、SSH地区语言和显示色彩
ARG SSH_PORT=22222
ADD ./script/bashrc /tmp/bashrc
RUN echo "${LANG} UTF-8" > /etc/locale.gen && \
  echo "${LANG}" >> /etc/default/locale && \
  ln -fs /usr/share/zoneinfo/$TZ /etc/localtime && \
  dpkg-reconfigure locales tzdata && \
  sed -i 's/^%sudo.*/%sudo ALL=(ALL:ALL) NOPASSWD:ALL/' /etc/sudoers && \
  sed -i "s/^#Port.*/Port ${SSH_PORT}/g" /etc/ssh/sshd_config && \
  sed -i "s/^#HostKey \/etc\/ssh\/\(.*\)/HostKey \/etc\/ssh\/hostkey\/\1/g" /etc/ssh/sshd_config && \
  sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config && \
  mkdir -p /run/sshd /etc/ssh/hostkey/ && mv /etc/ssh/ssh_host_* /etc/ssh/hostkey/ && \
  printf "\nexport LANG=${LANG}\n" >> /etc/profile && \
  cat /tmp/bashrc >> /etc/bash.bashrc && rm -rf /tmp/bashrc

# 根据构建参数构建开发环境
ARG GIT_USER_NAME=
ARG GIT_USER_MAIL=
ARG GIT_GPG_KEY=
ARG UID=501
ARG GID=20
ARG USER_NAME=dev
ARG USER_HOME=/home/dev
ARG GROUP_NAME=staff
ARG CONFIGS=python:3.11.3;frontend:18.16.0
ADD script/build.sh /tmp/build/build.sh
ADD script/config /tmp/build/config
RUN CONFIG_PATH=/tmp/build/config /tmp/build/build.sh

# 清理不需要的内容
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/*

ADD script/run.sh /usr/local/sbin/crossdev
CMD [ "/usr/local/sbin/crossdev" ]
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
ARG UID=
ARG USER_NAME=
ARG USER_HOME=
ARG GID=
ARG GROUP_NAME=
ARG CONFIGS=python:3.10.4;frontend:16.14.2
ADD script/build.sh /tmp/build/build.sh
ADD script/config /tmp/build/config
ADD authorized_keys /tmp/build/authorized_keys
RUN AUTH_KEY_PATH=/tmp/build/authorized_keys CONFIG_PATH=/tmp/build/config /tmp/build/build.sh

# 根据条件安装vscode的服务端
ARG VSCODE_VERSION=
ADD script/vscode.sh /tmp/build/vscode.sh
RUN sudo -u ${USER_NAME} --preserve-env=VSCODE_VERSION /tmp/build/vscode.sh

# 清理不需要的内容
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/*

ADD script/run.sh /usr/local/sbin/crossdev
CMD [ "/usr/local/sbin/crossdev" ]
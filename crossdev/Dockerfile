FROM golang AS additional_builder
ARG GOPROXY=https://proxy.golang.com.cn,direct
RUN git clone https://ghproxy.com/https://github.com/lintingzhen/commitizen-go && cd commitizen-go && \
	git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)` && \
	make && make install && \
	go install mvdan.cc/sh/v3/cmd/shfmt@latest

FROM debian:11-slim
ARG DEBIAN_FRONTEND=noninteractive
ARG TZ=Asia/Shanghai
ARG BUILDER=crossdev

ENV LANG C.UTF-8

SHELL [ "/bin/bash", "-c" ]

# install system base
ADD ./scripts/init.sh /tmp/init.sh
ARG APT_MIRROR=mirrors.ustc.edu.cn
RUN /tmp/init.sh

# configure development environment
ADD ./conf/ /
ADD ./scripts/build /tmp/build
USER ${BUILDER}
ARG CONFIGS=python:3.11.3;frontend:18.16.0;go:1.20.3;rust:1.69.0;ruby:3.2.2;java:20.0.1
RUN /tmp/build/build.sh
COPY --from=additional_builder /usr/lib/git-core/git-cz /usr/lib/git-core/
COPY --from=additional_builder /go/bin/shfmt /usr/local/bin/shfmt

USER root
# configure sshd
ARG SSH_PORT=22222
RUN /tmp/build/sshd.sh

# custom define user data
ADD ./scripts/chown.sh /tmp/chown.sh
ARG GID
ARG GROUP_NAME
ARG UID
ARG USER_HOME
ARG USER_NAME=${BUILDER}
RUN /tmp/chown.sh

# custom build something
ADD ./scripts/custom /tmp/custom
RUN /tmp/custom/build.sh

# clear
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/*

USER ${USER_NAME}
ENV GIT_AUTHOR_NAME=
ENV GIT_AUTHOR_EMAIL=
ENV GIT_SIGNINGKEY=
ADD scripts/entrypoint.sh /.crossdev/entrypoint.sh
ENTRYPOINT [ "/.crossdev/entrypoint.sh" ]

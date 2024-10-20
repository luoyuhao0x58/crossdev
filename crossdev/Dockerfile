FROM golang AS additional_builder
ARG GOPROXY=https://proxy.golang.com.cn,direct
RUN git clone https://github.com/lintingzhen/commitizen-go && cd commitizen-go && \
	git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)` && \
	make && make install && \
	go install mvdan.cc/sh/v3/cmd/shfmt@latest

FROM debian:12-slim
ARG DEBIAN_FRONTEND=noninteractive
ARG TZ=Asia/Shanghai
ARG BUILDER=crossdev
ARG BUILDER_HOME=/.${BUILDER}
ARG BUILDER_ID=54321

ENV LANG C.UTF-8

SHELL [ "/bin/bash", "-c" ]

# install system base
ADD ./scripts/init.sh /tmp/init.sh
ARG APT_MIRROR=mirrors.ustc.edu.cn
RUN /tmp/init.sh

# configure development environment
ADD ./conf/ /
ADD ./scripts/build /tmp/build
USER ${BUILDER_ID}
ARG CONFIGS
RUN /tmp/build/build.sh
COPY --from=additional_builder /usr/lib/git-core/git-cz /usr/lib/git-core/
COPY --from=additional_builder /go/bin/shfmt /usr/local/bin/shfmt

# custom build something
ADD ./scripts/custom /tmp/custom
RUN /tmp/custom/build.sh

USER root
# configure sshd
ARG SSH_PORT=22222
RUN /tmp/build/sshd.sh

# clear
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/*

USER ${BUILDER_ID}
ADD scripts/entrypoint.sh ${BUILDER_HOME}/.entrypoint.sh
WORKDIR ${BUILDER_HOME}
ENTRYPOINT [ "./.entrypoint.sh" ]

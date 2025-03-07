FROM golang AS additional_builder
ARG GOPROXY=https://proxy.golang.com.cn,direct
RUN go install mvdan.cc/sh/v3/cmd/shfmt@latest

FROM debian:12-slim
ARG DEBIAN_FRONTEND=noninteractive

# configure development environment
COPY --from=additional_builder /go/bin/shfmt /usr/local/bin/shfmt

ARG TZ=Asia/Shanghai
ARG BUILD_DIR=/tmp
ARG STABLE_NETWORK
ARG CROSSDEV_USER_ID=54321
ARG CROSSDEV_USER_NAME=crossdev
ARG CROSSDEV_USER_HOME=/home/crossdev
ARG CROSSDEV_BUILD_CONFIGS

ENV LANG=C.UTF-8

COPY ./ ${BUILD_DIR}/

RUN cd ${BUILD_DIR} && \
	./scripts/init.sh && \
	sudo -u ${CROSSDEV_USER_NAME} --preserve-env=DEBIAN_FRONTEND,STABLE_NETWORK,BUILD_DIR,CROSSDEV_USER_ID,CROSSDEV_USER_NAME,CROSSDEV_USER_HOME,CROSSDEV_BUILD_CONFIGS,LANG ./scripts/build/setup.sh && \
	mv ./scripts/entrypoint.sh ${CROSSDEV_USER_HOME}/.entrypoint.sh && \
	apt-get clean && rm -rf /var/lib/apt/lists/* ${BUILD_DIR}/*

USER ${CROSSDEV_USER_ID}
WORKDIR ${CROSSDEV_USER_HOME}
ENTRYPOINT [ "./.entrypoint.sh" ]

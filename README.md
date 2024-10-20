# 容器开发环境


## 支持系统

- MacOS
- Linux

## 使用方法

- 克隆仓库

```shell
git clone https://github.com/luoyuhao0x58/crossdev.git
cd crossdev
```

- 拉取镜像

```shell
docker-compose pull crossdev
```

- 配置环境变量

```shell
# USER_NAME 容器用户的用户名
# USER_HOME 容器用户的家目录
# WORKSPACE_PATH 挂载到容器的宿主目录，主要是代码目录
# GIT_AUTHOR_NAME git的用户
# GIT_AUTHOR_EMAIL git的email
# GIT_SIGNINGKEY 如果要用git的gpg功能则配置，否则可以留空
cat <<EOT >.env
USER_NAME=someone
USER_HOME=/home/someone
WORKSPACE_PATH=~/Public/workspace
GIT_AUTHOR_NAME=someone
GIT_AUTHOR_EMAIL=someone@example.com
GIT_SIGNINGKEY=
EOT
```

- 启动服务

```shell
docker-compose up -d crossdev
```

- 测试服务可用

```shell
docker-compose exec -it crossdev bash -l
```
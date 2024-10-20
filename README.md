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
# STORAGE_PATH 存储额外文件的根文件夹（宿主机上的目录），如 db 的数据，根据需求调整
# WORKSPACE_PATH 挂载到容器的宿主目录，主要是代码目录
# GIT_AUTHOR_NAME git的用户
# GIT_AUTHOR_EMAIL git的email
# GIT_SIGNINGKEY 如果要用gpg则配置，否则可以留空
cat <<EOT >.env
STORAGE_PATH=~/Public/workspace/devenv/.storage
WORKSPACE_PATH=~/Public/workspace
GIT_AUTHOR_NAME=xxx
GIT_AUTHOR_EMAIL=xxx@example.com
GIT_SIGNINGKEY=
EOT
```

- 创建compose执行文件

```shell
# 修改需要挂载的代码目录
cp compose.override.tmpl.yml compose.override.yml

# 如果需要使用git的gpg，则需要在crossdev服务的volumes加上
- "~/.gnupg/private-keys-v1.d:${BUILDER_HOME:-/home/${BUILDER:-dev}}/.gnupg/private-keys-v1.d:ro"
- "~/.gnupg/pubring.kbx:${BUILDER_HOME:-/home/${BUILDER:-dev}}/.gnupg/pubring.kbx:ro"
```

- 启动服务

```shell
docker-compose up -d crossdev

# 如果要启动其他服务，如 mysql
docker-compose up -d mysql

# 初始化mongodb环境
docker-compose exec -it mongodb /init_rs.sh  # 第一次启动时执行一次即可，产生一个 RS 环境

# 启动过程中遇到宿主 volume 不存在目录的情况，对应 mkdir -p 创建一个空的就行。
# 其他当前支持的服务见 compose.yml 文件
```

- 测试服务可用

```shell
ssh crossdev@127.0.0.1 -p 22222
```
# 跨平台容器开发环境

为了解决服务端开发使用Linux环境，但是实际大家手里只有Mac和PC造成的环境不一致烦恼。

## 支持系统

- Linux
- MacOS
- Windows

## 使用方法

### MacOS

- 克隆仓库

```shell
git clone https://github.com/Haujilo/crossdev.git
cd crossdev
```

- 克隆镜像

```shell
docker pull haujilo/crossdev:aarch64  # 如果机器是x86_64架构，则镜像修改为haujilo/crossdev:x86_64
```

- 创建配置文件

注：前提是本地已经配置好了git环境，如果没有，需要修改文件补充。

```shell
cat <<EOT >.env
SSH_PORT=22222
GIT_AUTHOR_NAME=$(git config user.name)
GIT_AUTHOR_EMAIL=$(git config user.email)
UID=$(id -u)
GID=$(id -g)
GROUP_NAME=$(id -gn)
USER_NAME=$(id -un)
USER_HOME=$(echo ~)
IMAGE=haujilo/crossdev:aarch64  # 如果机器是x86_64架构，则镜像修改为haujilo/crossdev:x86_64
EOT
```

- 创建compose执行文件

```shell
# 修改authorized_keys相关的部分，如果公钥是其他路径，请自行替换。确保把宿主上的公钥目录正确挂载进${USER_HOME}/.ssh/authorized_keys，并且权限为600
cp docker-compose.override.tmpl.yml docker-compose.override.yml
```

- 按需增加服务配置（参考配置服务）

- 构建服务

```shell
docker-compose build sshd
```

- 启动服务

```shell
docker-compose up -d sshd
```

- 登陆环境

```shell
ssh $(id -un)@127.0.0.1 -p 22222
```

### Windows

以下Win的指令需要在powershell中执行。

- 终端配置

```powershell
$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'
git config --global core.autocrlf input
```

注：此处配置是解决编码问题和git克隆后，脚本换行符被替换的问题。

- 克隆仓库

```powershell
git clone https://github.com/Haujilo/crossdev.git
cd crossdev
```

- 克隆镜像

```shell
docker pull haujilo/crossdev:aarch64  # 如果机器是x86_64架构，则镜像修改为haujilo/crossdev:x86_64
```

- 创建配置文件

注：前提是本地已经配置好了git环境，如果没有，需要修改文件补充。

```powershell
echo SSH_PORT=22222 > .env
echo GIT_AUTHOR_NAME=$(git config user.name) >> .env
echo GIT_AUTHOR_EMAIL=$(git config user.email) >> .env
echo USER_NAME=$env:USERNAME >> .env
echo USER_HOME="/$(($HOME -replace '\\','/') -replace ':','')" >> .env
```

- 创建compose执行文件

```powershell
cp docker-compose.override.tmpl.yml docker-compose.override.yml
```

注：修改authorized_keys相关的部分，如果公钥是其他路径，请自行替换。确保把宿主上的公钥目录正确挂载进${USER_HOME}/.ssh/authorized_keys，并且权限为600

- 按需增加服务配置（参考配置服务）

- 构建服务

```powershell
docker-compose build sshd
```

- 启动服务

```powershell
docker-compose up -d sshd
```

- 登陆环境

```powershell
ssh $env:USERNAME@127.0.0.1 -p 22222
```

## 配置服务

修改docker-compose.override.yml可以配置其他服务，提示：

- 如果不想容器里bash命令的执行记录丢失，执行：

    - 宿主创建一个空文件并赋予权限
    ```shell
    touch ./.bash_history && chmod 666 ./.bash_history
    ```
    - 挂载文件```"./.bash_history:${USER_HOME:?err}/.bash_history"```

- 如果要用docker in docker，则需要在crossdev服务增加volumes

    - MacOS: ```"/var/run/docker.sock:/var/run/docker.sock"```
    - Windows: ```"//var/run/docker.sock:/var/run/docker.sock"```

- 如果要使用git的gpg功能，可以挂载（结合宿主实际路径修改）：
  ```yaml
  - sshd
    volumes:
      - "${USER_HOME:?err}/.gnupg/private-keys-v1.d:${USER_HOME:?err}/.gnupg/private-keys-v1.d:ro"
      - "${USER_HOME:?err}/.gnupg/pubring.kbx:${USER_HOME:?err}/.gnupg/pubring.kbx:ro"
  ```

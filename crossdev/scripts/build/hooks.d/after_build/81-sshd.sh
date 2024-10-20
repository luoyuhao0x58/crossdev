set -uexo pipefail

# configure sshd

# sudo sed -i "s/^#Port.*/Port ${SSH_PORT}/g" /etc/ssh/sshd_config
sudo sed -i "s/^#HostKey \/etc\/ssh\/\(.*\)/HostKey \/etc\/ssh\/hostkey\/\1/g" /etc/ssh/sshd_config
sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
sudo mkdir -p /run/sshd /etc/ssh/hostkey/ && sudo mv /etc/ssh/ssh_host_* /etc/ssh/hostkey/

mkdir -p ~/.ssh && touch ~/.ssh/authorized_keys
chmod 700 ~/.ssh && chmod 600 ~/.ssh/*

# configure ssh-agent
cat <<\EOF >>~/.bashrc

# SSH Agent Config Begin
ssh_agent_env=~/.ssh/agent.env
agent_load_env () { test -f "$ssh_agent_env" && . "$ssh_agent_env" >| /dev/null ; }
agent_start () {
  (umask 077; ssh-agent >| "$ssh_agent_env")
  . "$ssh_agent_env" >| /dev/null ; }
agent_load_env
# agent_run_state: 0=agent running w/ key; 1=agent w/o key; 2= agent not running
agent_run_state=$(ssh-add -l >| /dev/null 2>&1; echo $?)
if [ ! "$SSH_AUTH_SOCK" ] || [ $agent_run_state = 2 ]; then
  agent_start
  if [ ! -z "$SSH_TTY" ] || [ ! -z "$VSCODE_IPC_HOOK_CLI" ]; then
    ssh-add
  fi
elif [ "$SSH_AUTH_SOCK" ] && [ $agent_run_state = 1 ]; then
  if [ ! -z "$SSH_TTY" ] || [ ! -z "$VSCODE_IPC_HOOK_CLI" ]; then
    ssh-add
  fi
fi
unset ssh_agent_env
# SSH Agent Config End
EOF

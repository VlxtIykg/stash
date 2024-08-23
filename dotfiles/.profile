# windows only
echo "Loading omp themes"
env=~/.ssh/agent.env
github=~/.ssh/github

agent_load_env () { test -f "$env" && . "$env" >| /dev/null ; }

agent_start () {
    (umask 077; ssh-agent >| "$env")
    . "$env" >| /dev/null ; }

agent_load_env

# agent_run_state: 0=agent running w/ key; 1=agent w/o key; 2=agent not running
agent_run_state=$(ssh-add -l >| /dev/null 2>&1; echo $?)

if [ ! "$SSH_AUTH_SOCK" ] || [ $agent_run_state = 2 ]; then
    echo "Added ssh key via starting agent"
    agent_start
    ssh-add
    ssh-add "$github"/signing/id_rsa
    ssh-add "$github"/authentication/id_rsa
elif [ "$SSH_AUTH_SOCK" ] && [ $agent_run_state = 1 ]; then
    echo "Added ssh keys to ssh agent"
    ssh-add
    ssh-add "$github"/signing/id_rsa
    ssh-add "$github"/authentication/id_rsa
fi

unset env

echo "Profile file loaded"

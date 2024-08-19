#!/usr/bin/env bash

_awsenv_completion() {
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts="--init --list --current --help $(ls ~/.aws/aws-envs 2>/dev/null)"

    if [[ ${cur} == -* ]] ; then
        COMPREPLY=( $(compgen -W "--init --list --current --help" -- ${cur}) )
        return 0
    fi

    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
    return 0
}

_awsprofile_completion() {
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    
    # Get the current AWS environment
    local current_env=$(cat ~/.awsdefaultenv 2>/dev/null)
    
    # List profiles in the current environment
    opts=$(grep '^\[' ~/.aws/aws-envs/${current_env}/config 2>/dev/null | tr -d '[]' | sed 's/^profile //')

    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
    return 0
}

complete -F _awsenv_completion awsenv
complete -F _awsprofile_completion awsprofile
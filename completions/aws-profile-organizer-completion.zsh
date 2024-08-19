#compdef awsenv awsprofile

_awsenv() {
    local -a opts
    opts=(
        '--init:Initialize a new environment'
        '--list:List available environments'
        '--current:Show current environment'
        '--help:Show help information'
    )

    _arguments -C \
        '1: :->cmds' \
        '*::arg:->args'

    case "$state" in
        cmds)
            _describe -t commands 'awsenv commands' opts
            _files -W ~/.aws/aws-envs -/
            ;;
    esac
}

_awsprofile() {
    local current_env=$(cat ~/.awsdefaultenv 2>/dev/null)
    local -a opts

    if [[ -f ~/.aws/aws-envs/${current_env}/config ]]; then
        opts=($(grep '^\[' ~/.aws/aws-envs/${current_env}/config | tr -d '[]' | sed 's/^profile //'))
    fi

    _describe -t profiles 'AWS profiles' opts
}

compdef _awsenv awsenv
compdef _awsprofile awsprofile
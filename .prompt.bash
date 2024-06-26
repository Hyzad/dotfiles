# shellcheck shell=bash
##########
# PROMPT #
##########

BLACK="$(tput setaf 0)"
RED="$(tput setaf 1)"
GREEN="$(tput setaf 2)"
YELLOW="$(tput setaf 3)"
MAGENTA="$(tput setaf 4)"
PINK="$(tput setaf 5)"
CYAN="$(tput setaf 6)"
WHITE="$(tput setaf 15)"
GREY="$(tput setaf 8)"

COMMAND_STATUS_COLOR="$(tput bold)$RED"
HOSTNAME_COLOR="$MAGENTA"
GIT_BRANCH_COLOR="$GREEN"
LAMBDA_COLOR="$YELLOW"
DELTA_COLOR="$YELLOW"
NO_COLOR="\e[0m"

STACK_DIR=""
STACK_CACHE=""

function get_stack {
  if [[ ! -f "Pulumi.yaml" && -z "$STACK_DIR" ]]; then
     return
  fi

  if [[ "$STACK_DIR" == $(pwd) ]]; then
    if [[ -z "$STACK_CACHE" ]]; then
      STACK_CACHE=$(pulumi stack --show-name)
    fi
  else
    STACK_DIR=$(pwd)
    STACK_CACHE=$(pulumi stack --show-name)
  fi
}

SEPARATOR=" "

function add_sep_if_required {
  if [[ "$1" == "$START" ]]; then
    echo "$1"
  else
    echo "${1}${SEPARATOR}"
  fi
}

function __prompt_command {
    RET="$?"
    PS1=""

    if [[ "$VIRTUAL_ENV_PROMPT" != "" ]]; then
      VENV_NAME=${VIRTUAL_ENV_PROMPT//[() ]/}
      PS1+="\[$WHITE\][venv: $VENV_NAME]"
    fi

    if [[ $(tput cols) -gt 149 ]]; then
      active_context=$(kubectl config current-context 2>/dev/null)
      if [[ "$active_context" != "" ]]; then
        PS1=$(add_sep_if_required "$PS1")
        PS1+="\[$WHITE\][kube: ${active_context}]"
      fi


      if [[ "$AWS_PROFILE" != "" ]]; then
          PS1=$(add_sep_if_required "$PS1")
          PS1+="\[$WHITE\][aws: ${AWS_PROFILE}]"
      fi


      if [[ -f "Pulumi.yaml" ]]; then
        get_stack
        PS1=$(add_sep_if_required "$PS1")
        PS1+="\[$WHITE\][stack: ${STACK_CACHE}]"
      fi
    fi

    if [[ -n "$PS1" ]]; then
      PS1+="\n"
    fi

    if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
      PS1+="\[$HOSTNAME_COLOR\]\u@\h\[$NO_COLOR\] "
    fi

    if [[ "$RET" != "0" ]]; then
      PS1+="\[$COMMAND_STATUS_COLOR\]!!\[$NO_COLOR\] "
    fi

    PS1+="\[$WHITE\]\w "

    ref="$(git symbolic-ref HEAD 2> /dev/null)"
    if [[ "$ref" != "" ]]; then
        PS1+="\[$GIT_BRANCH_COLOR\]${ref#refs/heads/} "
    fi

    if [[ "$(git diff --shortstat 2> /dev/null | tail -n1)" != "" ]]; then
        PS1+="\[$DELTA_COLOR\]Δ "
    else
        PS1+="\[$LAMBDA_COLOR\]λ "
    fi

    PS1+="\[$NO_COLOR\]"
    _bash_history_sync
}

PROMPT_COMMAND=__prompt_command

#############
# FUNCTIONS #
#############

function pyenv_activate() {
  eval "$(pyenv init -)"
}

function dotfiles() {
  cd $DOTFILES
}

function page() {
  $@ | less
}

function redact() {
  $@ 1>/dev/null 2>/dev/null
}

function st() {
  if [[ -n $1 ]]; then
    sess=$(tmux list-session -F "#S" | grep -i $1)
    tmux attach-session -t $1
  else
    if [[ -n $TMUX ]]; then
        tmux choose-tree -s
    else
        sess=$(tmux list-session -F "#S" | head -n1)
        tmux attach-session -t $sess \; choose-tree -s
    fi
  fi

}

function krestart() {
    DEPLOYMENT=$(kubectl get deployments $@ | fzf | awk '{ print $1 }')
    kubectl rollout restart $@ deployment/$DEPLOYMENT
}

function sp() {
  PROJECT=""
  if [[ $1 == "" ]]; then
    PROJECT=$(projector list | fzf)
  elif [[ $1 == "home" ]]; then
    PROJECT=$HOME
  else
    PROJECT=$(projector find "(?i)$1")
  fi

  if [[ $? != 0 ]]; then
    EXITCODE=$?
    echo $PROJECT
    return $EXITCODE
  fi

  cd $PROJECT
  if [ -f .env.local ]; then
    echo "Found .env.local"
    source .env.local
  fi
}

function v() {
  if [[ -n $(env | grep 'VIRTUAL_ENV=') ]]; then
    deactivate
  fi

  TOP_LEVEL=$(git rev-parse --show-toplevel 2>/dev/null)
  if [[ $? != 0 ]]; then
    TOP_LEVEL=$(pwd)
  fi

  NAME=$(basename $TOP_LEVEL)
  ENVDIR=""
  for envdir in "$TOP_LEVEL/env" "$TOP_LEVEL/venv"; do
    if [[ -d $envdir ]]; then
      ENVDIR="$envdir"
      break
    else
      ENVDIR="$envdir"
    fi
  done

  if [[ ! -d $ENVDIR ]]; then
    python3 -m venv --prompt $NAME $ENVDIR
    source $ENVDIR/bin/activate
    pip install wheel
    return 0
  fi

  source $ENVDIR/bin/activate
}

function nv() {
  if test $# -gt 0; then
    env $VIM_PROG "$@"
  elif test -f Session.vim; then
    env $VIM_PROG -S
  else
    env $VIM_PROG -c Obsession .
  fi
}

function t() {
  SESS_NAME=${PWD##*/}
  if [[ -n "$1" ]]; then
    SESS_NAME="$1"
  fi

  tmux has-session -t $SESS_NAME
  if [ $? -ne 0 ]; then
    tmux new-session -s $SESS_NAME -d
  fi

  if [[ -n $TMUX ]]; then
    tmux switch-client -t $SESS_NAME
  else
    tmux attach-session -t $SESS_NAME
  fi
}

function awsprof() {
    if [ $1 == "-h" ] || [ $1 == "--help" ]; then
        echo "AWS Profile Switcher:"
        echo "This tool is used for quickly switching between AWS profiles."
        echo "Usage:"
        echo "    awsprof [profilename]"
        exit 0
    fi

    export AWS_DEFAULT_PROFILE="$1"
    export AWS_EB_PROFILE="$1"
    export AWS_PROFILE="$1"
}


PULUMI_BIN=$(which pulumi)
function pulumi() {
  if [[ $@ =~ "stack select" ]]; then
    STACK_CACHE=""
  fi

  "$PULUMI_BIN" $@
}


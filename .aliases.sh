alias cd..="cd .."

alias g="git"

alias venv="python3 -m venv"

if [[ -n "$VIM_PROG" ]]; then	
    alias vim="$VIM_PROG"
fi

alias e="$EDITOR"
if [[ "$VIM_PROG" == "nvim" ]]; then
    alias vimdiff="nvim -d"
fi

alias k='kubectl'
alias logs='kubectl logs'

alias tf='terraform'

alias dk="docker"

alias circleci="NO_COLOR=1 circleci"

alias pup="pulumi up --suppress-outputs"
alias aws-login-pip="aws --profile internal-services codeartifact login --tool pip --repository tillo-python --domain tillo --domain-owner 307488140247 --region eu-west-1"
alias apt="sudo apt"
alias dnf="sudo dnf"
alias pacman="sudo pacman"
alias aws-login-twine="aws --profile internal-services codeartifact login --tool twine --repository tillo-python --domain tillo --domain-owner 307488140247 --region eu-west-1"

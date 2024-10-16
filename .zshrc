# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="robbyrussell"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    aliases
    aws
    docker
    helm
    gitfast
    golang
    helm
    kubectl
    mix-fast
    pip
    podman
    virtualenv
    rust
)

source "$ZSH/oh-my-zsh.sh"

# User configuration

source "$HOME/.profile"
source_if_exists "$HOME/.prompt.zsh"
source_if_exists "$HOME/.functions.sh"
source_if_exists "$HOME/.env.sh"
source_if_exists "$HOME/.aliases.sh"
source_if_exists "$HOME/.local.sh"
source_if_exists "$HOME/.extras.sh"

# append completions to fpath
fpath=(${ASDF_DIR}/completions $fpath)
# initialise completions with ZSH's compinit
autoload -Uz compinit && compinit

if [[ -x $(which atuin 2>/dev/null) ]]; then
    echo "Setting up atuin..."
    eval "$(atuin init zsh --disable-up-arrow)"
fi

source_if_exists "$HOME/.config/fzf/shell/key-bindings.zsh"
source_if_exists "$HOME/.config/fzf/shell/completion.zsh"

bindkey "^[^[[C" forward-word
bindkey "^[^[[D" backward-word

unsetopt autocd
source_if_exists "$HOME/.devops-completion.zsh"
source_if_exists "$HOME/.pulumi-completion.zsh"

alias docker="AWS_PROFILE=internal-services /usr/local/bin/docker"
alias docker-compose="AWS_PROFILE=internal-services /usr/local/bin/docker-compose"

source <(fzf --zsh)


function debug() {
    if [[ -n $CL_DEBUG ]]; then
        echo $@ 1>&2
    fi
}

functin find_executable() {
    X=$(which $1 2>/dev/null)
    debug "Searching for $1 found $X"
    echo $X
}

function source_if_exists() {
    if [[ -f $1 ]]; then
        debug "Sourcing $1 because it exists."
        source $1
    else
        debug "Not source $1 because it could not be found."
    fi
}

# Idempotently add directories to the path if they exist.
function add_to_path() {
    debug "Adding $1 to PATH."
    if [[ "$PATH" == *"$1"* && "$2" == "" ]]; then
        debug "$1 is already in PATH doing nothing."
        return 0;
    elif [[ "$PATH" == *"$1"* ]]; then
        debug "$1 is already in PATH but force flag was provided to adding again."
    fi

    export PATH="$1:$PATH"
}

# Just show me the output please....
export AWS_PAGER=""
# Use Python3 for Virtualenvwrapper
export VIRTUALENVWRAPPER_PYTHON="$(which python3)"
# Needed for the go compiler and tooling
export GOPATH="$HOME/Code/go"
# Make helm work with our internal chart museum
export GODEBUG=x509ignoreCN=0
# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
export HISTCONTROL=ignoreboth
# number of commands to save in history file
export HISTSIZE=1000000
# number of lines to save in history file
export HISTFILESIZE=$HISTSIZE

# Mac specific fixes
if [[ "$(uname)" == "Darwin" ]]; then
    export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
    export CLICOLOR=1
    export GRPC_PYTHON_BUILD_SYSTEM_OPENSSL=1
    export GRPC_PYTHON_BUILD_SYSTEM_ZLIB=1
    export LDFLAGS="-L/opt/homebrew/opt/openssl@3/lib"
    export CPPFLAGS="-I/opt/homebrew/opt/openssl@3/include"

    if [[ -d "$HOME/Library/Python" ]]; then
        for dir in $(find "$HOME/Library/Python" -maxdepth 1 -type d); do
            export PATH="$PATH:$dir/bin"
        done
    fi

    if [[ -d "/usr/local/opt/postgresql@16" ]]; then
        export LDFLAGS="$LDFLAGS -L/usr/local/opt/postgresql@16/lib"
        export CPPFLAGS="$CPPFLAGS -I/usr/local/opt/postgresql@16/include"
        export PKG_CONFIG_PATH="/usr/local/opt/postgresql@16/lib/pkgconfig"
        add_to_path "/usr/local/opt/postgresql@16/bin"
    fi

    if [[ -d "/opt/homebrew/opt/postgresql@16" ]]; then
        export LDFLAGS="$LDFLAGS -L/opt/homebrew/opt/postgresql@16/lib"
        export CPPFLAGS="$CPPFLAGS -I/opt/homebrew/opt/postgresql@16/include"
        export PKG_CONFIG_PATH="/opt/homebrew/opt/postgresql@16/lib/pkgconfig"
        add_to_path "/opt/homebrew/opt/postgresql@16/bin"
    fi

fi

export COLORTERM=truecolor

# Storage for miscellaneous or system specific environment variables
source_if_exists "$HOME/.env.bash"

# Setup rustup, cargo path
add_to_path /opt/homebrew/bin
add_to_path "$HOME/.local/bin"
add_to_path "$HOME/.elixir-ls/dist"
add_to_path "$GOPATH/bin"
add_to_path "$HOME/.cargo/bin"
add_to_path "/Applications/PyCharm CE.app/Contents/MacOS"
add_to_path "/Applications/PyCharm.app/Contents/MacOS"
add_to_path "$HOME/.config/emacs/bin"
add_to_path "$HOME/.pulumi/bin"

source_if_exists "$HOME/.cargo/env"

source_if_exists "$HOME/.env.local"

# This has to be after the $PATH is set up.
# FZF default find command
if [[ -n $(find_executable fd) ]]; then
    export FZF_DEFAULT_COMMAND="fd --type f --hidden --exclude '.git/'"
else
    export FZF_DEFAULT_COMMAND="find . -path './.git' -prune -o -type f -print"
fi

if [[ -n $(find_executable nvim) ]]; then
  export VIM_PROG="nvim"
else
  export VIM_PROG="vim"
fi

if [[ -n $(find_executable dfm) ]]; then
    export DOTFILES=$(dfm where)
fi

if [[ "$EDITOR" != "code --wait" ]]; then
    export EDITOR="code --wait"
fi

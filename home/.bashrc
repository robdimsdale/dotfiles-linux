# Environment
export LANG=en_US.UTF-8

export EDITOR='nvim'
export GIT_EDITOR='nvim'

export GIT_DUET_GLOBAL=1

export PATH=${HOME}/bin:${PATH}

# Golang
export GOPATH="${HOME}/go"
export PATH=${GOPATH}/bin:${PATH}

# Rust
export PATH=${HOME}/.cargo/bin:${PATH}

eval "$(starship init bash)"

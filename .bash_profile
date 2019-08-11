# Setting PATH for Python 3.6
# The original version is saved in .bash_profile.pysave
export PATH="/Library/Frameworks/Python.framework/Versions/3.6/bin:${PATH}"

# Add rust binary files to the path variable
export PATH="$HOME/.cargo/bin:$PATH"

# Set the GOPATH environment variable and the path variable to include the GOPATH's bin
export GOPATH="$HOME/go"
export PATH=$PATH:$GOPATH/bin

# Add this to your ~/.bash_profile file:
export NODE_PATH="/usr/local/lib/node_modules"

### Alias python2 to python3
alias python=python3

### Functions and Aliases ###

# A quick and dirty find and replace script on a given file. 
function sid() {
    cat "$1" | sed "s/"$2"/"$3"/g" > temp
    mv temp "$1"
}

## 0x aliases ##

function yb() {
    yarn build
}

function yt() {
    yarn test 
}

function yl() {
    yarn lint 
}

function ybt() {
    yb && yt
}

function yall() {
    yb && yt && yl
}

function ybc() {
  OLD=$(pwd)
  cd ~/0x-monorepo-1
  yarn build:contracts
  cd $OLD
}

function ytc() {
  OLD=$(pwd)
  cd ~/0x-monorepo-1
  yarn test:contracts
  cd $OLD
}

function ylc() {
  OLD=$(pwd)
  cd ~/0x-monorepo-1
  yarn lint:contracts
  cd $OLD
}

function ycall() {
    ybc && ytc && ylc
}

## Rust Functions ##

function cb() {
    cargo build
}

function cc() {
    cargo check
}

function ct() {
    cargo test
}

function cbt() {
    cargo build && cargo test
}

## Setup for the "Node Version Manager" ##
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

## Enable Bash Powerline ##
source ~/.bash-powerline.sh

## Enable git completion for bash ##
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

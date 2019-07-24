source $HOME/cs61b-software/adm/login
# Setting PATH for Python 3.6
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.6/bin:${PATH}"
export PATH
if [ -e /Users/alextowle/.nix-profile/etc/profile.d/nix.sh ]; then . /Users/alextowle/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

# Add rust binary files to the path variable
export PATH="$HOME/.cargo/bin:$PATH"

# Set the GOPATH environment variable and the path variable to include the GOPATH's bin
export GOPATH="$HOME/go"
export PATH=$PATH:$GOPATH/bin

# Add this to your ~/.bash_profile file:
export NODE_PATH="/usr/local/lib/node_modules"

# Add jenv to path
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"

### Functions and Aliases ###

function greep() {
  grep -R $1 .
}

## 0x aliases ##

# Package level Aliases

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

# Contracts level aliases

function ybc() {
  OLD=$(pwd)
  cd ~/0x-monorepo
  yarn build:contracts && cd $OLD || cd $OLD
}

function ytc() {
  OLD=$(pwd)
  cd ~/0x-monorepo
  yarn test:contracts && cd $OLD || cd $OLD
}

function ylc() {
  OLD=$(pwd)
  cd ~/0x-monorepo
  yarn lint:contracts && cd $OLD || cd $OLD
}

function ycall() {
    ybc && ytc && ylc
}

## Rust Aliases ##

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

# Run bashrc
source ~/.bashrc

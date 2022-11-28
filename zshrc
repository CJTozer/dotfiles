var=0

# Define __git_files to prevent really slow autocompletion on large repos
__git_files () {
  _files
}

source ~/antigen/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle git-extras
antigen bundle command-not-found
# antigen bundle tmuxinator
# antigen bundle taskwarrior
antigen bundle colored-man-pages
antigen bundle sudo

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting

# z plugin for navigation
antigen bundle rupa/z

# Better searching for z
antigen bundle andrewferrier/fzf-z
export FZFZ_EXCLUDE_PATTERN="/.git"
export FZF_DEFAULT_OPTS="--height 50% --reverse --bind page-down:preview-down,page-up:preview-up"

# k command for colourful ls
antigen bundle supercrabtree/k

# 'sensible' defaults
antigen bundle willghatch/zsh-saneopt

# Load the theme.
export BULLETTRAIN_PROMPT_SEPARATE_LINE=false
export BULLETTRAIN_PROMPT_ADD_NEWLINE=false
export BULLETTRAIN_EXEC_TIME_SHOW=true
export BULLETTRAIN_TIME_BG=magenta
export BULLETTRAIN_TIME_FG=black
export BULLETTRAIN_GIT_EXTENDED=false # Simple 'is workspace dirty' only to save time on large codebases
# Requires nerd-fonts (https://github.com/ryanoasis/nerd-fonts)
export BULLETTRAIN_VIRTUALENV_PREFIX=
export BULLETTRAIN_VIRTUALENV_BG=cyan
export BULLETTRAIN_VIRTUALENV_FG=white
BULLETTRAIN_PROMPT_ORDER=(time status custom context dir perl ruby virtualenv git hg cmd_exec_time)
antigen theme https://github.com/caiogondim/bullet-train-oh-my-zsh-theme bullet-train

# Tell antigen that you're done.
antigen apply
export ZSH_THEME_GIT_PROMPT_PREFIX=" "

# Needed for ctrl-x ctrl-e to work for some reason...
export EDITOR=vim

# Set less -RXF for nicer interaction with git diff, paging and colour
LESS="-RXF"

# Alias
## For tmux to work in 256 colour mode
alias tmux='TERM=xterm-256color tmux'
## Alias for next task
# alias tn='tasknote'
# alias ts='task summary'

# Function for ssh as centos user for OpenStack
c() {
  # Is the input an array?
  arr=($(echo $1 | tr -d '[]' | tr ',' ' '))
  if [ "${#arr[@]}" -eq "1" ]
  then
    target=${arr[1]}
  else
    PS3="Please select an IP: "
    select opt in $arr
    do
      target=${opt}
      break
    done
  fi

  # Which user do we want?
  user=${2:-centos}

  ssh -o StrictHostKeyChecking=no $user@$target
}

# Function for calculator
calc () {
  bc -l <<< "$@"
}

# Path
# export PATH=$PATH:~/path/:/opt/pycharm-community-2017.3.3/bin

# virtualenvwrapper
export WORKON_HOME=~/venvs/
if [ -f /usr/bin/virtualenvwrapper.sh ]
then
  source /usr/bin/virtualenvwrapper.sh
elif [ -f /usr/local/bin/virtualenvwrapper.sh ]
then
  source /usr/local/bin/virtualenvwrapper.sh
else
  echo "virtualenvwrapper.sh not found, install with \`pip install virtualenvwrapper\`"
fi

# Don't share history
# setopt no_share_history

# Useful CD options
setopt autocd
setopt autopushd
setopt pushdsilent
setopt pushdignoredups

# Terminal type
export TERM="xterm-256color"

# Colour scheme for tasknote
# Do `mdv -t all | less` to explore other options.
export AXC_THEME=884.0134

# Context-specifics
if [ -f ~/.zshrc_user ]
then
  source ~/.zshrc_user
fi

# If no fzf, try to install it
if ! command -v fzf > /dev/null
then
  echo "\`fzf\` is not installed.  Attempting to install..."
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install
fi
source ~/.fzf.zsh

# If no tpm, try to install it
if [ ! -d ~/.tmux/plugins/tpm ]
then
  echo "\`tpm\` is not installed.  Attempting to install..."
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

function rust-dev {
  docker run --rm -it -v ${PWD}:/root/src -v /data/cjt/.ssh:/mnt -v /var/agentx:/var/agentx artifactory.metaswitch.com:6555/images.core/rust-dev:1.2 bash -c "eval \$(ssh-agent -s) && s
  sh-add /mnt/id_rsa && yum -y install net-snmp-devel pciutils-devel && bash $@"
}

# Source Git fzf goodness
source ~/.utils/git-fzf.sh

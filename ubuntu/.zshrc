# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="risto"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how many often would you like to wait before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git tmux command-not-found dircycle pip npm tmuxinator)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
#export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:$HOME/.wp-cli/bin
#export PATH=$PATH:$HOME/.wp-cli/bin
path+=($HOME/.wp-cli/bin)

export EDITOR=vim
alias chownwww='chown -R www-data:www-data'
alias a2reload='service apache2 reload'

#powerline prompt
#. /usr/local/lib/python2.7/dist-packages/powerline/bindings/zsh/powerline.zsh

#wp-cli bash completions
autoload bashcompinit
bashcompinit
source $HOME/.wp-cli/vendor/wp-cli/wp-cli/utils/wp-completion.bash

#export POWERLINE_COMMAND=powerline-client

if [ -n "$USE_POWERLINE_PROMPT" ]; then
    PS1=''
    RPS1=''
    . /usr/local/lib/python2.7/dist-packages/powerline/bindings/zsh/powerline.zsh
fi


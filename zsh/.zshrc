# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Load zsh options, keybindings, and completion
[[ -f /usr/share/omarchy-zsh/shell/zoptions ]] && source /usr/share/omarchy-zsh/shell/zoptions

# Load shared shell configuration (aliases, functions, environment, tool init)
[[ -f /usr/share/omarchy-zsh/shell/all ]] && source /usr/share/omarchy-zsh/shell/all

# Machine-specific: this machine's Obsidian vault (used by tns/notes/notes-sync in .zaliases)
VAULT="$HOME/obsidian/personal"

# Add your own customizations
[[ -f $HOME/.zaliases ]] && source $HOME/.zaliases

# Jujutsu completion (must run after compinit above so compdef is defined)
source <(COMPLETE=zsh jj)

export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" 
# bun completions
[ -s "/Users/tarikdem/.bun/_bun" ] && source "/Users/tarikdem/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
path+=($HOME/go/bin)

NEWLINE=$'\n'

# The following lines were added by compinstall

zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'l:|=* r:|=*'
zstyle :compinstall filename '/Users/tarikdem/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh_history
HISTSIZE=99999999999999
SAVEHIST=$HISTSIZE
setopt autocd
bindkey -v
# End of lines configured by zsh-newuser-install

# history substring search
export HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=true
source $HOMEBREW_PREFIX/share/zsh-history-substring-search/zsh-history-substring-search.zsh
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

setopt globdots

source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

bindkey '^[^H' backward-kill-word

NEWLINE=$'\n'
autoload -Uz vcs_info
precmd_functions+=( vcs_info )
setopt promptsubst

# Customize git info color here
zstyle ':vcs_info:git:*' formats '%F{blue}[%u%b%c]%f '
zstyle ':vcs_info:git:*' actionformats '%F{blue}[%u%b%c%F{3}|%F{1}%a%f%F{blue}]%f '

# command timing
typeset -gA TIMER

# command timing (portable version using `date`)
preexec() {
  TIMER_START=$(date +%s.%N)
}

precmd() {
  if [[ -n $TIMER_START ]]; then
    local TIMER_END=$(date +%s.%N)
    local DURATION=$(printf "%.2f" "$(echo "$TIMER_END - $TIMER_START" | bc)")
    if (( $(echo "$DURATION >= 1" | bc -l) )); then
      TIMER_DURATION=$'\n'"%F{red}⏱ ${DURATION}s%f"
    else
      TIMER_DURATION=""
    fi
    unset TIMER_START
  fi
}

PS1='%F{cyan}%n%f %F{yellow}%~%f ${vcs_info_msg_0_}${TIMER_DURATION}${NEWLINE}%F{magenta}λ%f '

# aliases
alias ls='ls -A --color'
alias ll='ls -lA --color'

# ───────────────────────────────────────────────────────────────
# Widget: copy entire current edit‐line ($BUFFER) to macOS clipboard
copy_buffer_to_clipboard() {
  emulate -L zsh
  if [[ -z $BUFFER ]]; then
    zle -M "Nothing to copy"
    return 1
  fi
  print -rn -- "$BUFFER" | pbcopy
  zle -M "Copied: $BUFFER"
  zle reset-prompt
}

# Tell zsh that function is a ZLE widget
zle -N copy_buffer_to_clipboard

# Bind it to a key
bindkey '^[c' copy_buffer_to_clipboard
# ───────────────────────────────────────────────────────────────



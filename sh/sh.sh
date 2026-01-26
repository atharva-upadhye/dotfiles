# fzf-history function - works for both bash and zsh
fzf-history() {
  if [[ $- != *i* ]]; then
    echo "Error: Non-interactive shell detected. Aborting." >&2
    exit 1
  fi

  local saved_history_file="$HOME/_/sh/saved-sh-history.sh"
  if [[ ! -f "$saved_history_file" ]]; then
    mkdir -p "$(dirname "$saved_history_file")"  # ensure parent dir exists
    touch "$saved_history_file"
  fi

  local cmd
  # cmd=$(history | sed -re 's/ *[0-9]* *//' | fzf --tac --no-sort)
  cmd=$(
    (cat "$saved_history_file"; history | sed -re 's/ *[0-9]+ *//') |
    fzf --tac --no-sort
  )
  if [[ -n "$cmd" ]]; then
    if [[ -n "$ZSH_VERSION" ]]; then
      # Insert into Zsh command line buffer
      LBUFFER="$cmd"
    elif [[ -n "$BASH_VERSION" ]]; then
      # Bash: use READLINE variables (works only if bound with bind -x)
      READLINE_LINE="$cmd"
      READLINE_POINT=${#cmd}
    else
      # Unsupported shell
      echo "fzf-history: Unsupported shell. Only Bash and Zsh are supported." >&2
      return 1
    fi
  fi
}

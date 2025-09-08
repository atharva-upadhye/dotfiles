# Requires: git, fzf, batcat, rg (ripgrep), xclip

mkdir -p "$HOME/_/bin"
export PATH="$PATH:$HOME/_/bin"


# ## Functions

f() {
  if [[ $- != *i* ]]; then
    echo "Error: Non-interactive shell detected. Aborting." >&2
    exit 1
  fi
  local file
  file=$(fzf --preview="cat {}")
  [[ -n "$file" ]] && nautilus "$file"
}

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

# Interactive file content search using rg + fzf
ft() {  # find text
  RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case"
  selected=$(
    FZF_DEFAULT_COMMAND="$RG_PREFIX \"$1\"" \
    fzf --ansi \
      --disabled \
      --query "$1" \
      --bind "change:reload:$RG_PREFIX {q} || true" \
      --delimiter : \
      --preview 'batcat --style=numbers --color=always --highlight-line {2} {1}' \
      --preview-window 'up,60%,border-bottom,+{2}+3/3,~3'
  )
  if [[ -n "$selected" ]]; then
    # Parse filename, line, and column from the result
    local file line col
    file=$(cut -d: -f1 <<< "$selected")
    line=$(cut -d: -f2 <<< "$selected")
    col=$(cut -d: -f3 <<< "$selected")

    # Open in VS Code at location
    code -g "$file:$line:$col"
  fi
}

gitwt() {
  local worktree_path="$HOME/_/wt"

  if [[ -z "$1" || "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Creates a git worktree for the current repo with the branch name specified"
    echo "Usage: gitwt <branch_name> [repo_path]"
    echo "  <branch_name>: Name of branch to create worktree for"
    echo "  [repo_path]:   Optional. Path of git repository in worktree path ($worktree_path)"
    return 0
  fi

  local repo_path="${2:-p}"
  local repo
  repo=$(basename "$PWD")
  mkdir -p "$worktree_path/$repo_path"
  local separator="--wt-"

  # Find next available numeric directory
  local i=1
  while [[ -e "$worktree_path/$repo_path/$repo$separator$i" ]]; do
    ((i++))
  done

  git worktree add "$worktree_path/$repo_path/$repo$separator$i" -b "$1" 1>&2 \
    && echo "$worktree_path/$repo_path/$repo$separator$i"
}

gcgh() {
  local repo_url="$1"
  if [[ -z "$repo_url" ]]; then
    echo "Usage: gcgh <git@github.com:org/repo.git>"
    return 1
  fi

  # Extract path: org/repo
  local path="${repo_url##*:}"       # kir-dev/next-nest-template.git
  path="${path%.git}"                # kir-dev/next-nest-template

  # Target directory
  local target_dir="$HOME/_/gh/$path"

  # Ensure parent directory exists
  mkdir -p "$(dirname "$target_dir")"

  # Clone repository
  git clone "$repo_url" "$target_dir"
}


# ## Shell variables
# HISTSIZE=1000

# ## Environment variables
# export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64


# ## Aliases
alias c='xclip -selection clipboard'
alias dc='daily-checkout'
alias gcm='git commit -m'
alias gpsu='git push -u origin "$(git symbolic-ref --short HEAD)"'
alias lc="grep -E '^alias|.*\(\)' ~/.bashrc ~/_/sh/bash.sh"  # list commands


# ## Key bindings
bind -x '"\C-r":fzf-history'


# ## Other
if [ "$(pwd)" = "$HOME" ]; then
  cd "$HOME/_"
fi

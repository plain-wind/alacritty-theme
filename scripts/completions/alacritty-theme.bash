_alacritty_theme_complete() {
  local cur prev cmd themes

  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"
  cmd="${COMP_WORDS[1]}"

  if [[ $COMP_CWORD -eq 1 ]]; then
    COMPREPLY=( $(compgen -W "set list ls help --help -h --version" -- "$cur") )
    return 0
  fi

  case "$cmd" in
    set)
      if [[ $COMP_CWORD -eq 2 ]]; then
        themes="$(alacritty-theme list 2>/dev/null)"
        COMPREPLY=( $(compgen -W "$themes" -- "$cur") )
      fi
      ;;
    list|ls|help)
      ;;
    *)
      ;;
  esac

  return 0
}

complete -F _alacritty_theme_complete alacritty-theme
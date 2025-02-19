function ls --wraps='eza' --description 'alias ls eza'
  eza --color=always --git --no-filesize --icons=always --no-time --no-user --no-permissions $argv
end

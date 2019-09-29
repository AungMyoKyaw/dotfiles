# UTF 8/256 COLOR SUPPORT TMUX
alias tmux='tmux -u -2'

# DNVIM
alias dnvim='docker run -it --rm \
  -v $(pwd):/home/spacevim/src \
  -v ~/Dropbox/MyWiki:/home/spacevim/Dropbox/MyWiki \
  -v ~/dockerized-nvim/.local/share/nvim/:/home/spacevim/.local/share/nvim:cached \
  -v ~/dockerized-nvim/.cache:/home/spacevim/.cache:cached \
  dnvim'

# COPYTO SYSTEM CLIPBOARD
alias dcp='cat ./dcp.txt | pbcopy'

#!/bin/sh

lua-format --indent-width=2 --column-limit=80 --no-use-tab --double-quote-to-single-quote nvim-lua/**/*.lua -i
lua-format --indent-width=2 --column-limit=80 --no-use-tab --double-quote-to-single-quote hammerspoon/**/*.lua -i

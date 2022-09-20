#!/bin/sh

lua-format --indent-width=2 --no-use-tab nvim-lua/**/*.lua -i
lua-format --indent-width=2 --no-use-tab hammerspoon/**/*.lua -i

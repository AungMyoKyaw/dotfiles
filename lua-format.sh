#!/bin/sh

find . -type f -name "*.lua" -exec lua-format --indent-width=2 --column-limit=80 --no-use-tab --double-quote-to-single-quote --chop-down-table -i {} +

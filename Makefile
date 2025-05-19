MAKEINFO=makeinfo
POSTS=$(wildcard infopages/posts/*.texi)
HTML_HEADER=$(shell cat _header.html)

all: output/index.html title

output/index.html: infopages/index.texi $(POSTS)
	@echo "MAKEINFO\t$<"
	@cd infopages/ && $(MAKEINFO) --css-include=../style.css -o ../output --html index.texi -c HIGHLIGHT_SYNTAX=source-highlight -c AFTER_BODY_OPEN="$(HTML_HEADER)"

.PHONY: title
title:
	@$(MAKE) -C comments

.PHONY: clean
clean:
	@rm -rf output

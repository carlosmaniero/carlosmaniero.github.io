MAKEINFO=makeinfo
POSTS=$(wildcard infopages/posts/*.texi)

all: output/index.html title

output/index.html: infopages/index.texi $(POSTS)
	@echo "MAKEINFO\t$<"
	@cd infopages/ && $(MAKEINFO) --css-include=../style.css -o ../output --html index.texi

.PHONY: title
title:
	@$(MAKE) -C comments

.PHONY: clean
clean:
	@rm -rf output

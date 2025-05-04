MAKEINFO=makeinfo
POSTS=$(wildcard infopages/posts/*.texi)

all: output/index.html

output/index.html: infopages/index.texi $(POSTS)
	@cd infopages/ && $(MAKEINFO) --css-include=../style.css -o ../output --html index.texi

.PHONY: clean
clean:
	@rm -rf output

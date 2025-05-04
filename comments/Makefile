POSTS=$(filter-out ../output/index.html, $(wildcard ../output/*.html))
TITLE_FILES=$(patsubst %,%.title,$(POSTS))

all: categorize

../output/%.html.title: ../output/%.html
	@echo "GEN-TITLE\t$<"
	@perl gen-title.pl $<

.PHONY: categorize
categorize: $(TITLE_FILES)
	@cat $(TITLE_FILES) | xargs -I % echo '"%"' | xargs perl ./categorize.pl

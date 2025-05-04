POSTS=$(filter-out ../output/index.html, $(wildcard ../output/*.html))
TITLE_FILES=$(patsubst %,%.title,$(POSTS))

all: $(TITLE_FILES)

../output/%.html.title: ../output/%.html
	@echo "GEN-TITLE\t$<"
	@perl gen-title.pl $<

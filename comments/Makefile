POSTS=$(filter-out ../output/index.html, $(wildcard ../output/*.html))
TITLE_FILES=$(patsubst %,%.title,$(POSTS))
COMMENTS_FILES=$(patsubst %,%.comments,$(POSTS))

all: ../output/mbox/ categorize $(COMMENTS_FILES)

../output/%.html.title: ../output/%.html
	@echo "GEN-TITLE\t$<"
	@perl gen-title.pl $<

.PHONY: categorize
categorize: $(TITLE_FILES)
	@cat $(TITLE_FILES) | xargs -I % echo '"%"' | xargs perl ./categorize.pl

../output/%.html.comments: ../output/%.html
	@printf "GEN-COMMENTS\t"
	@cat $<.title
	@cat $<.title | xargs -I % perl ./html.pl '%' > $@
	@head -n -2 $< > $<.partial
	@mv $<.partial $<
	@cat "$@" >> "$<"
	@echo "</body></html>" >> $<

../output/mbox/:
	@mkdir ../output/mbox/

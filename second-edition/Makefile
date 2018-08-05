UPSTREAM_SOURCES = $(wildcard en-src/*.md)
HTML_SOURCES = $(wildcard mt-src/*.html)
MDBOOK_SOURCES = $(patsubst mt-src/%.html,src/%.md,$(HTML_SOURCES))
XML_SOURCES = $(patsubst mt-src/%.html,xml/%.xml,$(HTML_SOURCES))
PROG = $(shell which maptrans)

all: map2html back2md book book.xml
.PHONY: all map2html back2md

en-md-html/%.html: en-src/%.md $(PROG)
	maptrans map2html $< en-md-html

map2html: $(patsubst en-src/%.md,en-md-html/%.html,$(UPSTREAM_SOURCES))


# Convert to Markdown
stage1/%.md: mt-src/%.html $(PROG)
	maptrans back2md $< stage1

# Apply the translation table
stage2/%.md: stage1/%.md $(PROG) table.yaml
	maptrans apply-table $< stage2

# Apply the monkey patches
sink/%.md: stage2/%.md $(wildcard patch/%.patch)
	cp $< $@
	$(if $(patsubst stage2/%.md,patch/%.patch,$<),\
		patch -f $@ $(patsubst stage2/%.md,patch/%.patch,$<)) || true

back2md: $(patsubst en-src/%.md,sink/%.md,$(UPSTREAM_SOURCES))


src/%.md: sink/%.md ruby.yaml
	maptrans uncomment $< src

book: $(MDBOOK_SOURCES)
	~/.cargo/bin/mdbook build


book.xml: header.xml $(XML_SOURCES)
	cat header.xml > $@
	for a in $$(echo xml/{fore*,ch01*,a*}); do\
		echo -n "<Section filename=\"$$a\">" >> $@;\
		cat $$a >> $@;\
		echo "</Section>" >> $@;\
	done
	echo "</Book>" >> $@

xml/%.xml: src/%.md
	maptrans xml $< xml

.PRECIOUS: stage1/%.md stage2/%.md sink/%.md

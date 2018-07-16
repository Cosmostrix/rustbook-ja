SOURCES = $(wildcard en-src/*.md)
SOURCES2 = $(wildcard mt-ja-src/*.html)
PROG = $(shell which maptrans)

all: map2html back2md

back2md: $(patsubst mt-ja-src/%.html,src/%.md,$(SOURCES2))
	~/.cargo/bin/mdbook build

src/%.md: ja-md/%.md #patch/%.patch
	maptrans uncomment $< src

ja-md/%.md: mt-ja-src/%.html $(PROG)
	maptrans back2md $< ja-md

map2html: $(patsubst en-src/%.md,en-md-html/%.html,$(SOURCES))

en-md-html/%.html: en-src/%.md $(PROG)
	maptrans map2html $< en-md-html

.PHONY: all map2html back2md
.PRECIOUS: ja-md/%.md

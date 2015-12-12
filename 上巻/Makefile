.PHONY: all browse clean

all: out/rustbook.ja.pdf #out/rustbook out/gitbook.pdf

src/translation-table.md: make_translation_table.rb Project明治回帰.yaml src/translation-table-template.md
	ruby make_translation_table.rb > $@

out/rustbook: src/*.md src/translation-table.md rust.css
	cd src; rustbook build
	mkdir -p out; rm -rf $@
	mv -f src/_book $@
	cp rust.css out

out/gitbook.pdf: src/*.md src/translation-table.md
	mkdir -p out; gitbook pdf src $@

out/rustbook.ja.pdf: src/*.md src/translation-table.md template.tex makepdf
	rm -f out/*/main.{aux,log,out,tex,toc}
	./makepdf ja -d

browse: out/rustbook
	firefox out/rustbook/index.html

clean:
	rm -rf out
	rm src/translation-table.md

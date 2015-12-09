all: out/rustbook out/gitbook.pdf out/rustbook.ja.pdf

src/translation-table.md: Project明治回帰.yaml
	ruby make_translation_table.rb > $@

out/rustbook: src/*.md src/translation-table.md rust.css
	cd src; rustbook build
	mkdir -p out; rm -rf $@
	mv -f src/_book $@
	cp rust.css out

out/gitbook.pdf: src/*.md src/translation-table.md
	mkdir -p out; gitbook pdf src $@

out/rustbook.ja.pdf: src/*.md src/translation-table.md template.tex
	rm -f out/*/main.{aux,log,out,tex,toc}
	./makepdf ja -d

browse: out/rustbook
	firefox $@/index.html

clean:
	rm -r out
	rm src/translation-table.md

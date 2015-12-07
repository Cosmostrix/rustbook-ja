all: out/rustbook out/tex out/gitbook.pdf

src/translation-table.md: Project明治回帰.yaml
	ruby make_translation_table.rb > $@

out/rustbook: src/*.md src/translation-table.md
	cd src; rustbook build
	mkdir -p out; rm -rf out/rustbook
	mv -f src/_book out/rustbook
	cp rust.css out

out/gitbook.pdf: src/*.md src/translation-table.md
	mkdir -p out; gitbook pdf src out/gitbook.pdf

out/tex: src/*.md src/translation-table.md header.tex GitbookToPandoc.jar
	mkdir -p out; rm -rf out/tex
	java -jar GitbookToPandoc.jar src out/tex

browse: out/rustbook
	firefox out/rustbook/index.html

clean:
	rm -r out
	rm src/translation-table.md

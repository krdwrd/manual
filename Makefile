.PHONY: clean

default: htmls pdf

pdf: manual.tex
	pdflatex manual 
	-bibtex manual 
	pdflatex manual 
	pdflatex manual 

htmls: manual.tex
	mkdir html || true
	latex2html \
		-dir html \
		-contents index.html \
		-contents_in_navigation \
		-local_icons \
		-no_footnode \
		manual.tex
	cp html.css html/manual.css

clean:
	rm -rf *.pdf *.log *.aux *.out html krdwrd_tutorial 

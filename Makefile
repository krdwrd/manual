PDF_TARGETS = manual.pdf
TEX_SRCS := $(patsubst %pdf,%tex,$(PDF_TARGETS))
TEX_XTRA_SRCS :=
BIB_SRCS := $(wildcard *.bib)

TEX = pdflatex -file-line-error -interaction=errorstopmode
LATEXMK_CE_OPTS = '$$cleanup_includes_cusdep_generated=1; \
		$$clean_ext = "%R.snm %R.nav"; \
		$$clean_full_ext = $$clean_ext; '

.PHONY: all clean cleanall

all: $(PDF_TARGETS) html/manual.html

$(PDF_TARGETS): %.pdf:%.tex $(TEX_XTRA_SRCS) $(BIB_SRCS)
	latexmk -pdf -pdflatex="$(TEX)" -bibtex -use-make $<

html/manual.html: $(TEX_SRCS) $(TEX_XTRA_SRCS) $(BIB_SRCS)
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
	latexmk -c -bibtex -e $(LATEXMK_CE_OPTS)

cleanall:
	latexmk -C -bibtex -e $(LATEXMK_CE_OPTS)
	rm -rf html || true

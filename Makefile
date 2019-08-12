PDF_TARGETS = manual.pdf
TEX_SRCS := $(patsubst %pdf,%tex,$(PDF_TARGETS))
TEX_XTRA_SRCS :=
BIB_SRCS := $(wildcard *.bib)

TEX = pdflatex -file-line-error -interaction=errorstopmode
LATEXMK_CE_OPTS = '$$cleanup_includes_cusdep_generated=1; \
		$$clean_ext = "%R.snm %R.nav"; \
		$$clean_full_ext = $$clean_ext; '

.PHONY: all clean cleanall

all: $(PDF_TARGETS) docs/manual.html

$(PDF_TARGETS): %.pdf:%.tex $(TEX_XTRA_SRCS) $(BIB_SRCS)
	latexmk -pdf -pdflatex="$(TEX)" -bibtex -use-make $<

docs/manual.html: $(TEX_SRCS) $(TEX_XTRA_SRCS) $(BIB_SRCS)
	latex2html \
		-dir docs \
		-contents index.html \
		-contents_in_navigation \
		-local_icons \
		-no_footnode \
		manual.tex
	cp html.css docs/manual.css

clean:
	latexmk -c -bibtex -e $(LATEXMK_CE_OPTS)

cleanall:
	latexmk -C -bibtex -e $(LATEXMK_CE_OPTS)
	git reset -- docs

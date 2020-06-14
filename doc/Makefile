
SVG := $(wildcard img/*.svg)
PDF := $(patsubst %.svg, %.pdf, $(SVG))

all: memoria.pdf 

memoria.pdf: memoria.tex memoria.bib $(PDF)
	pdflatex memoria
	bibtex memoria
	pdflatex memoria
	pdflatex memoria

img/%.pdf: img/%.svg
	rsvg-convert -f pdf -o $@ $<

clean:
	rm -f *.acn *.aux *.glo *.ist *.lof *.log *.lot *.out *.pdf *.toc *.bbl *.blg $(PDF)



SVG := $(wildcard img/*.svg)
PDF := $(patsubst %.svg, %.pdf, $(SVG))

all: presentacion.pdf 

presentacion.pdf: presentacion.tex $(PDF)
	pdflatex presentacion
	pdflatex presentacion

img/%.pdf: img/%.svg
	rsvg-convert -f pdf -o $@ $<

convert: presentacion.pdf
	mkdir -p out
	convert -density 288 presentacion.pdf -resize 2000x2000 out/slide.png

clean:
	rm -f *.acn *.aux *.glo *.ist *.lof *.log *.lot *.out *.pdf *.toc *.bbl *.blg *.nav *.snm *.vrb $(PDF)
	rm -rf out







all: memoria.pdf

memoria.pdf: memoria.tex memoria.bib img/*
	pdflatex memoria
	bibtex memoria
	pdflatex memoria
	pdflatex memoria



clean:
	rm -f *.acn *.aux *.glo *.ist *.lof *.log *.lot *.out *.pdf *.toc *.bbl *.blg



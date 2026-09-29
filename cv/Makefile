# Build the CV with LuaLaTeX. Targets: all (default), preview, ats, clean.
MAIN := cv
PDF  := Kaung_Nyo_Lwin_CV.pdf

all: $(PDF)

$(PDF): $(MAIN).tex aicv.cls
	latexmk $(MAIN).tex
	cp build/$(MAIN).pdf $(PDF)

# PNG page previews in preview/
preview: $(PDF)
	mkdir -p preview
	pdftoppm -png -r 120 $(PDF) preview/page

# Plain-text extraction, the way an applicant-tracking system reads the PDF
ats: $(PDF)
	pdftotext -enc UTF-8 $(PDF) preview/ats-extract.txt
	@echo "Wrote preview/ats-extract.txt"

clean:
	latexmk -C $(MAIN).tex
	rm -rf build

.PHONY: all preview ats clean

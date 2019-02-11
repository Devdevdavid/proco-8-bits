
TARGET_NAME   = OSE

all: $(TARGET_NAME).pdf

$(TARGET_NAME).pdf: clean $(TARGET_NAME).tex
	pdflatex $(TARGET_NAME)
	pdflatex $(TARGET_NAME)

clean:
	rm -f *.ps *.dvi *.aux *.toc *.idx *.ind *.ilg *.log *.out *.brf *.blg *.bbl $(TARGET_NAME).pdf

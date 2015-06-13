TARGET=fallout.pdf

all: $(TARGET)

#%.pdf: %.ps
#	ps2pdf14 $<

%.pdf: %.tex
	pdflatex $<
	pdflatex $<

%.ps: %.dvi
	dvips -Ppdf -G0 $< -o $@

%.dvi: %.tex
	latex $<

clean:
	rm -f *.log *.aux $(TARGET) *.pdf *.ps *.dvi *.out

push: all
	s3cmd put -P fallout.pdf s3://fallout/
	s3cmd put -P index.html s3://fallout/
	s3cmd put -P fallout_gensokyo_01-intro.pdf s3://fallout/

intro: Fallout_Gensokyo_01-Intro.pdf
	s3cmd put -P $< s3://fallout/

fix-quotes:
	sed -r -i -e "s/”/''/g" -e "s/“/\`\`/g"  fallout.tex
	sed -r -i -e "s/’/'/g"  fallout.tex

fix-ellipsis:
	sed -r -i -e "s/…/.../g" fallout.tex

fix-endashes:
	sed -r -i -e "s/—/--/g" fallout.tex

fix-endline-spaces:
	sed -r -i -e "s/[ ]+$$//" fallout.tex

fix-ldots:
	sed -r -i -e "s/\.\.$$/\\\\ldots/"  fallout.tex

# This will not end well in LaTeX
#fix-percents:
#	sed -r -i -e "s/([^\\])%/\\1\\\\%/g"  fallout.tex


fix-all: fix-quotes fix-ellipsis fix-endashes fix-ldots fix-endline-spaces

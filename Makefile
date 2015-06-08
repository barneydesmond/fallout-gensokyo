TARGET=fallout.pdf

all: $(TARGET)

%.pdf: %.ps
	ps2pdf14 $<

%.ps: %.dvi
	dvips -Ppdf -G0 $< -o $@

%.dvi: %.tex cv-commands.tex
	latex $<

clean:
	rm -f *.log *.aux $(TARGET) *.ps *.dvi

push: all
	s3cmd put -P fallout.pdf s3://fallout/
	s3cmd put -P index.html s3://fallout/

fix-quotes:
	sed -r -i -e "s/”/''/g" -e "s/“/\`\`/g"  fallout.tex

fix-ldots:
	sed -r -e "s/\.\.$$/\\\\ldots/"  fallout.tex

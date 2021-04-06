all: octave.log

octave.log: rc.m
	octave $< > $@

clean:
	@rm -f octave.log octave-workspace *.eps *~
	@rm -f *.tex
	@rm -f *.txt *.pdf *.png

.PHONY: clean

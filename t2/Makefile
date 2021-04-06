# ------------------------------------------------------------
# type "make" command in the Linux terminal create report.pdf
#
# type "make clean" to delete all generated files
# ------------------------------------------------------------

all: data
	make -C mat
	make -C sim
	make -C doc
	cp doc/report.pdf ./


data:
	./t2_datagen.py ${PARAMS} > mat/data.txt

clean:
	make -C mat clean
	make -C sim clean
	make -C doc clean
	rm -f report.pdf

.PHONY: all clean

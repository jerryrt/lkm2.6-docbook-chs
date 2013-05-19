TARGET=lkmpg
TARBALL = ${TARGET}.tar.bz2
EXAMPLES = ./${TARGET}-examples
BACKUPDIR=/usr/local/backup/${TARGET}
LDPDSL='/usr/share/sgml/docbook/stylesheet/dsssl/modular/html/ldp.dsl\#html'
DOCDSL='/usr/share/sgml/docbook/stylesheet/dsssl/modular/html/docbook.dsl'
TIMESTAMP=`/bin/date +'%Y-%m-%d-%H-%M'`
JADEOPTIONS=-t sgml -i html -V nochunks -E 10000000 -d $(LDPDSL)
WEBDIR='./html'
IMAGES=seq_file.png
# Make the darn thing...
#
new:
	make index
	openjade ${JADEOPTIONS} ${TARGET}.sgml > ${TARGET}.html
	-ldp_print ${TARGET}.html
	#make tidy


# This target creates index stuff
#
index:
	collateindex.pl -N -o index.sgml
	openjade -t sgml -E 10000000 -V html-index -d ${DOCDSL} ${TARGET}.sgml
	collateindex.pl -g -t Index -i doc-index -o index.sgml HTML.index


publish:
	@make clean
	@make
	@./extractor
	cp ${TARGET}.html /www/linux/writing/lkmpg
	cp ${TARGET}.ps   /www/linux/writing/lkmpg
	@make clean
	cd ..; tar jcv lkmpg > ${TARBALL}
	mv ../${TARBALL} .
	cp ${TARBALL} /www/linux/writing/lkmpg


# Get rid of the temp files created during the index and document build.
#
tidy:
	@rm -rf body.html title.html HTML.index index.sgml [a-km-z]*.html ln14.html


# Get rid of everything.
#
clean:
	make tidy
	@rm -rf ${EXAMPLES}/*/*.o ${EXAMPLES}/*/*.ko ${TARBALL} *.html *.ps *.pdf

# Makefile

SITEFUN=/usr/local/share/zsh/site-functions
LOCALBIN=/usr/local/bin

install: 
	test -d ${SITEFUN} || mkdir ${SITEFUN}
	(cd distribution/functions && cp -p * ${SITEFUN} )
	test -d ${LOCALBIN} || mkdir ${LOCALBIN}
	(cd distribution/bin && cp -p * ${LOCALBIN})


# Makefile

HOMEBREW_PREFIX ?= /usr/local

SITEFUN=$(HOMEBREW_PREFIX)/share/zsh/site-functions
LOCALBIN=$(HOMEBREW_PREFIX)/bin

install: 
	test -d ${SITEFUN} || mkdir ${SITEFUN}
	(cd distribution/functions && cp -p * ${SITEFUN} )
	test -d ${LOCALBIN} || mkdir ${LOCALBIN}
	(cd distribution/bin && cp -p * ${LOCALBIN})


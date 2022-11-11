# Makefile

install: ~/.aws/profile_organizer ~/.zshrc

~/.aws/profile_organizer: .
	test -d $@ || mkdir $@
	(cd distribution && cp -r . $@)

~/.zshrc: .
	( grep -q profile_organizer/functions ~/.zshrc || cat distribution/rc/addon >> ~/.zshrc )

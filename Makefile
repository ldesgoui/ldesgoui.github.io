#
# Makefile
#

DOMAIN := ldesgoui.xyz
REPO := $(shell git config --get remote.origin.url)


all: $(addprefix master/, CNAME index.html resume.pdf resume.html)

master:
	git clone --branch master "$(REPO)" "$@"
	rm -rf $@/*

master/CNAME: master
	echo $(DOMAIN) > $@

master/%.html: %.md
	pandoc --standalone --to html5 --output "$@" "$<"

master/%.pdf: %.md
	pandoc --standalone --pdf-engine xelatex --output "$@" "$<"

clean:
	rm -rf master/*

fclean: clean
	rm -rf master

re: fclean all

push: all
	(cd master && git add . && git commit -m "$(shell date)" && git push origin master)

.PHONY: all clean fclean re push

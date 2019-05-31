#
# Makefile
#

all: $(addprefix master/, CNAME index.html resume.pdf resume.html)

master:
	git clone --branch master "$(shell git config --get remote.origin.url)" "$@"
	rm -rf $@/*

master/CNAME: master
	echo "ldesgoui.xyz" > $@

master/%.html: %.md
	pandoc --standalone --to html5 --output "$@" "$<"

master/%.pdf: %.md
	pandoc --standalone --pdf-engine xelatex --output "$@" "$<"

push: all
	(cd master \
		&& git add . \
		&& git commit -m "$(shell git log -1 --pretty=format:'%s')" \
		&& git push origin master \
	)

clean:
	rm -rf master/*

fclean: clean
	rm -rf master

re: fclean all

.PHONY: all push clean fclean re

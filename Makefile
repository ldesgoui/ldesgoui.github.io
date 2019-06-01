#
# Makefile
#

FILES := CNAME
FILES += index.html
FILES += resume.pdf resume.html
FILES += style.css

GENERATED := $(addprefix master/, $(FILES))

all: $(GENERATED)

master:
	git clone --depth 1 --branch master "$(shell git config --get remote.origin.url)" "$@"
	rm -rf "$@"/*

master/%.html: %.md | master
	mkdir -p "$(@D)"
	pandoc --standalone --css "/style.css" --to html5 --output "$@" "$<"

master/%.pdf: %.md | master
	mkdir -p "$(@D)"
	pandoc --standalone --pdf-engine xelatex --output "$@" "$<"

master/%: % | master
	mkdir -p "$(@D)"
	cp "$<" "$@"

push: all
	(cd master \
		&& git add . \
		&& git commit -m "$(shell git log -1 --pretty=format:'%s')" \
		&& git push origin master \
	)

clean:
	rm -f $(GENERATED)

fclean: clean
	rm -rf master

re: fclean all

serve: all
	python3 -m http.server -d master

watch:
	ls -I master | entr -d make || make watch

dev:
	make watch &
	make serve
	pkill $$

.PHONY: all push clean fclean re serve watch dev

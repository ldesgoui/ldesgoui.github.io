#
# Makefile
#

GENERATED := CNAME
GENERATED += index.html
GENERATED += resume.pdf resume.html
GENERATED += style.css
GENERATED += avatar.webp avatar.png

GENERATED := $(addprefix master/, $(GENERATED))

all: $(GENERATED)

master:
	git clone --depth 1 --branch master "$(shell git config --get remote.origin.url)" "$@"
	rm --recursive --force "$@"/*

master/%.html: %.md template.html | master
	mkdir --parents "$(@D)"
	pandoc --standalone --template template.html --css /style.css --to html5 --output "$@" "$<"

master/%.pdf: %.md | master
	mkdir --parents "$(@D)"
	pandoc --standalone --pdf-engine xelatex --output "$@" "$<"

master/%: % | master
	mkdir --parents "$(@D)"
	cp "$<" "$@"

master/%.png: %.webp |
	mkdir --parents "$(@D)"
	convert "$<" "$@"

push: all
	minify -a master
	(cd master \
		&& git add . \
		&& git commit --message "$(shell git log -1 --pretty=format:'%s')" \
		&& git push origin master \
	)

clean:
	rm --force $(GENERATED)

fclean: clean
	rm --recursive --force master

re: fclean all

serve: all
	darkhttpd master

watch:
	ls -I master | entr -d make || make watch

dev:
	bash -c "trap 'pkill --parent $$$$' 1 2 9; make serve & make watch"

.PHONY: all push clean fclean re serve watch dev

#
# Makefile
#

CSS := style.css
CSS += 'https://fonts.googleapis.com/css?family=Fira+Sans|Fira+Mono&display=swap'

GENERATED := CNAME
GENERATED += index.html
GENERATED += resume.pdf resume.html
GENERATED += style.css
GENERATED += avatar.webp avatar.png avatar.jpg

GENERATED := $(addprefix master/, $(GENERATED))


all: $(GENERATED)

master:
	git init master
	(cd master && git remote add origin "$(shell git config --get remote.origin.url)")

master/%: % | master
	mkdir --parents "$(@D)"
	cp "$<" "$@"

master/%.html: %.md template.html | master
	mkdir --parents "$(@D)"
	pandoc --standalone --template template.html $(addprefix --css , $(CSS)) --output "$@" "$<"

master/%.pdf: %.md | master
	mkdir --parents "$(@D)"
	pandoc --standalone --pdf-engine xelatex --output "$@" "$<"

master/%.webp: %.webp | master
	mkdir --parents "$(@D)"
	convert "$<" -quality 75 -define webp:method=6 "$@"

master/%.png: %.webp | master
	mkdir --parents "$(@D)"
	convert "$<" -quality 75 "$@"

master/%.jpg: %.webp | master
	mkdir --parents "$(@D)"
	convert "$<" -quality 75 "$@"

push: re
	minify -a master
	(cd master \
		&& git add . \
		&& git commit --message "$(shell git log -1 --pretty=format:'%s')" \
		&& git push origin master \
	)

clean:
	rm --recursive --force master

re: clean all

serve: all
	darkhttpd master

watch:
	ls -I master | entr -d make || make watch

dev:
	bash -c "trap 'pkill --parent $$$$' 1 2 9; make serve & make watch"

.PHONY: all push clean re serve watch dev

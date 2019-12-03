#
# Makefile
#

CSS := style.css
CSS += 'https://fonts.googleapis.com/css?family=Fira+Sans|Fira+Mono&display=swap'

GENERATED += index.html
GENERATED += resume.pdf resume.html
GENERATED += style.css
GENERATED += avatar.webp avatar.png avatar.jpg
GENERATED += bimi.svg

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

master/%.jpg: %.webp | master
	mkdir --parents "$(@D)"
	convert "$<" -quality 75 "$@"

master/bimi.svg: avatar.webp | master
	mkdir --parents "$(@D)"
	convert "$<" -quality 75 bmp:- \
		| potrace --output "$@" --backend svg \
			--turdsize 50 --stretch 1 --color "#6699cc" --flat --blacklevel 0.3 --invert

push: re
	minify -vro master/ master/
	(cd master \
		&& git add . \
		&& git commit --message "$(shell git log -1 --pretty=format:'%s')" \
		&& git push origin master --force \
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

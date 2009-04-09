PAGES=../.yaml-spec-gh-pages

all:
	mv $(PAGES)/* ./
	rm -fr $(PAGES)

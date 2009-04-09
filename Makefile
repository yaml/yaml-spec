PAGES_DIR=../.yaml-spec-gh-pages

all:
	mv $(PAGES_DIR)/* ./
	rm -fr $(PAGES_DIR)

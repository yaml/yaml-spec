SHELL := bash

EATME := eatme
REF_PARSER := ref-parser
NPM_YAML := npm-yaml

EATME_REPO := https://github.com/eatme-dev/eatme
REF_PARSER_REPO := https://github.com/yaml/yaml-reference-parser
NPM_YAML_REPO := https://github.com/eemeli/yaml

SPEC_12_HTML := yaml-spec-12.html

ALL := \
    $(EATME) \
    $(REF_PARSER) \
    $(NPM_YAML) \
    $(SPEC_12_HTML) \

TMPEXT := /tmp/yaml-spec-ext

.DELETE_ON_ERROR:
default:

build: $(ALL)

clean:
	rm -fr $(ALL)

$(EATME):
	git clone $(EATME_REPO) --branch=devel $@

$(REF_PARSER):
	git clone $(REF_PARSER_REPO) $@

$(NPM_YAML):
ifneq ($(wildcard $(TMPEXT)),)
	cp -r $(TMPEXT)/$@ $@
else ifneq ($(shell command -v npm),)
	git clone $(NPM_YAML_REPO) $@
	git -C $(NPM_YAML) worktree add -f v2 v2.0.0-6
	git -C $(NPM_YAML) worktree add -f v1 v1.10.2
	patch $@/config/rollup.browser-config.js < npm-yaml-rollup-master.patch
	(cd $@ && npm install . && npm run build)
	patch $@/v1/rollup.browser-config.js < npm-yaml-rollup-v1.patch
	(cd $@/v1 && npm install . && npm run build)
	patch $@/v2/config/rollup.browser-config.js < npm-yaml-rollup-v2.patch
	(cd $@/v2 && npm install . && npm run build)
	mkdir -p $(TMPEXT)
	cp -r $@ $(TMPEXT)/
else
	@echo "*** NOTICE: 'npm' not available."
	@echo "*** Can't build NodeJS variants for 'yaml.js'."
	exit 1
endif

$(SPEC_12_HTML):
	curl https://yaml.org/spec/1.2/spec.html > $@

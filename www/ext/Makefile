EATME := eatme
REF_PARSER := ref-parser
NPM_YAML := npm-yaml

EATME_REPO := https://github.com/eatme-dev/eatme
REF_PARSER_REPO := https://github.com/yaml/yaml-reference-parser
NPM_YAML_REPO := https://github.com/eemeli/yaml

ALL := \
    $(EATME) \
    $(REF_PARSER) \
    $(NPM_YAML) \

default:

build: $(ALL)

clean:
	rm -fr $(ALL)

$(EATME):
	git clone $(EATME_REPO) --branch=devel $@

$(REF_PARSER):
	git clone $(REF_PARSER_REPO) $@

$(NPM_YAML):
	git clone $(NPM_YAML_REPO) $@
	git -C $(NPM_YAML) worktree add -f v2 v2.0.0-6
	git -C $(NPM_YAML) worktree add -f v1 v1.10.2
	patch $@/config/rollup.browser-config.js < rollup-master.patch
	(cd $@ && npm install . && npm run build)
	patch $@/v1/rollup.browser-config.js < rollup-v1.patch
	(cd $@/v1 && npm install . && npm run build)
	patch $@/v2/config/rollup.browser-config.js < rollup-v2.patch
	(cd $@/v2 && npm install . && npm run build)

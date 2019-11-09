#!make
# This is a generated file. Please make sure to edit source files.
PROJECT := $(if $(PROJECT),$(PROJECT),$(shell dirname $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))))
IDENIFIER := $(if $(IDENIFIER),$(IDENIFIER),unknown)
TITLE := $(if $(TITLE),$(TITLE),Unknown)
RELEASE := $(if $(RELEASE),$(RELEASE),Unofficial)
DOCS_FOLDER := $(if $(DOCS_FOLDER),$(DOCS_FOLDER),docs)
RULES_FOLDER := $(if $(RULES_FOLDER),$(RULES_FOLDER),rules)
RULES_IDENT := $(if $(RULES_IDENT),$(RULES_IDENT),rules)
VERSION := $(if $(GITHUB_REF),$(shell echo "$(GITHUB_REF)" | sed "s:.*/::g"),snapshot)
BUILD = structure example schematron xsd rules docs static
.DEFAULT_GOAL = default
define docker_pull
	@docker pull $(1)
endef
define docker_run
	$(call fold_start,$(1),$(2))
	@docker run --rm -i $(3) || touch $(PROJECT)/.failed
	$(call fold_end,$(1))
	@if [ -e $(PROJECT)/.failed ]; then \
		rm $(PROJECT)/.failed; \
		echo "\033[1;31mFailed\033[0m"; \
	fi
endef
ifeq "${TRAVIS}" "true"
define fold_end
	@echo "\ntravis_fold:end:$(1)\r";
endef
else
define fold_end
endef
endif
ifeq "${TRAVIS}" "true"
define fold_start
	@echo -n "travis_fold:start:$(1)";
	@echo "\033[33;1m$(2)\033[0m"
endef
else
define fold_start
	@echo "\033[33;1m$(2)\033[0m"
endef
endif
define skip
	@echo "\033[2;37mSkipping $(1)\033[0m"
endef
ifeq "${TRAVIS}" "true"
default: pull build
else
default: clean build ownership
endif
build: env scripts_pre $(BUILD) scripts_post
RULE_CLEAN=$(shell (test -e $(PROJECT)/target && echo true) || echo false)
clean:
ifeq "$(RULE_CLEAN)" "true"
	$(call docker_run,clean,Removing old target folder,\
			-v $(PROJECT):/src \
			alpine:3.8 \
			rm -rf /src/target)
else
	$(call skip,cleaning)
endif
ownership:
	$(call docker_run,ownership,Fixing ownership,\
			-v $(PROJECT):/src \
			alpine:3.8 \
			chown -R $(shell id -g ${USER}).$(shell id -g ${USER}) /src/target)
serve:
	$(call docker_run,serve,Serve serve,\
			-v $(PROJECT):/src \
			-w /src/target \
			-p 8000:8000 \
			python:3-alpine \
			python3 -m http.server 8000 -b 0.0.0.0)
pull:
	$(call fold_start,docker_pull,Pulling Docker images)
	$(call docker_pull,alpine:3.8)
	$(call docker_pull,difi/vefa-structure:0.7)
	$(call docker_pull,difi/vefa-validator)
	$(call docker_pull,klakegg/schematron)
	$(call docker_pull,asciidoctor/docker-asciidoctor)
	$(call docker_pull,alpine/git)
	$(call fold_end,docker_pull)
env:
	$(call docker_run,environment,Creating environment file,\
			-v $(PROJECT):/src \
			-v $(PROJECT)/target:/target \
			-e IDENTIFIER="$(IDENTIFIER)" \
			-e TITLE="$(TITLE)" \
			-e RELEASE="$(RELEASE)" \
			--entrypoint sh \
			-w /src \
			alpine/git \
			tools/ehf.sh trigger_environment)
RULE_DOCS=$(shell test -e $(PROJECT)/$(DOCS_FOLDER) && echo true || echo false)
docs:
ifeq "$(RULE_DOCS)" "true"
	$(call docker_run,docs,Creating documentation,\
			-v $(PROJECT):/src \
			-v $(PROJECT)/target/site:/target \
			-w /src/$(DOCS_FOLDER) \
			-e DIAGRAM=true \
			asciidoctor/docker-asciidoctor \
			sh /src/tools/ehf.sh trigger_asciidoctor)
else
	$(call skip,documentation)
endif
RULE_RULES=$(shell find $(PROJECT) -name buildconfig.xml | wc -l | xargs test "0" != && echo "true" || echo "false")
rules:
ifeq "$(RULE_RULES)" "true"
	$(call docker_run,rules,Running vefa-validator,\
			-v $(PROJECT):/src \
			difi/vefa-validator \
			build -x -t -n $(RULES_IDENT) -a $(RULES_FOLDER) -b $(VERSION) -target target/validator /src)
else
	$(call skip,rules)
endif
RULE_STRUCTURE=$(shell (test -e $(PROJECT)/project.xml && echo true) || echo false)
structure:
ifeq "$(RULE_STRUCTURE)" "true"
	$(call docker_run,structure,Running vefa-structure,\
			-v $(PROJECT):/src \
			-v $(PROJECT)/target:/target \
			difi/vefa-structure:0.7)
else
	$(call skip,structure)
endif
RULE_XSD=$(shell test -d $(PROJECT)/xsd && find $(PROJECT)/xsd -mindepth 1 -maxdepth 1 -type d | wc -l | xargs test '0' != && echo true || echo "false")
xsd:
ifeq "$(RULE_XSD)" "true"
	$(call docker_run,xsd,Packaging XSD files,\
			-v $(PROJECT):/src \
			-v $(PROJECT)/target:/target \
			klakegg/schematron \
			sh tools/ehf.sh trigger_xsd)
else
	$(call skip,xsds)
endif
RULE_SCRIPTS_PRE=$(shell test -d $(PROJECT)/scripts/pre && find $(PROJECT)/scripts/pre -maxdepth 1 -name '*.sh' | wc -l | xargs test "0" != && echo true || echo false)
scripts_pre:
ifeq "$(RULE_SCRIPTS_PRE)" "true"
	$(call docker_run,scripts_pre,Running pre scripts,\
			-v $(PROJECT):/src \
			-v $(PROJECT)/target:/target \
			klakegg/schematron \
			sh tools/ehf.sh trigger_scripts pre)
else
	$(call skip,pre scripts)
endif
RULE_SCRIPTS_POST=$(shell test -d $(PROJECT)/scripts/post && find $(PROJECT)/scripts/post -maxdepth 1 -name '*.sh' | wc -l | xargs test "0" != && echo true || echo false)
scripts_post:
ifeq "$(RULE_SCRIPTS_POST)" "true"
	$(call docker_run,scripts_post,Running post scripts,\
			-v $(PROJECT):/src \
			-v $(PROJECT)/target:/target \
			klakegg/schematron \
			sh tools/ehf.sh trigger_scripts post)
else
	$(call skip,post scripts)
endif
RULE_STATIC=$(shell test -e $(PROJECT)/static && echo true || echo false)
static:
ifeq "$(RULE_STATIC)" "true"
	$(call docker_run,static,Copy static content,\
			-v $(PROJECT):/src \
			-v $(PROJECT)/target:/target \
			-w /src/static \
			klakegg/schematron \
			sh /src/tools/ehf.sh trigger_static)
else
	$(call skip,static)
endif
RULE_SCHEMATRON=$(shell test -e $(PROJECT)/rules && find $(PROJECT)/rules -mindepth 2 -maxdepth 2 -name sch -type d | wc -l | xargs test "0" != && echo true || echo false)
schematron:
ifeq "$(RULE_SCHEMATRON)" "true"
	$(call docker_run,schematron,Packaging Schematron files,\
			-v $(PROJECT):/src \
			-v $(PROJECT)/target:/target \
			difi/ehfbuild \
			sh tools/ehf.sh trigger_schematron)
else
	$(call skip,schematron)
endif
RULE_EXAMPLE=$(shell test -d $(PROJECT)/rules && find $(PROJECT)/rules -mindepth 2 -maxdepth 2 -name example -type d | wc -l | xargs test "0" != && echo true || echo false)
example:
ifeq "$(RULE_EXAMPLE)" "true"
	$(call docker_run,examples,Packaging example files,\
			-v $(PROJECT):/src \
			-v $(PROJECT)/target:/target \
			klakegg/schematron \
			sh tools/ehf.sh trigger_examples)
else
	$(call skip,example files)
endif
.PHONY: default build clean ownership serve pull env docs rules structure xsd scripts_pre scripts_post static schematron example

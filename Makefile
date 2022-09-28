.PHONY: release
release: override library = Nodes
release: override platforms = macos catalyst ios tvos watchos
release: override bitcode = ENABLED
release:
	@make xcframework library="$(library)" platforms="$(platforms)" bitcode="$(bitcode)" version="$(version)"

.PHONY: xcframework
xcframework: library ?= $(shell make get-libraries | head -1)
xcframework: platforms ?= $(shell make get-platforms)
xcframework:
ifndef version
	$(error required variable: "version")
endif
ifeq ($(strip $(bitcode)),ENABLED)
	@./bin/create-xcframework "$(library)" "$(platforms)" BITCODE_ENABLED "$(version)"
else
	@./bin/create-xcframework "$(library)" "$(platforms)" BITCODE_DISABLED "$(version)"
endif

.PHONY: preview
preview: target ?= Nodes
preview:
	swift package --disable-sandbox preview-documentation --target "$(target)"

.PHONY: site
site: target ?= Nodes
site: prefix ?= `pwd`
site:
	swift package \
		--allow-writing-to-directory "$(prefix)/docs" \
		generate-documentation \
		--target "$(target)" \
		--disable-indexing \
		--transform-for-static-hosting \
		--output-path "$(prefix)/docs"
	cp docs.html "$(prefix)/docs/index.html"
	cp docs.html "$(prefix)/docs/documentation/index.html"

.PHONY: docs
docs: target ?= Nodes
docs: open ?= OPEN
docs: OUTPUT_PATH = .build/plugins/Swift-DocC/outputs
docs:
	swift package generate-documentation --target "$(target)"
	$(if $(filter $(open),OPEN),@open "$(OUTPUT_PATH)/$(target).doccarchive",)

.PHONY: preflight
preflight: output ?= pretty
preflight:
	@./bin/preflight "$(output)"

.PHONY: preflight-all
preflight-all: output ?= pretty
preflight-all:
	@./bin/preflight-all "$(output)"

.PHONY: get-libraries
get-libraries:
	@./bin/get-libraries

.PHONY: get-platforms
get-platforms:
	@./bin/get-platforms

.PHONY: get-deployment-target
get-deployment-target:
ifndef platform
	$(error required variable: "platform")
endif
	@./bin/get-deployment-target "$(platform)"

.PHONY: changes
changes: limit ?= 30
changes:
	@gh pr list -L "$(limit)" \
		--search "is:pr is:merged sort:updated-desc" \
		--json "number,title,author" \
		--template "$$TEMPLATE"

export TEMPLATE
define TEMPLATE
{{range .}}- {{.title}}
  - [#{{.number}}](https://github.com/TinderApp/Nodes/pull/{{.number}}) by [NAME](https://github.com/{{.author.login}})
{{end}}
endef

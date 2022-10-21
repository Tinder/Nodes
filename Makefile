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
site: prefix ?= $(shell pwd)
site: DOCC_PATH = $(shell xcrun --find docc)
site: ARCHIVE_PATH = .build/documentation/archive
site:
	@make docs open="no"
	"$(DOCC_PATH)" process-archive \
		transform-for-static-hosting \
		"$(ARCHIVE_PATH)/$(target).doccarchive" \
		--output-path "$(prefix)/_site"
	cp docs.html "$(prefix)/_site/index.html"
	cp docs.html "$(prefix)/_site/documentation/index.html"

.PHONY: docs
docs: target ?= Nodes
docs: destination ?= generic/platform=iOS
docs: open ?= OPEN
docs: workaround ?= DISABLED
docs: DERIVED_DATA_PATH = .build/documentation/data
docs: ARCHIVE_PATH = .build/documentation/archive
docs:
	@mkdir -p "$(DERIVED_DATA_PATH)" "$(ARCHIVE_PATH)"
ifeq ($(strip $(workaround)),ENABLED)
# BEGIN: Temporary Xcode 14 workaround to fix DocC CI issue
	swift package dump-pif >/dev/null
	xcodebuild clean \
		-scheme "$(target)" \
		-destination "$(destination)" \
		-derivedDataPath "$(DERIVED_DATA_PATH)" || true
# END: Temporary Xcode 14 workaround to fix DocC CI issue
endif
	xcodebuild docbuild \
		-scheme "$(target)" \
		-destination "$(destination)" \
		-derivedDataPath "$(DERIVED_DATA_PATH)"
	@find "$(DERIVED_DATA_PATH)" \
		-type d \
		-name "$(target).doccarchive" \
		-exec cp -R {} "$(ARCHIVE_PATH)/" \;
	$(if $(filter $(open),OPEN),@open "$(ARCHIVE_PATH)/$(target).doccarchive",)

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

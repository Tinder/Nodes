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
preview: library ?= Nodes
preview: catalog ?= _Documentation
preview: docc = $(shell xcrun --find docc)
preview: SYMBOL_GRAPH_PATH = .build/symbol-graphs
preview: DOCC_SYMBOL_GRAPH_PATH = .build/documentation/symbol-graphs
preview: OUTPUT_PATH = .build/documentation/html
preview:
	@mkdir -p "$(SYMBOL_GRAPH_PATH)" "$(DOCC_SYMBOL_GRAPH_PATH)" "$(OUTPUT_PATH)"
	swift build \
		--target "$(library)" \
		-Xswiftc -emit-symbol-graph \
		-Xswiftc -emit-symbol-graph-dir \
		-Xswiftc "$(SYMBOL_GRAPH_PATH)"
	@cp "$(SYMBOL_GRAPH_PATH)/$(library)"* "$(DOCC_SYMBOL_GRAPH_PATH)"
	@open "http://localhost:8000/Documentation/$(library)"
	"$(docc)" preview \
		"Sources/$(library)/$(catalog).docc" \
		--additional-symbol-graph-dir "$(DOCC_SYMBOL_GRAPH_PATH)" \
		--output-dir "$(OUTPUT_PATH)"

.PHONY: docs
docs: library ?= Nodes
docs: destination ?= generic/platform=iOS
docs: open ?= OPEN
docs: DERIVED_DATA_PATH = .build/documentation
docs: DOCUMENTATION_PATH = Documentation/Generated
docs:
	@mkdir -p "$(DERIVED_DATA_PATH)" "$(DOCUMENTATION_PATH)"
	xcodebuild docbuild \
		-scheme "$(library)" \
		-destination "$(destination)" \
		-derivedDataPath "$(DERIVED_DATA_PATH)"
	@find "$(DERIVED_DATA_PATH)" \
		-type d \
		-name "$(library).doccarchive" \
		-exec cp -R {} "$(DOCUMENTATION_PATH)/" \;
	$(if $(filter $(open),OPEN),@open "$(DOCUMENTATION_PATH)/$(library).doccarchive",)

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
{{range .}}
- {{.title}}
  - [#{{.number}}](https://github.com/TinderApp/Nodes/pull/{{.number}}) by [NAME](https://github.com/{{.author.login}}){{end}}
endef

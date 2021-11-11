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

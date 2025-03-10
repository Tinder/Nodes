.PHONY: release
release: override library = Nodes
release: override platforms = macos catalyst ios tvos watchos
release: override bitcode = DISABLED
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

.PHONY: open
open: fix
open:
	xed Package.swift

.PHONY: fix
fix: XCSHAREDDATA = .swiftpm/xcode/package.xcworkspace/xcshareddata
fix:
	@mkdir -p $(XCSHAREDDATA)
	@/usr/libexec/PlistBuddy -c \
		"Delete :FILEHEADER" \
		"$(XCSHAREDDATA)/IDETemplateMacros.plist" >/dev/null 2>&1 || true
	@header=$$'\n//  All Contributions by Match Group\n//\n//  Copyright © ___YEAR___ Tinder \(Match Group, LLC\)\n//\n//  Licensed under the Match Group Modified 3-Clause BSD License.\n//  See https://github.com/Tinder/Nodes/blob/main/LICENSE for license information.\n//'; \
	/usr/libexec/PlistBuddy -c \
		"Add :FILEHEADER string $$header" \
		"$(XCSHAREDDATA)/IDETemplateMacros.plist" >/dev/null 2>&1

.PHONY: lint
lint: format ?= emoji
lint:
	@swift package plugin \
		swiftlint lint --strict --progress --reporter "$(format)"

.PHONY: analyze
analyze: target ?= Nodes
analyze: format ?= emoji
analyze:
ifndef platform
	$(error required variable: "platform")
endif
	@DERIVED_DATA="$$(mktemp -d)"; \
	XCODEBUILD_LOG="$$DERIVED_DATA/xcodebuild.log"; \
	xcodebuild \
		-scheme "$(target)-Package" \
		-destination "generic/platform=$(platform)" \
		-derivedDataPath "$$DERIVED_DATA" \
		-configuration "Debug" \
		-skipPackagePluginValidation \
		CODE_SIGNING_ALLOWED="NO" \
		> "$$XCODEBUILD_LOG"; \
	swift package plugin \
		swiftlint analyze --strict --progress --reporter "$(format)" --compiler-log-path "$$XCODEBUILD_LOG"

.PHONY: delete-snapshots
delete-snapshots:
	@for snapshots in $$(find Tests -type d -name "__Snapshots__"); \
	do \
		rm -rf "$$snapshots"; \
		echo "Deleted $$snapshots"; \
	done

.PHONY: docs
docs: target ?= Nodes
docs: destination ?= generic/platform=iOS
docs: open ?= OPEN
docs: DERIVED_DATA_PATH = .build/documentation/data
docs: ARCHIVE_PATH = .build/documentation/archive
docs:
	@mkdir -p "$(DERIVED_DATA_PATH)" "$(ARCHIVE_PATH)"
	xcodebuild docbuild \
		-scheme "$(target)" \
		-destination "$(destination)" \
		-derivedDataPath "$(DERIVED_DATA_PATH)" \
		-skipPackagePluginValidation \
		OTHER_DOCC_FLAGS="--warnings-as-errors"
	@find "$(DERIVED_DATA_PATH)" \
		-type d \
		-name "$(target).doccarchive" \
		-exec cp -R {} "$(ARCHIVE_PATH)/" \;
	$(if $(filter $(open),OPEN),@open "$(ARCHIVE_PATH)/$(target).doccarchive",)

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
		--hosting-base-path "$(target)" \
		--output-path "$(prefix)/_site"
	cp docs.html "$(prefix)/_site/index.html"
	cp docs.html "$(prefix)/_site/documentation/index.html"

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

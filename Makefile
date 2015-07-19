TEMPORARY_FOLDER?=/tmp/CommandlineTool.ds
PREFIX?=/usr/local
BUILD_TOOL?=xcodebuild

XCODEFLAGS=-workspace 'CommandlineTool.xcworkspace' -scheme 'CommandlineTool' DSTROOT=$(TEMPORARY_FOLDER)

BUILT_BUNDLE=$(TEMPORARY_FOLDER)/Applications/CommandlineTool.app
SOURCEKITTEN_FRAMEWORK_BUNDLE=$(BUILT_BUNDLE)/Contents/Frameworks/CommandlineToolFramework.framework
SOURCEKITTEN_EXECUTABLE=$(BUILT_BUNDLE)/Contents/MacOS/CommandlineTool

FRAMEWORKS_FOLDER=/Library/Frameworks
BINARIES_FOLDER=/usr/local/bin

OUTPUT_PACKAGE=CommandlineTool.pkg

VERSION_STRING=$(shell agvtool what-marketing-version -terse1)
COMPONENTS_PLIST=CommandlineTool/Components.plist

.PHONY: all bootstrap clean install package test uninstall

all: bootstrap
	$(BUILD_TOOL) $(XCODEFLAGS) build

bootstrap:
	script/bootstrap

test: clean bootstrap
	$(BUILD_TOOL) $(XCODEFLAGS) test

clean:
	rm -f "$(OUTPUT_PACKAGE)"
	rm -rf "$(TEMPORARY_FOLDER)"
	$(BUILD_TOOL) $(XCODEFLAGS) clean

install: package
	sudo installer -pkg CommandlineTool.pkg -target /

uninstall:
	rm -rf "$(FRAMEWORKS_FOLDER)/CommandlineToolFramework.framework"
	rm -f "$(BINARIES_FOLDER)/CommandlineTool"

installables: clean bootstrap
	$(BUILD_TOOL) $(XCODEFLAGS) install

	mkdir -p "$(TEMPORARY_FOLDER)$(FRAMEWORKS_FOLDER)" "$(TEMPORARY_FOLDER)$(BINARIES_FOLDER)"
	mv -f "$(SOURCEKITTEN_FRAMEWORK_BUNDLE)" "$(TEMPORARY_FOLDER)$(FRAMEWORKS_FOLDER)/CommandlineToolFramework.framework"
	mv -f "$(SOURCEKITTEN_EXECUTABLE)" "$(TEMPORARY_FOLDER)$(BINARIES_FOLDER)/CommandlineTool"
	rm -rf "$(BUILT_BUNDLE)"

prefix_install: installables
	mkdir -p "$(PREFIX)/Frameworks" "$(PREFIX)/bin"
	cp -rf "$(TEMPORARY_FOLDER)$(FRAMEWORKS_FOLDER)/CommandlineToolFramework.framework" "$(PREFIX)/Frameworks/"
	cp -f "$(TEMPORARY_FOLDER)$(BINARIES_FOLDER)/CommandlineTool" "$(PREFIX)/bin/"
	install_name_tool -add_rpath "@executable_path/../Frameworks" "$(PREFIX)/bin/CommandlineTool"
	install_name_tool -add_rpath "@executable_path/../Frameworks/CommandlineToolFramework.framework/Versions/Current/Frameworks/" "$(PREFIX)/bin/CommandlineTool"

package: installables
	pkgbuild \
		--component-plist "$(COMPONENTS_PLIST)" \
		--identifier "com.yusuke.CommandlineTool" \
		--install-location "/" \
		--root "$(TEMPORARY_FOLDER)" \
		--version "$(VERSION_STRING)" \
		"$(OUTPUT_PACKAGE)"

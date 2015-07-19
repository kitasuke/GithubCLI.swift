TEMPORARY_FOLDER?=/tmp/CommandlineTool.dst
PREFIX?=/usr/local
BUILD_TOOL?=xcodebuild

XCODEFLAGS=-workspace 'CommandlineTool.xcworkspace' -scheme 'commandlinetool' DSTROOT=$(TEMPORARY_FOLDER)

BUILT_BUNDLE=$(TEMPORARY_FOLDER)/Applications/commandlinetool.app
SOURCEKITTEN_FRAMEWORK_BUNDLE=$(BUILT_BUNDLE)/Contents/Frameworks/CommandlineToolKit.framework
SOURCEKITTEN_EXECUTABLE=$(BUILT_BUNDLE)/Contents/MacOS/commandlinetool

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
	sudo rm -rf "$(FRAMEWORKS_FOLDER)/CommandlineToolKit.framework"
	sudo rm -f "$(BINARIES_FOLDER)/commandlinetool"

installables: clean bootstrap
	$(BUILD_TOOL) $(XCODEFLAGS) install

	mkdir -p "$(TEMPORARY_FOLDER)$(FRAMEWORKS_FOLDER)" "$(TEMPORARY_FOLDER)$(BINARIES_FOLDER)"
	mv -f "$(SOURCEKITTEN_FRAMEWORK_BUNDLE)" "$(TEMPORARY_FOLDER)$(FRAMEWORKS_FOLDER)/CommandlineToolKit.framework"
	mv -f "$(SOURCEKITTEN_EXECUTABLE)" "$(TEMPORARY_FOLDER)$(BINARIES_FOLDER)/commandlinetool"
	rm -rf "$(BUILT_BUNDLE)"

prefix_install: installables
	mkdir -p "$(PREFIX)/Frameworks" "$(PREFIX)/bin"
	cp -rf "$(TEMPORARY_FOLDER)$(FRAMEWORKS_FOLDER)/CommandlineToolKit.framework" "$(PREFIX)/Frameworks/"
	cp -f "$(TEMPORARY_FOLDER)$(BINARIES_FOLDER)/commandlinetool" "$(PREFIX)/bin/"
	install_name_tool -add_rpath "@executable_path/../Frameworks" "$(PREFIX)/bin/commandlinetool"
	install_name_tool -add_rpath "@executable_path/../Frameworks/CommandlineToolKit.framework/Versions/Current/Frameworks/" "$(PREFIX)/bin/commandlinetool"

package: installables
	pkgbuild \
		--component-plist "$(COMPONENTS_PLIST)" \
		--identifier "com.yusuke.CommandlineTool" \
		--install-location "/" \
		--root "$(TEMPORARY_FOLDER)" \
		--version "$(VERSION_STRING)" \
		"$(OUTPUT_PACKAGE)"

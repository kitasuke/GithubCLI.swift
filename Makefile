TEMPORARY_FOLDER?=/tmp/GithubCLI.dst
PREFIX?=/usr/local
BUILD_TOOL?=xcodebuild

XCODEFLAGS=-workspace 'GithubCLI.xcworkspace' -scheme 'github' DSTROOT=$(TEMPORARY_FOLDER)

BUILT_BUNDLE=$(TEMPORARY_FOLDER)/Applications/GithubCLI.app
SOURCEKITTEN_FRAMEWORK_BUNDLE=$(BUILT_BUNDLE)/Contents/Frameworks/GithubCLIKit.framework
SOURCEKITTEN_EXECUTABLE=$(BUILT_BUNDLE)/Contents/MacOS/GithubCLI

FRAMEWORKS_FOLDER=/Library/Frameworks
BINARIES_FOLDER=/usr/local/bin

OUTPUT_PACKAGE=GithubCLI.pkg

VERSION_STRING=$(shell agvtool what-marketing-version -terse1)
COMPONENTS_PLIST=GithubCLI/Components.plist

.PHONY: all bootstrap clean install package test uninstall delete carthage

all: bootstrap
	$(BUILD_TOOL) $(XCODEFLAGS) build -verbose

carthage:
	carthage update

bootstrap:
	script/bootstrap

test: clean bootstrap
	$(BUILD_TOOL) $(XCODEFLAGS) test

clean:
	rm -f "$(OUTPUT_PACKAGE)"
	rm -rf "$(TEMPORARY_FOLDER)"
	$(BUILD_TOOL) $(XCODEFLAGS) clean

delete:
	rm -rf ~/Library/Developer/Xcode/DerivedData

install: package
	sudo installer -pkg GithubCLI.pkg -target /

uninstall: delete
	sudo rm -rf "$(FRAMEWORKS_FOLDER)/GithubCLIKit.framework"
	sudo rm -f "$(BINARIES_FOLDER)/github"

installables: clean bootstrap
	$(BUILD_TOOL) $(XCODEFLAGS) install

	mkdir -p "$(TEMPORARY_FOLDER)$(FRAMEWORKS_FOLDER)" "$(TEMPORARY_FOLDER)$(BINARIES_FOLDER)"
	mv -f "$(SOURCEKITTEN_FRAMEWORK_BUNDLE)" "$(TEMPORARY_FOLDER)$(FRAMEWORKS_FOLDER)/GithubCLIKit.framework"
	mv -f "$(SOURCEKITTEN_EXECUTABLE)" "$(TEMPORARY_FOLDER)$(BINARIES_FOLDER)/github"
	rm -rf "$(BUILT_BUNDLE)"

prefix_install: installables
	mkdir -p "$(PREFIX)/Frameworks" "$(PREFIX)/bin"
	cp -rf "$(TEMPORARY_FOLDER)$(FRAMEWORKS_FOLDER)/GithubCLIKit.framework" "$(PREFIX)/Frameworks/"
	cp -f "$(TEMPORARY_FOLDER)$(BINARIES_FOLDER)/github" "$(PREFIX)/bin/"
	install_name_tool -add_rpath "@executable_path/../Frameworks" "$(PREFIX)/bin/github"
	install_name_tool -add_rpath "@executable_path/../Frameworks/GithubCLIKit.framework/Versions/Current/Frameworks/" "$(PREFIX)/bin/github"

package: installables
	pkgbuild \
		--component-plist "$(COMPONENTS_PLIST)" \
		--identifier "com.yusuke.GithubCLI" \
		--install-location "/" \
		--root "$(TEMPORARY_FOLDER)" \
		--version "$(VERSION_STRING)" \
		"$(OUTPUT_PACKAGE)"

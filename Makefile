XCODEFLAGS=-workspace 'CommandlineTool.xcworkspace' -scheme 'commandlinetool'
BUILT_BUNDLE=/tmp/CommandlineTool.dst/Applications/commandlinetool.app

FRAMEWORKS_FOLDER=/Library/Frameworks
BINARIES_FOLDER=/usr/local/bin

all: bootstrap
	xcodebuild $(XCODEFLAGS) build

bootstrap:
	script/bootstrap

clean:
	xcodebuild $(XCODEFLAGS) clean

install: bootstrap
	xcodebuild $(XCODEFLAGS) install

	mkdir -p "$(FRAMEWORKS_FOLDER)"
	rm -rf "$(FRAMEWORKS_FOLDER)/CommandlineToolKit.framework"
	cp -PR "$(BUILT_BUNDLE)/Contents/Frameworks/CommandlineToolKit.framework" "$(FRAMEWORKS_FOLDER)/"

	install -d "$(BINARIES_FOLDER)"
	install -CSs "$(BUILT_BUNDLE)/Contents/MacOS/commandlinetool" "$(BINARIES_FOLDER)/"

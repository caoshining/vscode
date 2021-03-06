#!/usr/bin/env bash

# remove pkg from archive
zip -d ../VSCode-darwin.zip "*.pkg"

# publish the build
PACKAGEJSON=`ls ../VSCode-darwin/*.app/Contents/Resources/app/package.json`
VERSION=`node -p "require(\"$PACKAGEJSON\").version"`
node build/azure-pipelines/common/publish.js \
	"$VSCODE_QUALITY" \
	darwin \
	archive \
	"VSCode-darwin-$VSCODE_QUALITY.zip" \
	$VERSION \
	true \
	../VSCode-darwin.zip

# publish hockeyapp symbols
node build/azure-pipelines/common/symbols.js "$VSCODE_MIXIN_PASSWORD" "$VSCODE_HOCKEYAPP_TOKEN" "$VSCODE_ARCH" "$VSCODE_HOCKEYAPP_ID_MACOS"

# upload configuration
yarn gulp upload-vscode-configuration

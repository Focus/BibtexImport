#!/bin/bash
VERSION="1.0.0"
./scripts/compile.sh
npm install --production
electron-packager ./ BibtexImport --platform=darwin --arch=x64 --version=0.36.0 --icon=./icons/icon.icns --overwrite --out=./bins/ --app-version=$VERSION --ignore="(LICENCE|src|README.md|icons/|support/|bins/|scripts/)"
cd $STARTDIR

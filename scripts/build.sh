#!/bin/bash
VERSION=$(grep version ./package.json | cut -d '"' -f4)
./scripts/compile.sh
npm install --production
electron-packager ./ BibtexImport --all --version=0.36.0 --icon=./icons/icon.icns --overwrite --out=./bins/ --app-version=$VERSION --ignore="(LICENCE|src|README.md|icons/|support/|bins/|scripts/|dist/)"

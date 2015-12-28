#!/bin/bash
rm -R lib/
mkdir -p lib/
coffee --compile --output lib/ src/
cp src/pages/* lib/

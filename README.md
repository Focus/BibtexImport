# [Bibtex Import](http://focus.github.io/BibtexImport/)

*Bibtex Import* is an app that lets users get Bibtex references from [MathSciNet](http://www.ams.org/mathscinet/index.html).

**You need a MathSciNet subscription or access in order to use this software**

It is written in [CoffeeScript](http://coffeescript.org) and built using [Electron](http://electron.atom.io) and [Node.js](https://nodejs.org/).

Installation
==========

### Installing from binary

Binaries files are available on the [website](http://focus.github.io/BibtexImport/). For older versions or other operating systems than your own, [click here](http://github.com/Focus/BibtexImport/releases).

### Build from source

To build from source you will need to first install [Node.js](https://nodejs.org/) and [git](https://git-scm.com). First check out the repository using
```
git clone https://github.com/Focus/BibtexImport.git
```
then to compile and build use
```
cd ./BibtexImport
npm install
npm start
```

Features
========

- Search MathSciNet by author and title
- Quickly obtain references in bibtex format
- Easy to use interface
- Automatically obtain remote access from MathSciNet

Usage
=====

Enter the author and title in the fields. You can also use wildcards and boolean operators, see [here](http://www.ams.org/mathscinet/help/full_search_help_full.html) for details. You may also leave one of the fields empty.

Press search or hit ENTER. The results of the search will appear on the table. You can click on an entry to select it, you can also use `Edit>Select All` to toggle selecting all the entries. Next use `Edit>Copy` to copy the selected bibtex entries to clipboard. You can paste these into an editor.

![Example usage](./support/usage.gif)

Todo
====
- [x] Include support for [remote access](http://www.ams.org/publications/remoteaccess)
- [ ] Set up auto-updates

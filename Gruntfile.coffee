module.exports = (grunt)->
  grunt.initConfig {
    pkg: grunt.file.readJSON "package.json"
    coffee: {
      glob_to_multiple: {
        expand: true,
        flatten: true,
        cwd: 'src/',
        src: ['*.coffee'],
        dest: 'lib/',
        ext: '.js'
      }
    }
    copy: {
      pages: {
        expand: true
        cwd: 'src/pages/'
        src: '**'
        dest: 'lib/'
      }
    }
    electron:{
      all:{
        options:{
          name: "<%= pkg.productName %>"
          dir: './'
          out: 'bins/'
          version: '0.36.0'
          all: true
          icon: './icons/icon.icns'
          overwrite: true
          'app-version': "<%= pkg.version %>"
          ignore: "<%= grunt.option(\"excludes\") %>"
        }
      }
      osx:{
        options:{
          name: "<%= pkg.productName %>"
          dir: './'
          out: 'bins/'
          version: '0.36.0'
          platform: 'darwin'
          arch: 'x64'
          icon: './icons/icon.icns'
          overwrite: true
          'app-version': "<%= pkg.version %>"
          ignore: "<%= grunt.option(\"excludes\") %>"
        }
      }
    }
    'electron-builder':{
      osx: {
        options: {
          appPath: '<%= process.cwd() %>/bins/<%= pkg.productName %>-darwin-x64/<%= pkg.productName %>.app'
          platform: 'osx'
          out: 'dist/osx64/'
          config: 'support/installer.json'
        }
      }
      win32: {
        options: {
          appPath: '<%= process.cwd() %>/bins/<%= pkg.productName %>-win32-ia32/'
          platform: 'win'
          out: 'dist/win32/'
          config: 'support/installer.json'
        }
      }
      win64: {
        options: {
          appPath: '<%= process.cwd() %>/bins/<%= pkg.productName %>-win32-x64/'
          platform: 'win'
          out: 'dist/win64/'
          config: 'support/installer.json'
        }
      }
    }
    'electron-debian-installer':{
      options:{
        productName: '<%= pkg.productName %>'
        productDescription: '<%= pkg.description %>'
        rename: (dest, src)->
          return dest + '<%= name %>_<%= version %>-<%= revision %>_<%= arch %>.deb'
      }
      linux32:{
        options:{
          arch: 'i386'
        }
        src: 'bins/Bibtex Import-linux-ia32'
        dest: 'dist/linux32/'
      }
      linux64:{
        options:{
          arch: 'amd64'
        }
        src: 'bins/Bibtex Import-linux-x64'
        dest: 'dist/linux64/'
      }
    }
  }

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-electron'
  grunt.loadNpmTasks 'grunt-electron-builder-wrapper'
  grunt.loadNpmTasks 'grunt-electron-debian-installer'

  grunt.registerTask "default", ["coffee","copy:pages"]
  grunt.registerTask "build", ["default", "excludes", "electron"]
  grunt.registerTask "build:osx", ["default", "excludes", "electron:osx"]
  grunt.registerTask "package", ["electron-builder", "electron-debian-installer"]
  grunt.registerTask "package:osx", ["electron-builder:osx"]
  grunt.registerTask "excludes", ->
    pjson = grunt.file.readJSON "package.json"
    exclude = "(Gruntfile\.coffee|LICENCE|^\/src|README.md|^\/icons|^\/support|^\/bins|^\/dist"
    for dep in Object.keys(pjson.devDependencies)
      exclude += "|node_modules/" + dep
    exclude += ")"
    grunt.option "excludes", exclude

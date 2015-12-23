gulp     = require 'gulp'
install  = require 'gulp-install'
sass     = require 'gulp-sass'
cssnext  = require 'gulp-cssnext'
coffee   = require 'gulp-coffee'
ignore   = require 'gulp-ignore'
rimraf   = require 'gulp-rimraf'
symdest  = require 'gulp-symdest'
# electron = require 'gulp-atom-electron'
electron = require 'gulp-electron'
exec     = require('child_process').exec

packageJson = require('./src/package.json');


gulp.task 'install:npm', () ->
  gulp.src ['./package.json', './src/package.json']
    .pipe install()

gulp.task 'compile:sass', () ->
  gulp.src './src/style/**/*.scss'
    .pipe sass()
    .on 'error', (err) ->
      console.log err.message
    .pipe cssnext()
    .pipe gulp.dest('src/style/')

gulp.task 'compile:coffee', () ->
  gulp.src './src/**/*.coffee'
    .pipe coffee()
    .pipe gulp.dest('src/')

gulp.task 'compile', ['compile:sass', 'compile:coffee']


gulp.task 'clean', ()->
  return gulp.src([
      './src/style/main.css',
      './src/compat.js',
      './src/error.js',
      './src/main.js',
      './src/test.js',
      './**/.DS_Store'
      './release/'
    ], { read: false }) # much faster
    .pipe ignore('node_modules/**')
    .pipe ignore('src/node_modules/**')
    .pipe rimraf()

gulp.task 'run', ['compile:sass', 'compile:coffee'], (callback) ->
  exec 'electron ./src', (err, stdout, stderr) ->
    console.log(stdout);
    console.log(stderr);
    callback(err);

gulp.task 'build', ['clean', 'compile'], ()->
  gulp.src './src/**'
    .pipe electron({
      src: './src',
      packageJson: packageJson,
      release: './release',
      cache: './cache',
      version: 'v0.36.1',
      packaging: true,
      platforms: ['darwin-x64'],
      platformResources: {
        darwin: {
          CFBundleDisplayName: packageJson.name,
          CFBundleIdentifier: packageJson.name,
          CFBundleName: packageJson.name,
          CFBundleVersion: packageJson.version,
          # icon: 'gulp-electron.icns'
        },
      }
    })
    .pipe symdest('app')

gulp.task 'watch', () ->
  gulp.watch './src/style/*.scss', ['compile:sass']
  gulp.watch './src/**/*.coffee',  ['compile:coffee']

gulp.task 'default', ['compile:sass', 'compile:coffee', 'watch']

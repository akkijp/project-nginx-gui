gulp    = require 'gulp'
install = require 'gulp-install'
sass    = require 'gulp-sass'
cssnext = require 'gulp-cssnext'
coffee  = require 'gulp-coffee'
exec    = require('child_process').exec;


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


gulp.task 'run', ['compile:sass', 'compile:coffee'], (callback) ->
  exec 'electron ./src', (err, stdout, stderr) ->
    console.log(stdout);
    console.log(stderr);
    callback(err);

gulp.task 'watch', () ->
  gulp.watch './src/style/*.scss', ['compile:sass']
  gulp.watch './src/**/*.coffee',  ['compile:coffee']

gulp.task 'default', ['compile:sass', 'compile:coffee', 'watch']

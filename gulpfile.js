var gulp    = require("gulp"),
    install = require("gulp-install"),
    sass    = require('gulp-sass'),
    cssnext = require('gulp-cssnext');

gulp.task('install', function(){
  return gulp.src(['./package.json', './src/package.json'])
  .pipe(install());
});

gulp.task('sass', function() {
  return gulp.src('src/style/**/*.scss')
    .pipe(sass())
    .on('error', function(err) {
      console.log(err.message);
    })
    .pipe(cssnext())
    .pipe(gulp.dest('src/style/'))
});


gulp.task('watch', function(){
    gulp.watch('./src/style/*.scss', ['sass']);
});

gulp.task('default', ['watch']);

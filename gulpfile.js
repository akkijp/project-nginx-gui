var gulp    = require("gulp");
var install = require("gulp-install");

gulp.task('install', function(){
  gulp.src(['./package.json', './src/package.json'])
  .pipe(install());
});

gulp.task('default', ['install']);

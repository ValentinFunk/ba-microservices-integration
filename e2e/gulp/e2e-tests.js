'use strict';

var gulp = require('gulp');

var $ = require('gulp-load-plugins')();

module.exports = function(options) {
  // Downloads the selenium webdriver
  gulp.task('webdriver-update', $.protractor.webdriver_update);

  gulp.task('webdriver-standalone', $.protractor.webdriver_standalone);

  function runProtractor (done) {
    gulp.src(options.e2e + '/**/*.js')
      .pipe($.protractor.protractor({
        configFile: 'protractor.conf.js'
      }))
      .on('error', function (err) {
        // Make sure failed tests cause gulp to exit non-zero
        throw err;
      })
      .on('end', function () {
        done();
      });
  }

  gulp.task('protractor', ['webdriver-update'], runProtractor);
};
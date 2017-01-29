// Gulp streaming build system configuration file
'use strict'	// no sloppy code / syntax allowed

var gulp		= require('gulp');									// main gulp module
var less		= require('gulp-less');								// gulp plugin for less compiler
var APPlugin	= require('less-plugin-autoprefix');				// less plugin for automatic vendor-specific css prefixes
var autoprefix	= new APPlugin({ browsers: ['last 2 versions'] });	// instance of the autoprefix plugin
var path		= require('path');									// handling and transforming file paths
var watch		= require('gulp-watch');							// watch files and fire tasks when needed
var cssmin      = require('gulp-cssmin');                           // minify css sheets
var rename      = require('gulp-rename');                           // rename files going through gulp streams
var plumber     = require('gulp-plumber');                          // Prevent gulp stream from breaking on errors


// Helper variables and functions
var app			= __dirname;
// custom function for handling errors in gulp-less
function onError(err) {
	console.log(err);
	this.emit('end');
}

// Less compilation task + autoprefixer
gulp.task('less', function() {
	return gulp.src(path.join(app, 'less', 'main.less'))
	.pipe(less({
		paths: 			[ path.join(app, 'less', 'main.less') ],
		plugins:		[ autoprefix ]
	}))
	.on('error', onError)
    .pipe(cssmin())
    .pipe(rename({suffix: '.min'}))
	.pipe(gulp.dest(path.join(app, 'www', 'css')));
});

// Gulp watcher
gulp.task('watch', function() {
	gulp.watch(path.join(app, 'less/**/*.less'), function() {
		gulp.start('less')
	});
});

// Gulp default task
gulp.task('default', ['less']);

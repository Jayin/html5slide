fs = require 'fs'
path = require 'path'
crypto = require 'crypto'

_ = require 'lodash'
through = require 'through2'
gulp = require 'gulp'
karma = require 'gulp-karma'
less = require 'gulp-less'
sass = require 'gulp-sass'
postcss = require 'postcss'
gulpPostcss = require 'gulp-postcss'
postcssImport = require 'postcss-import'
autoprefixer = require 'autoprefixer-core'
concat = require 'gulp-concat'
amdBundler = require 'gulp-amd-bundler'
htmlOptimizer = require 'gulp-html-optimizer'
propertyMerge = require 'gulp-property-merge'
digestVersioning = require 'gulp-digest-versioning'
trace = require 'gulp-trace'
minify = require 'gulp-minifier'
backtrace = require 'gulp-backtrace'
sus = require 'gulp-sus'
argv = require('minimist') process.argv.slice(2)

BUILD_CONTEXT = process.env.BUILD_CONTEXT || 'static'
if BUILD_CONTEXT is 'NONE'
	BUILD_CONTEXT = ''
BUILD_TARGET = process.env.BUILD_TARGET || 'default'
DEST_BASES = 
	default: './dist/' + (BUILD_CONTEXT || 'root')
	prototype: './dist/prototype/' + (BUILD_CONTEXT || 'root')

destBase = DEST_BASES[BUILD_TARGET] || DEST_BASES.default
properties = require "./properties.#{BUILD_TARGET}"
properties.cdnContext = "'#{BUILD_CONTEXT}'"
md5map = {}

if argv.properties
	_.extend properties, JSON.parse(argv.properties)

minifyDefault = ->
	minify
		minify: argv.minify
		collapseWhitespace: true
		conservativeCollapse: true
		removeComments: true
		minifyJS: true
		minifyCSS: true

gulp.task 'copy', ->
	gulp.src('src/**/*.+(jpg|jpeg|gif|png|otf|eot|svg|ttf|woff|ico|mp3)')
		.pipe gulp.dest(destBase)
	gulp.src('src/script/lib/react/react-0.13.1.js')
		.pipe minifyDefault()
		.pipe gulp.dest(destBase + '/script/lib/react')
	if BUILD_TARGET is 'prototype'
		gulp.src('src/mockup-data/**/*.json')
			.pipe gulp.dest(destBase + '/mockup-data')

gulp.task 'less', ->
	gulp.src(['src/**/main.less', 'src/**/*-main.less'])
		.pipe less()
		.pipe sus
			baseSurfix: false
		.pipe digestVersioning
			digestLength: 8
			basePath: destBase
		.pipe minifyDefault()
		.pipe gulp.dest(destBase)

gulp.task 'sass', ->
	gulp.src(['src/**/main.scss', 'src/**/*-main.scss'])
		.pipe sass()
		.pipe sus
			baseSurfix: false
		.pipe digestVersioning
			digestLength: 8
			basePath: destBase
		.pipe minifyDefault()
		.pipe gulp.dest(destBase)

gulp.task 'postcss', ->
	gulp.src(['src/**/main.css', 'src/**/*-main.css'])
		.pipe gulpPostcss [
			postcssImport()
			autoprefixer browsers: ['last 2 version']
		]
		.pipe sus
			baseSurfix: false
		.pipe digestVersioning
			digestLength: 8
			basePath: destBase
		.pipe minifyDefault()
		.pipe gulp.dest(destBase)

gulp.task 'concat', ->
	gulp.src([
			'src/script/config/require-config.js'
			'src/script/lib/yom/require/require-lite.js'
		])
		.pipe trace()
		.pipe concat('require-lite.js')
		.pipe minifyDefault()
		.pipe gulp.dest(destBase + '/script/lib/yom')
	gulp.src([
			'src/script/lib/fastclick/fastclick.js'
		])
		.pipe trace()
		.pipe concat('fastclick.js')
		.pipe minifyDefault()
		.pipe gulp.dest(destBase + '/script/lib/fastclick')
	gulp.src([
			'src/script/lib/zepto-1.1.4/zepto.js'
			'src/script/lib/zepto-1.1.4/ajax.js'
			'src/script/lib/zepto-1.1.4/assets.js'
			'src/script/lib/zepto-1.1.4/callbacks.js'
			'src/script/lib/zepto-1.1.4/data.js'
			'src/script/lib/zepto-1.1.4/deferred.js'
			'src/script/lib/zepto-1.1.4/detect.js'
			'src/script/lib/zepto-1.1.4/event.js'
			'src/script/lib/zepto-1.1.4/form.js'
			'src/script/lib/zepto-1.1.4/fx.js'
			'src/script/lib/zepto-1.1.4/fx_methods.js'
			'src/script/lib/zepto-1.1.4/gesture.js'
			'src/script/lib/zepto-1.1.4/ie.js'
			#'src/script/lib/zepto-1.1.4/ios3.js'
			'src/script/lib/zepto-1.1.4/selector.js'
			'src/script/lib/zepto-1.1.4/stack.js'
			#'src/script/lib/zepto-1.1.4/touch.js'
		])
		.pipe trace()
		.pipe concat('main.js')
		.pipe minifyDefault()
		.pipe gulp.dest(destBase + '/script/lib/zepto-1.1.4')

gulp.task 'amd-bundle', ->
	gulp.src([
			'src/**/main.js'
			'src/**/*-main.js'
			'src/**/main.coffee'
			'src/**/*-main.coffee'
			'src/**/main.tpl.html'
			'src/**/*-main.tpl.html'
		]).pipe amdBundler
			generateDataUri: true
			beautifyTemplate: true
			trace: true
			postcss: (file) ->
				res = postcss()
					.use postcssImport()
					.use autoprefixer browsers: ['last 2 version']
					.process file.contents.toString(),
						from: file.path
				res.css
		.pipe propertyMerge
			properties: properties
		.pipe minifyDefault()
		.pipe gulp.dest(destBase)
	gulp.src([
			'bower_components/skateboard/src/main.coffee'
		]).pipe amdBundler()
		.pipe minifyDefault()
		.pipe gulp.dest(destBase + '/script/lib/skateboard')

gulp.task 'gen-md5map', ['copy', 'less', 'sass', 'postcss', 'concat', 'amd-bundle'], ->
	gulp.src([
			destBase + '/script/**/main.js'
			destBase + '/script/**/*-main.js'
			destBase + '/app/**/main.js'
			destBase + '/app/**/*-main.js'
		]).pipe through.obj (file, enc, next) ->
			if (/\/app\/([^\/]+)\//).test file.path
				map = md5map[RegExp.$1] ?= {}
			else
				map = md5map['app'] ?= {}
			md5 = crypto.createHash('md5')
				.update(fs.readFileSync(file.path))
				.digest('hex')
			md5 = md5.substr 0, 8
			map[file.path.replace file.base, ''] = md5
			next()

gulp.task 'html-optimize', ['gen-md5map'], ->
	getFilePath = (fileName, baseFilePath) ->
		fileName = fileName.replace /'[^']+'/g, ''
		destBase + '/' + fileName.replace(new RegExp('^\\/' + BUILD_CONTEXT + '\\/'), '')
	properties.md5map = md5map
	gulp.src(['src/**/*.src.html'])
		.pipe htmlOptimizer
			requireBaseDir: 'src/script'
			beautifyTemplate: true
			generateDataUri: true
			trace: true
			postcss: (file) ->
				res = postcss()
					.use postcssImport()
					.use autoprefixer browsers: ['last 2 version']
					.process file.contents.toString(),
						from: file.path
				res.css
		.pipe propertyMerge
			properties: properties
		.pipe digestVersioning
			digestLength: 8
			basePath: destBase
			getFilePath: getFilePath
		.pipe minifyDefault()
		.pipe gulp.dest(destBase)

gulp.task 'copy-test', ->
	gulp.src('src/test/**/*.js')
		.pipe gulp.dest(destBase + '/test')
	gulp.src('scr/script/lib/yom/require/require.js')
		.pipe gulp.dest(destBase + '/test/inc')

gulp.task 'test', ['copy-test'], ->
	stream = through.obj()
	karmaStream = stream.pipe karma
			configFile: 'karma.conf.js'
			port: 9877
			singleRun: true
			browsers: ['PhantomJS']
		.on 'error', (err) ->
			throw err
	stream.end()
	karmaStream

gulp.task 'fix-less-trace', ->
	path = require 'path'
	gulp.src('src/**/*.less')
		.pipe through.obj (file, enc, next) ->
			content = file.contents.toString().replace(/^\/\*\s*trace:[^*]+\*\/(\r\n|\n)*/, '')
			trace = '/* trace:' + path.relative(file.cwd, file.path) + ' */'
			file.contents = new Buffer trace + '\n' + content
			@push file
			next()
		.pipe gulp.dest('src')

gulp.task 'build', ['copy', 'less', 'sass', 'postcss', 'concat', 'amd-bundle', 'html-optimize']
gulp.task 'default', ['build']

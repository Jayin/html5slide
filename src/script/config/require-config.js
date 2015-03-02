var require = require || {
	debug: true,
	baseUrl: G.CDN_ORIGIN + '/static/script',
	paths: {
		'async': 'lib/async/main',
		'zepto': 'lib/zepto-1.1.4/main',
		'jquery': 'lib/jquery-2.1.3/main',
		'parallax': 'lib/parallax/main',
		'iscroll': 'lib/iscroll/main',
		'turn': 'lib/turn/main',
		'app': 'lib/app/main'
	},
	shim: {
		'async': {
			exports: 'async'
		},
		'zepto': {
			exports: 'Zepto'
		},
		'jquery': {
			exports: 'jQuery'
		},
		'parallax': {
			exports: 'Zepto.fn.parallax',
			deps: ['zepto']
		},
		'iscroll': {
			exports: 'iScroll'
		},
		'turn': {
			exports: 'jQuery.fn.turn',
			deps: ['jquery']
		}
	},
	resolveUrl: function(url) {
		var baseUrl = G.CDN_ORIGIN + '/static/script/';
		if(url.indexOf(baseUrl) === 0) {
			var path = url.replace(baseUrl, '');
			var md5 = G.MD5_MAP[path];
			if(md5) {
				if(url.indexOf('?') > 0) {
					return url + '&v=' + md5;
				} else {
					return url + '?v=' + md5;
				}
			} else {
				return url;
			}
		} else {
			return url;
		}
	},
	onLoadStart: function() {
	},
	onLoadEnd: function() {
	},
	errCallback: function() {
	}
};
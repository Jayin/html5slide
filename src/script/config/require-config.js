var require = require || {
	debug: true,
	baseUrl: G.CDN_ORIGIN + '/static/script',
	paths: {
		'async': 'lib/async/main',
		'zepto': 'lib/jquery-2.1.3/main',
		'jquery': 'lib/jquery-2.1.3/main',
		'app': 'lib/app/main',
		'skateboard': 'lib/skateboard/main',
		'parallax': 'lib/parallax/main',
		'iscroll': 'lib/iscroll/main',
		'turn': 'lib/turn/main',
		'mega-pix-image': 'lib/mega-pix-image/main',
		'exif': 'lib/exif/main',
		'hammer': 'lib/hammer/main',
		'fabric': 'lib/fabric/main'
	},
	shim: {
		'async': {
			exports: 'async'
		},
		'zepto': {
			exports: 'jQuery'
		},
		'jquery': {
			exports: 'jQuery'
		},
		'parallax': {
			exports: 'jQuery.fn.parallax',
			deps: ['jquery']
		},
		'iscroll': {
			exports: 'iScroll'
		},
		'turn': {
			exports: 'jQuery.fn.turn',
			deps: ['jquery']
		},
		'mega-pixel-image': {
			exports: 'MegaPixImage'
		},
		'fabric': {
			exports: 'fabric'
		}
	},
	resolveUrl: function(url) {
		var baseUrl;
		if(url.indexOf('/static/app/') > 0) {
			baseUrl = G.CDN_ORIGIN + '/static/app/';
		} else {
			baseUrl = G.CDN_ORIGIN + '/static/script/';
		}
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
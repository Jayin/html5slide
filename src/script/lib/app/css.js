define(function(require) {
	var $ = require('jquery');
	
	var _linkCount = 0;
	var _hrefIdMap = {};
	
	function load(href, force) {
		var id, el;
		if($.isArray(href)) {
			id = [];
			$.each(href, function(i, item) {
				id.push(load(item, force));
			});
			return id;
		} else if(!(/^https?:|^\//).test(href)) {
			href = G.CDN_ORIGIN + href;
		}
		id = _hrefIdMap[href];
		el = $('#' + id)[0];
		if(id && el) {
			if(force) {
				unload(href);
			} else {
				return id;
			}
		}
		id = 'app-css-link-' + _linkCount++;
		el = $('<link id="' + id + '" rel="stylesheet" type="text/css" media="screen" href="' + href + '" />');
		$($(document.head || 'head').children()[0]).before(el);
		return _hrefIdMap[href] = id;
	};
	
	function unload(href) {
		var el;
		if($.isArray(href)) {
			el = [];
			$.each(href, function(i, item) {
				el.push(unload(item));
			});
			return el;
		} else if(!(/^https?:|^\//).test(href)) {
			href = G.CDN_ORIGIN + href;
		}
		el = $('#' + _hrefIdMap[href])[0];
		if(el) {
			delete _hrefIdMap[href];
			return el.parentNode.removeChild(el);
		}
		return null;
	};

	return {
		load: load,
		unload: unload
	};
});

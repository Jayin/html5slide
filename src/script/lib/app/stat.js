define(function(require) {
	var $ = require('jquery');
	var ajax = require('./ajax');

	var _senderCount = 0;

	var stat = {};

	function _send(url) {
		var id = 0;
		var pool = window.app_stat_sender_pool = window.app_stat_sender_pool || [];
		while (pool[id]) {
			id++;
		}
		var sender = pool[id] = new Image();
		var cb = sender.onload = sender.onerror = function() {
			sender.onload = sender.onerror = null;
			pool[id] = null;
		};
		sender.src = url;
	}

	stat.pv = function(url, cid, mid) {
		url = encodeURIComponent(url || location.href);
		url = ajax.getDataTypeUrl('tracking/open/trace/' + cid + '?action=onload&event=' + url + (mid ? '&mid=' + mid : ''), 'json');
		_send(url);
	};

	//fv => first view， 跟pv几乎一样，只是event变为firstview
	stat.fv = function(url, cid, mid) {
		url = 'firstview';
		url = ajax.getDataTypeUrl('tracking/open/trace/' + cid + '?action=onload&event=' + url + (mid ? '&mid=' + mid : ''), 'json');
		_send(url);
	};
	//统计用户UA
	stat.ua = function(cid, mid) {
		var url = encodeURIComponent(navigator.userAgent);
		url = ajax.getDataTypeUrl('tracking/open/trace/' + cid + '?action=record&event=' + url + (mid ? '&mid=' + mid : ''), 'json');
		_send(url);
	};

	stat.click = function(tag, cid, mid) {
		url = ajax.getDataTypeUrl('tracking/open/trace/' + cid + '?action=click&event=' + tag + (mid ? '&mid=' + mid : ''), 'json');
		_send(url);
	};

	$(document).on('click', '[data-click-tag]', function(evt) {
		tag = $(this).data('click-tag');
		if (tag) {
			tag = tag.split('.');
			stat.click(tag[0], tag[1], tag[2]);
		}
	});

	return stat;
});

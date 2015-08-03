define(function(require) {
	var $ = require('jquery');
	var config = require('./config');
	var alerts = require('./alerts');
	var util = require('./util');
	var cookie = require('./cookie');

	var _postQueue = {};
	var _getQueue = {};
	var _proxyQueue = [];

	var ajax = {};

	/**
	 * returns the full url according to backend service name and data type
	 * @private
	 * @param {String} url
	 * @param {String} dataType
	 * @returns {String} the full url
	 */
	ajax.getDataTypeUrl = function(url, dataType) {
		var fullUrl, params;
		if(!(/^(https?:|\/\/)/).test(url)) {
			url = url.replace(/^\/+/, '');
			fullUrl = G.CGI_ORIGIN +  '/' + url;
			params = util.getUrlParams(util.url2obj(fullUrl));
			if(G.IS_PROTOTYPE) {
				if(params.m && params.c && params.a) {
					fullUrl = G.CGI_ORIGIN + '/static/mockup-data/' + [params.m, params.c, params.a].join('/');
				} else {
					fullUrl = G.CGI_ORIGIN + '/static/mockup-data/' + url;
				}
			}
			fullUrl = fullUrl.replace(/[^\/]+$/, function(m) {
				return m.replace(/^[\w\-\.]+/, function(m) {
					return m.split('.')[0] + '.' + dataType;
				});
			});
		} else {
			fullUrl = url;
		}
		if(G.csrfToken && fullUrl.indexOf('csrf_token=') === -1) {
			fullUrl = util.appendQueryString(fullUrl, {csrf_token: G.csrfToken});
		}
		return fullUrl;
	};

	/**
	 * show the loading icon
	 */
	ajax.showLoading = function() {
		$('#circleG').show();
	};

	/**
	 * hide the loading icon
	 */
	ajax.hideLoading = function() {
		$('#circleG').hide();
	};

	/**
	 * take action to some common code
	 * @param {Number} code
	 * @returns {Boolean} whether common code has been dealt
	 */
	ajax.dealCommonCode = function(code) {
		var res = true;
		if(code === config.RES_CODE.NEED_LOGIN && !(/\/login\/login\-/).test(location.pathname)) {
			//TODO
		} else {
			res = false;
		}
		return res;
	};

	/**
	 * ajax get wrapper for jquery ajax
	 * @param {Object} opt
	 */
	ajax.get = function(opt) {
		var xhrObj, success;
		opt = opt || {};
		opt.type = opt._method = 'GET';
		opt.headers = opt.headers || {};
		opt.headers['X-Requested-With'] = 'XMLHttpRequest';
		success = opt.success;
		opt.success = function(res, textStatus, xhrObj) {
			if((opt.noDealCommonCode || !ajax.dealCommonCode(res.code)) && success) {
				success(res, textStatus, xhrObj);
			}
		}
		opt.url = ajax.getDataTypeUrl(opt.url, 'json');
		opt.dataType = 'json';
		if(opt.queueName) {
			if(_getQueue[opt.queueName]) {
				return;
			}
			_getQueue[opt.queueName] = true;
		}
		// opt.xhrFields = {
		// 	withCredentials: true
		// };
		xhrObj = $.ajax(opt);
		opt.loading === false || ajax.showLoading();
		xhrObj.always(function() {
			if(opt.queueName) {
				_getQueue[opt.queueName] = false;
			};
			opt.loading === false || ajax.hideLoading();
		});
		return xhrObj;
	};

	/**
	 * ajax post wrapper for jquery ajax
	 * @param {Object} opt
	 */
	ajax.post = function(opt) {
		var xhrObj, success, data;
		opt = opt || {};
		opt.type = opt._method = opt._method || 'POST';
		opt.dataType = 'json';
		opt.url = ajax.getDataTypeUrl(opt.url, opt.dataType);
		data = opt.data;
		opt.charset = opt.charset || 'UTF-8';
		opt.headers = opt.headers || {};
		opt.headers['X-Requested-With'] = 'XMLHttpRequest';
		if(!opt.notJsonParamData) {
			opt.contentType = 'application/json; charset=' + opt.charset;
			opt.data = typeof data == 'string' ? data : data == null ? data : JSON.stringify(data);
		}
		success = opt.success;
		opt.success = function(res, textStatus, xhrObj) {
			if((opt.noDealCommonCode || !ajax.dealCommonCode(res.code)) && success) {
				success(res, textStatus, xhrObj);
			}
		}
		if(opt.queueName) {
			if(_postQueue[opt.queueName]) {
				return;
			}
			_postQueue[opt.queueName] = true;
		}
		//for prototype
		if(G.IS_PROTOTYPE) {
			opt.type = 'POST';
			opt.url = util.appendQueryString(opt.url, {_method: (opt._method || 'POST').toLowerCase()});
		}
		// opt.xhrFields = {
		// 	withCredentials: true
		// };
		xhrObj = $.ajax(opt);
		opt.loading === false || ajax.showLoading();
		xhrObj.always(function() {
			if(opt.queueName) {
				_postQueue[opt.queueName] = false;
			};
			opt.loading === false || ajax.hideLoading();
		});
		return xhrObj;
	};

	/**
	 * ajax put wrapper for jquery ajax
	 * @param {Object} opt
	 */
	ajax.put = function(opt) {
		opt = opt || {};
		opt._method = 'PUT';
		ajax.post(opt);
	};

	/**
	 * ajax delete wrapper for jquery ajax
	 * @param {Object} opt
	 */
	ajax.del = function(opt) {
		opt = opt || {};
		opt._method = 'DELETE';
		ajax.post(opt);
	};

	/**
	 * get FileUploader options
	 * @param {String} url
	 * @param {String} dataType
	 */
	ajax.getUploadOpt = function(url, dataType, callback) {
		url = ajax.getDataTypeUrl(url, dataType);
		if(G.ORIGIN == G.CGI_ORIGIN) {
			callback({
				url: url
			});
		} else {
			callback({
				url: url,
				data: {domain: G.DOMAIN || ''},
				xhrGetter: function(getXhr) {
					var xhr = new XMLHttpRequest();
					getXhr(xhr);
				}
			});
		}
	};

	return ajax;
});

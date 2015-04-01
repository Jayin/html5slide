define(function(require) {
	var $ = require('jquery');
	
	var _uniqueIdCount = 0;
	
	var util = {};

	util.url2obj = function(str) {
		if(typeof str != 'string') {
			return str;
		}
		var m = str.match(/([^:]*:)?(?:\/\/)?([^\/:]+)?(:)?(\d+)?([^?#]+)(\?[^?#]*)?(#[^#]*)?/);
		m = m || [];
		uri = {
			href: str,
			protocol: m[1] || 'http:',
			host: (m[2] || '') + (m[3] || '') + (m[4] || ''),
			hostname: m[2] || '',
			port: m[4] || '',
			pathname: m[5] || '',
			search: m[6] || '',
			hash: m[7] || ''
		};
		uri.origin = uri.protocol + '//' + uri.host;
		return uri;
	};

	util.cloneObject = function(obj, deep, _level) {
		var res = obj;
		deep = deep || 0;
		_level = _level || 0;
		if(_level > deep) {
			return res;
		}
		if(typeof obj == 'object' && obj) {
			if($.isArray(obj)) {
				res = [];
				$.each(obj, function(i, item) {
					res.push(item);
				})
			} else {
				res = {};
				for(var p in obj) {
					if(Object.prototype.hasOwnProperty.call(obj, p)) {
						res[p] = deep ? util.cloneObject(obj[p], deep, ++_level) : obj[p];
					}
				}
			}
		}
		return res;
	};
	
	util.getUniqueId = function() {
		return 'APP_UNIQUE_ID_' + _uniqueIdCount++;
	};
	
	util.getOrigin = function(loc) {
		loc = loc || window.location;
		return loc.origin || [
			loc.protocol, '//', loc.host
		].join('');
	};

	util.getByteLength = function(str) {
		return str.replace(/[^\x00-\xff]/g, 'xx').length;
	};
	
	util.headByByte = function(str, len, postFix) {
		str = new String(str).toString();
		if(util.getByteLength(str) <= len) {
			return str;
		}
		postFix = postFix || '';
		var l;
		if(postFix) {
			l = len = len - util.getByteLength(postFix);
		} else {
			l = len;
		}
		do {
			str = str.slice(0, l--);
		} while(util.getByteLength(str) > len);
		return str + postFix;
	};
	
	util.encodeHtml = function(str) {
		return (str + '').replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/\x60/g, '&#96;').replace(/\x27/g, '&#39;').replace(/\x22/g, '&quot;');
	};
	
	util.decodeHtml = function(str) {
		return (str + '').replace(/&quot;/g, '\x22').replace(/&#0*39;/g, '\x27').replace(/&#0*96;/g, '\x60').replace(/&gt;/g, '>').replace(/&lt;/g, '<').replace(/&amp;/g, '&');
	};
	
	util.getUrlParam = function(name, loc) {
		loc = loc || window.location;
		var r = new RegExp('(\\?|#|&)' + name + '=(.*?)(&|#|$)');
		var m = (loc.href || '').match(r);
		return (m ? decodeURIComponent(m[2]) : '');
	};
	
	util.getUrlParams = function(loc) {
		loc = loc || window.location;
		var raw = loc.search, res = {}, p, i;
		if(raw) {
			raw = raw.slice(1);
			raw = raw.split('&');
			for(i = 0, l = raw.length; i < l; i++) {
				p = raw[i].split('=');
				res[p[0]] = decodeURIComponent(p[1] || '');
			}
		}
		raw = loc.hash;
		if(raw) {
			raw = raw.slice(1);
			raw = raw.split('&');
			for(i = 0, l = raw.length; i < l; i++) {
				p = raw[i].split('=');
				res[p[0]] = res[p[0]] || decodeURIComponent(p[1] || '');
			}
		}
		return res;
	};
	
	util.appendQueryString = function(url, param, isHashMode) {
		if(typeof param == 'object') {
			param = $.param(param, true);
		} else if(typeof param == 'string') {
			param = param.replace(/^&/, '');
		} else {
			param = '';
		}
		if(!param) {
			return url;
		}
		if(isHashMode) {
			if(url.indexOf('#') == -1) {
				url += '#' + param;
			} else {
				url += '&' + param;
			}
		} else {
			if(url.indexOf('#') == -1) {
				if(url.indexOf('?') == -1) {
					url += '?' + param;
				} else {
					url += '&' + param;
				}
			} else {
				var tmp = url.split('#');
				if(tmp[0].indexOf('?') == -1) {
					url = tmp[0] + '?' + param + '#' + (tmp[1] || '');
				} else {
					url = tmp[0] + '&' + param + '#' + (tmp[1] || '');
				}
			}
		}
		return url;
	};
	
	util.formatMsg = function(msg, data) {
		msg = msg + '';
		if(data) {
			$.each(data, function(key, val) {
				val = util.encodeHtml(val);
				msg = msg.replace(new RegExp('\\{\\{' + key + '\\}\\}', 'g'), val);
			});
		}
		return msg;
	};

	util.formatDecimal = function(decimal, format, opt) {
		function formatInteger(integer) {
			var res = [], count = 0;
			integer = integer.split('');
			while(integer.length) {
				if(count && !(count % 3)) {
					res.unshift(',');
				}
				res.unshift(integer.pop());
				count++;
			}
			return res.join('');
		};
		opt = opt || {};
		var res = '';
		var decimalMatchRes, formatMatchRes, fLen, dLen, tmp;
		decimal += '';
		decimalMatchRes = decimal.match(/^(\-?)(\w*)(.?)(\w*)/);
		formatMatchRes = format.match(/^(\-?)(\w*)(.?)(\w*)/);
		if(formatMatchRes[2]) {
			res += decimalMatchRes[2];
		}
		if(formatMatchRes[3] && formatMatchRes[4]) {
			res += formatMatchRes[3];
		} else {
			if(opt.round) {
				res = Math.round(decimal) + '';
			} else if(opt.ceil) {
				res = Math.ceil(decimal) + '';
			}
			res = formatInteger(res);
			return res;
		}
		fLen = Math.min(formatMatchRes[4].length, 4);
		dLen = decimalMatchRes[4].length;
		res += decimalMatchRes[4].slice(0, fLen);
		if(fLen > dLen) {
			res += new Array(fLen - dLen + 1).join('0');
		}
		if(dLen > fLen && (opt.round && decimalMatchRes[4].charAt(fLen) >= 5 || opt.ceil && decimalMatchRes[4].charAt(fLen) > 0)) {
			return util.formatDecimal((res * Math.pow(10, fLen) + 1) / Math.pow(10, fLen), format);
		}
		res = res.split('.');
		res[0] = formatInteger(res[0]);
		res = res.join('.');
		if(decimalMatchRes[1] && res != '0') {
			res = decimalMatchRes[1] + res;
		}
		return res;
	};

	util.formatDateTime = function(date, format) {
		if(!date) {
			return '';
		}
		var res = format, tt = '';
		date = new Date(date);
		res = res.replace(/yyyy|yy/, function($0) {
			if($0.length === 4) {
				return date.getFullYear();
			} else {
				return (date.getFullYear() + '').slice(2, 4);
			}
		}).replace(/MM|M/, function($0) {
			if($0.length === 2 && date.getMonth() < 9) {
				return '0' + (date.getMonth() + 1);
			} else {
				return date.getMonth() + 1;
			}
		}).replace(/dd|d/, function($0) {
			if($0.length === 2 && date.getDate() < 10) {
				return '0' + date.getDate();
			} else {
				return date.getDate();
			}
		}).replace(/HH|H/, function($0) {
			if($0.length === 2 && date.getHours() < 10) {
				return '0' + date.getHours();
			} else {
				return date.getHours();
			}
		}).replace(/hh|h/, function($0) {
			var hours = date.getHours();
			if(hours > 11) {
				tt = 'PM';
			} else {
				tt ='AM';
			}
			hours = hours > 12 ? hours - 12 : hours;
			if($0.length === 2 && hours < 10) {
				return '0' + hours;
			} else {
				return hours;
			}
		}).replace(/mm/, function($0) {
			if(date.getMinutes() < 10) {
				return '0' + date.getMinutes();
			} else {
				return date.getMinutes();
			}
		}).replace(/ss/, function($0) {
			if(date.getSeconds() < 10) {
				return '0' + date.getSeconds();
			} else {
				return date.getSeconds();
			}
		}).replace('tt', tt);
		return res;
	};

	util.formatLeftTime = function(ms, hh, mm, ss) {
		var s = m = h = 0;
		s = parseInt(ms / 1000);
		s = s || 1;
		if(s >= 60) {
			m = parseInt(s / 60);
			s = s % 60;
		}
		if(m >= 60) {
			h = parseInt(m / 60);
			m = m % 60;
		}
		return [h ? h + (hh || 'h') : '', m ? m + (mm || 'm') : '', s ? s + (ss || 's') : ''].join('');
	};

	util.formatFileSize = function(bytes) {
		var k, m, g;
		if(bytes < 100) {
			return util.formatDecimal(bytes, '0.00' , {ceil: 1}) + 'B';
		}
		k = bytes / 1024;
		if(k < 1000) {
			return util.formatDecimal(k, '0.00', {ceil: 1}) + 'KB';
		}
		m = k / 1024;
		if(m < 1000) {
			return util.formatDecimal(m, '0.00', {ceil: 1}) + 'MB';
		}
		g = m / 1024;
		return util.formatDecimal(g, '0.00', {ceil: 1}) + 'GB';
	};
	
	return util;
});
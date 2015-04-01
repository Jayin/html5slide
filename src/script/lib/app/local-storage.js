define(function(require) {
	var _db = {
		name: 'default',
		db: {},

		set: function(key, val) {
			this.db[key] = val;
		},

		get: function(key) {
			return this.db[key];
		},

		remove: function(key) {
			delete this.db[key];
		},

		clear: function() {
			this.db = {};
		}
	};
	
	var _dbs = [
		{
			name: 'localStorage',
			isSupported: !!window.localStorage,
			
			set: function(key, val) {
				localStorage.setItem(key, val);
			},
			
			get: function(key) {
				return localStorage.getItem(key);
			},

			remove: function(key) {
				localStorage.removeItem(key);
			},

			clear: function() {
				localStorage.clear();
			},

			init: function() {}
		}
	];

	for(i = 0; i < _dbs.length; i++) {
		if(_dbs[i].isSupported) {
			_db = _dbs[i];
			_db.init();
			break;
		}
	}

	var _facade = {
		set: function(opts) {
			var res = _db.set(opts.key, opts.val, opts.life);
			if(opts.cb) {
				return opts.cb(res);
			} else {
				return res;
			}
		},

		get: function(opts) {
			var res;
			var keys = opts.key.split(' ');
			if(keys.length > 1) {
				res = {};
				$.each(keys, function(i, key) {
					res[key] = _db.get(key);
				});
			} else {
				res = _db.get(keys[0]);
			}
			if(opts.cb) {
				return opts.cb(res);
			} else {
				return res;
			}
		},

		remove: function(opts) {
			var keys = opts.key.split(' ');
			if(keys.length > 1) {
				$.each(keys, function(i, key) {
					_db.remove(key);
				});
			} else {
				_db.remove(keys[0]);
			}
			if(opts.cb) {
				opts.cb();
			}
		},

		clear: function(opts) {
			_db.clear();
			if(opts.cb) {
				opts.cb();
			}
		}
	};

	function _do(action, opts) {
		opts = opts || {};
		return _facade[action](opts);
	};

	function _getWithExpires(val, key, proxy) {
		var rmKeys = [];
		if(val && typeof val == 'object') {
			$.each(val, function(k, v) {
				val[k] = getOne(v, k);
			});
		} else {
			val = getOne(val, key);
		}
		if(rmKeys.length) {
			remove(rmKeys.join(' '), {proxy: proxy});
		}
		function getOne(val, key) {
			var m;
			if(val) {
				m = val.match(/(.*)\[expires=(\d+)\]$/);
				if(m) {
					if(m[2] < new Date().getTime()) {
						val = undefined;
						rmKeys.push(key);
					} else {
						val = m[1];
					}
				}
			} else {
				val = undefined;
			}
			return val;
		}
		return val;
	};

	function set(key, val, opts) {
		opts = opts || {};
		if(opts.life && _db.name != 'cookie') {//hour
			val = val + ('[expires=' + (new Date().getTime() + opts.life * 3600000) + ']');
		}
		return _do('set', {key: key, val: val, cb: opts.callback, life: opts.life});
	};

	function get(key, opts) {
		var cb, res;
		opts = opts || {};
		if(opts.callback) {
			cb = function(res) {
				opts.callback(_getWithExpires(res, key, opts.proxy));
			}
			return _do('get', {key: key, cb: cb});
		} else {
			res = _do('get', {key: key});
			return _getWithExpires(res, key, opts.proxy);
		}
	};

	function remove(key, opts) {
		opts = opts || {};
		return _do('remove', {key: key});
	};

	function clear(opts) {
		opts = opts || {};
		return _do('clear', {});
	};

	return {
		_db: _db,
		_do: _do,
		set: set,
		get: get,
		remove: remove,
		clear: clear
	};
});

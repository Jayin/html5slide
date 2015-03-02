/**
 * YOM module define and require lib lite 1.1
 * Inspired by RequireJS AMD spec
 * Copyright (c) 2012 Gary Wang, webyom@gmail.com http://webyom.org
 * Under the MIT license
 * https://github.com/webyom/yom
 */
var define, require

;(function(global) {
	if(require && require._YOM_) {
		return
	}

	/**
	 * utils
	 */
	var _head = document.head || document.getElementsByTagName('head')[0] || document.documentElement
	var _op = Object.prototype
	var _ots = _op.toString

	var _isArray = Array.isArray || function(obj) {
		return _ots.call(obj) == '[object Array]'
	}

	function _getArray(arr) {
		return Array.prototype.slice.call(arr)
	}

	function _isFunction(obj) {
		return _ots.call(obj) == '[object Function]'
	}

	function _hasOwnProperty(obj, prop) {
		return _op.hasOwnProperty.call(obj, prop)
	}

	function _trimTailSlash(path) {
		return path.replace(/\/+$/, '')
	}

	function _each(arr, callback) {
		for(var i = 0, l = arr.length; i < l; i++) {
			callback(arr[i], i, arr)
		}
	}

	function _extend(origin, extend, check) {
		origin = origin || {}
		for(var p in extend) {
			if(_hasOwnProperty(extend, p) && (!check || typeof origin[p] == 'undefined')) {
				origin[p] = extend[p]
			}
		}
		return origin
	}

	function _clone(obj, deep, _level) {
		var res = obj
		deep = deep || 0
		_level = _level || 0
		if(_level > deep) {
			return res
		}
		if(typeof obj == 'object' && obj) {
			if(_isArray(obj)) {
				res = []
				_each(obj, function(item) {
					res.push(item)
				})
			} else {
				res = {}
				for(var p in obj) {
					if(_hasOwnProperty(obj, p)) {
						res[p] = deep ? _clone(obj[p], deep, ++_level) : obj[p]
					}
				}
			}
		}
		return res
	}

	function _getUrlParamObj(str) {
		if(!str) {
			return {}
		}
		var param = {}
		var tmp = str.replace(/^[?#]/, '').split('&')
		var i, item, key, val
		for(i = 0; i < tmp.length; i++) {
			item = tmp[i].split('=')
			key = item[0]
			val = decodeURIComponent(item[1] || '')
			param[key] = val
		}
		return param
	}

	/**
	 * config
	 */
	var _PAGE_BASE_URL = location.protocol + '//' + location.host + location.pathname.split('/').slice(0, -1).join('/')
	var _RESERVED_NRM_ID = {
		require: 1,
		exports: 1,
		module: 1,
		global: 1,
		domReady: 1
	}
	var _ERR_CODE = {
		DEFAULT: 1,
		TIMEOUT: 2,
		LOAD_ERROR: 3,
		NO_DEFINE: 4
	}

	var _DEFAULT_CONFIG = {
		charset: 'utf-8',
		baseUrl: '',
		paths: {},//match by id removed prefix
		fallbacks: {},//match by id removed prefix
		shim: {},//match by id removed prefix
		enforceDefine: false,
		//global
		debug: false,
		resolveUrl: null,
		errCallback: null,
		onLoadStart: null,
		onLoadEnd: null,
		waitSeconds: 30
	}
	var _gcfg = _extendConfig(['debug', 'charset', 'baseUrl', 'paths', 'fallbacks', 'shim', 'enforceDefine', 'resolveUrl', 'errCallback', 'onLoadStart', 'onLoadEnd', 'waitSeconds'], _clone(_DEFAULT_CONFIG, 1), typeof require == 'object' ? require : undefined)//global config
	_gcfg.baseUrl = _getFullBaseUrl(_gcfg.baseUrl)
	_gcfg.debug = !!_gcfg.debug || location.href.indexOf('yom-debug=1') > 0
	var _loadingCount = 0

	var _hold = {}//loading or waiting dependencies
	var _defQueue = []
	var _postDefQueue = []
	var _defined = {}
	var _depReverseMap = {}

	function Def(nrmId, baseUrl, exports, module, getter, loader) {
		this._nrmId = nrmId
		this._baseUrl = baseUrl
		this._exports = exports
		this._module = module
		this._getter = getter
		this._loader = loader
		_defined[module.uri] = this
	}

	Def.prototype = {
		getDef: function(context) {
			if(this._getter) {
				return this._getter(context)
			} else {
				return this._exports
			}
		},

		getLoader: function() {
			return this._loader
		},

		constructor: Def
	}

	new Def('require', _gcfg.baseUrl, {}, {id: 'require', uri: 'require'}, function(context) {
		return _makeRequire({config: context.config, base: context.base})
	})
	new Def('exports', _gcfg.baseUrl, {}, {id: 'exports', uri: 'exports'}, function(context) {
		return {}
	})
	new Def('module', _gcfg.baseUrl, {}, {id: 'module', uri: 'module'}, function(context) {
		return {}
	})
	new Def('global', _gcfg.baseUrl, global, {id: 'global', uri: 'global'})
	new Def('domReady', _gcfg.baseUrl, {}, {id: 'domReady', uri: 'domReady'}, function(context) {
		return {}
	}, (function() {
		var _queue = []
		var _checking = false
		var _ready = false

		function _onready() {
			if(_ready) {
				return
			}
			_ready = true
			while(_queue.length) {
				domReadyLoader.apply(null, _getArray(_queue.shift()))
			}
		}

		function _onReadyStateChange() {
			if(document.readyState == 'complete') {
				_onready()
			}
		}

		function _checkReady() {
			if(_checking || _ready) {
				return
			}
			_checking = true
			if(document.readyState == 'complete') {
				_onready()
			} else {
				document.addEventListener('DOMContentLoaded', _onready, false)
				window.addEventListener('load', _onready, false)
			}
		}

		function domReadyLoader(context, onRequire) {
			if(_ready) {
				onRequire(0)
			} else {
				_queue.push(arguments)
				_checkReady()
			}
		}

		return domReadyLoader
	})())

	function Hold(id, nrmId, config) {
		var baseUrl = config.baseUrl
		this._id = id
		this._nrmId = nrmId
		this._baseUrl = baseUrl
		this._config = config
		this._defineCalled = false
		this._queue = []
		this._fallbacks = config.fallbacks[id]
		this._shim = config.shim[id]
		this._uri = _getFullUrl(nrmId, baseUrl)
		if(!_isArray(this._fallbacks)) {
			this._fallbacks = [this._fallbacks]
		}
		_hold[this._uri] = this
	}

	Hold.prototype = {
		push: function(onRequire) {
			this._queue.push(onRequire)
		},

		defineCall: function() {
			this._defineCalled = true
		},

		isDefineCalled: function() {
			return this._defineCalled
		},

		remove: function() {
			delete _hold[this._uri]
		},

		dispatch: function(errCode, opt) {
			var callback
			while(this._queue.length) {
				callback = this._queue.shift()
				if(callback) {
					callback(errCode, opt || {uri: this._uri})
				}
			}
		},

		getConfig: function() {
			return this._config
		},

		getShim: function() {
			return this._shim
		},

		getFallback: function() {
			return this._fallbacks.shift()
		},

		loadShimDeps: function(callback) {
			var nrmId = this._nrmId
			var config = this._config
			var shim = this._shim
			if(shim.deps) {
				_makeRequire({config: config, base: {nrmId: nrmId, baseUrl: this._baseUrl}})(shim.deps, function() {
					callback()
				}, function(code) {
					callback(code)
				})
			} else {
				callback()
			}
		},

		shimDefine: function() {
			var hold = this
			var nrmId = this._nrmId
			var baseUrl = this._baseUrl
			var config = this._config
			var shim = this._shim
			var exports
			if(config.enforceDefine && !shim) {
				return false
			}
			if(shim && shim.exports) {
				exports = _getShimExports(shim.exports)
				if(!exports) {
					return false
				}
			}
			_makeRequire({config: config, base: {nrmId: nrmId, baseUrl: baseUrl}})(shim && shim.deps || [], function() {
				var args = _getArray(arguments)
				if(shim && shim.init) {
					exports = shim.init.apply(global, args) || exports
				}
				new Def(nrmId, baseUrl, exports, {id: nrmId, uri: _getFullUrl(nrmId, baseUrl)})
				hold.remove()
				hold.dispatch(0)
			}, function(code, opt) {
				hold.remove()
				hold.dispatch(code, opt)
			})
			return true
		},

		constructor: Hold
	}

	function _getHold(nrmId, baseUrl) {
		var url = _getFullUrl(nrmId, baseUrl)
		return _hold[url]
	}

	function _getDefined(id, nrmId, config) {
		var def, shim, exports, module
		var url = _getFullUrl(nrmId, config.baseUrl)
		def = _defined[url]
		if(!def) {
			shim = config.shim[id]
			if(shim && shim.exports) {
				exports = _getShimExports(shim.exports)
				if(exports) {
					module = {
						id: nrmId,
						uri: _getFullUrl(nrmId, config.baseUrl)
					}
					def = new Def(nrmId, config.baseUrl, exports, module)
				}
			}
		}
		return def
	}

	function _getShimExports(name) {
		var exports = global
		name = name.split('.')
		while(exports && name.length) {
			exports = exports[name.shift()]
		}
		return exports
	}

	function _getDepReverseMap(url) {
		var map = _depReverseMap[url] = _depReverseMap[url] || {}
		return map
	}

	function _setDepReverseMap(url, depReverseUrl) {
		var map = _getDepReverseMap(url)
		map[depReverseUrl] = 1
	}

	function _hasCircularDep(depReverseUrl, url, _checkedUrls) {
		var depMap = _getDepReverseMap(depReverseUrl)
		var p
		_checkedUrls = _checkedUrls || {}
		if(_checkedUrls[depReverseUrl]) {
			return false
		}
		if(url == depReverseUrl || depMap[url]) {
			return true
		}
		_checkedUrls[depReverseUrl] = 1
		for(p in depMap) {
			if(!_hasOwnProperty(depMap, p)) {
				continue
			}
			if(_hasCircularDep(p, url, _checkedUrls)) {
				return true
			}
		}
		return false
	}

	/**
	 * id start width 'http:', 'https:', '/', or end with '.js' is unnormal
	 */
	function _isUnnormalId(id) {
		return (/^https?:|^\/|\.js$/).test(id)
	}

	function _isRelativePath(path) {
		return (path + '').indexOf('.') === 0
	}

	function _normalizeId(id, base, paths) {
		var nrmId, a, b, maped
		if(!id) {
			return id
		}
		if(_isUnnormalId(id)) {
			return id
		}
		if(base && _isRelativePath(id)) {
			if(_isUnnormalId(base.nrmId)) {
				id += '.js'
			}
			return _resolvePath(base.nrmId, id)
		} else {
			nrmId = id
		}
		if(_isRelativePath(nrmId)) {
			return nrmId
		}
		if(paths) {
			a = nrmId.split('/')
			b = []
			while(a.length) {
				maped = paths[a.join('/')]
				if(maped) {
					b.unshift(_trimTailSlash(maped))
					return b.join('/')
				}
				b.unshift(a.pop())
			}
		}
		return nrmId
	}

	function _extendConfig(props, config, ext) {
		if(!config) {
			return ext
		} else if(!ext || config == ext || (props.length === 1 && props[0] == 'baseUrl' && config.baseUrl == ext.baseUrl)) {
			return config
		}
		ext.baseUrl = _getFullBaseUrl(ext.baseUrl)
		if(ext.baseUrl && config.baseUrl != ext.baseUrl) {
			config = _clone(_DEFAULT_CONFIG, 1)
		} else {
			config = _clone(config, 1)
		}
		_each(props, function(p) {
			config[p] = typeof config[p] == 'object' && typeof ext[p] == 'object' ? _extend(config[p], ext[p]) :
					typeof ext[p] == 'undefined' ? config[p] : ext[p]
		})
		return config
	}

	function _getOrigin() {
		return location.origin || location.protocol + '//' +  location.host
	}

	function _resolvePath(base, path) {
		if(!_isRelativePath(path)) {
			return path
		}
		var bArr = base.split('/'),
			pArr = path.split('/'),
			part
		bArr.pop()
		while(pArr.length) {
			part = pArr.shift()
			if(part == '..') {
				if(bArr.length) {
					part = bArr.pop()
					while(part == '.') {
						part = bArr.pop()
					}
					if(part == '..') {
						bArr.push('..', '..')
					}
				} else {
					bArr.push(part)
				}
			} else if(part != '.') {
				bArr.push(part)
			}
		}
		path = bArr.join('/')
		return path
	}

	function _getFullBaseUrl(url) {
		if(url) {
			if(url.indexOf('://') < 0 && url.indexOf('//') !== 0) {
				if(url.indexOf('/') === 0) {
					url = _getOrigin() + _trimTailSlash(url)
				} else {
					url = _getOrigin() + _resolvePath(location.pathname, _trimTailSlash(url))
				}
			} else {
				url = _trimTailSlash(url)
			}
		}
		return url
	}

	function _getFullUrl(nrmId, baseUrl) {
		var url = ''
		baseUrl = baseUrl || _gcfg.baseUrl
		if(_RESERVED_NRM_ID[nrmId] || _isUnnormalId(nrmId)) {
			url = nrmId
		} else if(nrmId && _isRelativePath(nrmId)) {
			url = _resolvePath(baseUrl + '/', nrmId) + '.js'
		} else if(nrmId) {
			url = baseUrl + '/' + nrmId + '.js'
		}
		if(_gcfg.resolveUrl) {
			url = _gcfg.resolveUrl(url)
		}
		return url
	}

	function _getCharset(id, charset) {
		if(typeof charset == 'string') {
			return charset
		} else {
			return charset && (charset[id] || charset['*']) || ''
		}
	}

	function _endLoad(jsNode, onload, onerror) {
		_loadingCount--
		jsNode.removeEventListener('load', onload, false)
		jsNode.removeEventListener('error', onerror, false)
		jsNode.parentNode.removeChild(jsNode)
		if(_loadingCount === 0 && _gcfg.onLoadStart) {
			try {
				_gcfg.onLoadEnd()
			} catch(e) {
				if(_gcfg.debug) {
					throw e
				}
			}
		}
	}

	function _dealError(code, opt, errCallback) {
		opt = opt || {}
		if(errCallback) {
			errCallback(code, opt)
		} else if(_gcfg.errCallback) {
			_gcfg.errCallback(code, opt)
		} else {
			if(opt.uri) {
				throw new Error('Failed to load ' + opt.uri)
			} else {
				throw new Error('Load Error')
			}
		}
	}

	function _doLoad(id, nrmId, config, hold) {
		var baseUrl, charset, jsNode, urlArg, loadUrl
		baseUrl = config.baseUrl
		charset = _getCharset(id, config.charset)
		jsNode = document.createElement('script')
		jsNode.addEventListener('load', _onload, false)
		jsNode.addEventListener('error', _onerror, false)
		if(charset) {
			jsNode.charset = charset
		}
		jsNode.type = 'text/javascript'
		jsNode.async = 'async'
		loadUrl = _getFullUrl(nrmId, baseUrl)
		jsNode.src = loadUrl
		jsNode.setAttribute('data-nrm-id', nrmId)
		jsNode.setAttribute('data-base-url', baseUrl)
		_head.insertBefore(jsNode, _head.firstChild)
		_loadingCount++
		if(_loadingCount === 1 && _gcfg.onLoadStart) {
			try {
				_gcfg.onLoadStart()
			} catch(e) {
				if(_gcfg.debug) {
					throw e
				}
			}
		}
		function _onload() {
			var def, fallback
			_endLoad(jsNode, _onload, _onerror)
			_processDefQueue(nrmId, baseUrl, config)
			if(!hold.isDefineCalled() && !hold.shimDefine()) {
				fallback = hold.getFallback()
				if(fallback) {
					_doLoad(id, fallback, config, hold)
				} else {
					hold.remove()
					hold.dispatch(_ERR_CODE.NO_DEFINE)
				}
			}
		}
		function _onerror() {
			var fallback = hold.getFallback()
			_endLoad(jsNode, _onload, _onerror)
			if(fallback) {
				_doLoad(id, fallback, config, hold)
			} else {
				hold.remove()
				hold.dispatch(_ERR_CODE.NO_DEFINE)
			}
		}
	}

	function _load(id, nrmId, config, onRequire) {
		var baseUrl = config.baseUrl,
			jsNode, urlArg
		var def, hold
		def = _getDefined(id, nrmId, config)
		hold = _getHold(nrmId, baseUrl)
		if(def) {
			onRequire(0)
			return
		} else if(hold) {
			hold.push(onRequire)
			return
		}
		hold = new Hold(id, nrmId, config)
		hold.push(onRequire)
		if(hold.getShim()) {
			hold.loadShimDeps(function(errCode) {
				if(errCode) {
					hold.remove()
					hold.dispatch(errCode)
				} else {
					_doLoad(id, nrmId, config, hold)
				}
			})
		} else {
			_doLoad(id, nrmId, config, hold)
		}
	}

	function _processDefQueue(nrmId, baseUrl, config) {
		var def, queue, defQueue, postDefQueue
		defQueue = _defQueue
		postDefQueue = _postDefQueue
		def = defQueue.shift()
		while(def) {
			_defineCall(def.id, def.deps, def.factory, {
				nrmId: nrmId || def.id,
				baseUrl: baseUrl || def.config && def.config.baseUrl || config && config.baseUrl || _gcfg.baseUrl,
				config: config
			}, def.config, postDefQueue)
			def = defQueue.shift()
		}
		def = postDefQueue.shift()
		while(def) {
			_postDefineCall(def.base, def.deps, def.factory, def.hold, def.config)
			def = postDefQueue.shift()
		}
	}

	/**
	 * define
	 */
	function _defineCall(id, deps, factory, loadInfo, config, postDefQueue) {
		var nrmId, conf, loadHold, hold, depMap
		var baseUrl = loadInfo.baseUrl
		var baseConfig = loadInfo.config || config
		config = _extendConfig(['charset', 'baseUrl', 'paths', 'fallbacks', 'shim', 'enforceDefine'], baseConfig, config)
		loadHold = _getHold(loadInfo.nrmId, baseUrl)
		if(id == loadInfo.nrmId) {//html built in module
			nrmId = loadInfo.nrmId
		} else {
			nrmId = _normalizeId(id, loadInfo, config.paths)
		}
		if((!nrmId || nrmId == loadInfo.nrmId) && loadHold) {
			nrmId = loadInfo.nrmId
			hold = loadHold
			hold.defineCall()
		} else {//multiple define in a file
			hold = new Hold(id, nrmId, baseConfig)
			hold.defineCall()
		}
		postDefQueue.push({
			base: {
				nrmId: nrmId,
				baseUrl: baseUrl,
				config: baseConfig
			},
			deps: deps,
			factory: factory,
			hold: hold,
			config: config
		})
	}

	function _postDefineCall(base, deps, factory, hold, config) {
		_makeRequire({config: config, base: base})(deps, function() {
			var nrmId = base.nrmId
			var baseUrl = base.baseUrl || config.baseUrl
			var exports, module, factoryRes
			var args = _getArray(arguments)
			module = {
				id: nrmId,
				uri: _getFullUrl(nrmId, baseUrl)
			}
			if(deps[2] == 'module') {
				args[2] = module
			}
			if(_isFunction(factory)) {
				if(deps[1] == 'exports') {
					exports = module.exports = args[1] = {}
				}
				exports = factory.apply(null, args) || module.exports
			} else {
				exports = factory
			}
			module.exports = exports
			new Def(nrmId, baseUrl, exports, module)
			hold.remove()
			hold.dispatch(0)
		}, function(code, opt) {
			hold.remove()
			hold.dispatch(code, opt)
		})
	}

	function _makeDefine(context) {
		var config
		context = context || {}
		context.parentConfig = context.parentConfig || _gcfg
		config = _extendConfig(['charset', 'baseUrl', 'paths', 'fallbacks', 'shim', 'enforceDefine'], context.parentConfig, context.config)
		function def(id, deps, factory) {
			var script, factoryStr, reqFnName, defQueue
			if(typeof id != 'string') {
				factory = deps
				deps = id
				id = ''
			}
			if(typeof factory == 'undefined' || !_isArray(deps)) {
				factory = deps
				deps = []
			}
			if(!deps.length && _isFunction(factory) && factory.length) {
				factoryStr = factory.toString()
				reqFnName = factoryStr.match(/^function[^\(]*\(([^\)]+)\)/) || ['', 'require']
				reqFnName = (reqFnName[1].split(',')[0]).replace(/\s/g, '')
				factoryStr.replace(new RegExp('(?:^|[^\\.\\/\\w])' + reqFnName + '\\s*\\(\\s*(["\'])([^"\']+?)\\1\\s*\\)', 'g'), function(full, quote, dep) {//extract dependencies
						deps.push(dep)
					})
				deps = (factory.length === 1 ? ['require'] : ['require', 'exports', 'module']).concat(deps)
			}
			defQueue = _defQueue
			defQueue.push({
				id: id,
				deps: deps,
				factory: factory,
				config: config
			})
			return def
		}
		def.config = function(conf) {
			config = _extendConfig(['debug', 'charset', 'baseUrl', 'paths', 'fallbacks', 'shim', 'enforceDefine', 'resolveUrl', 'errCallback', 'onLoadStart', 'onLoadEnd', 'waitSeconds'], config, conf)
			return def
		}
		def.extend = function(conf) {
			return _makeDefine({config: conf, parentConfig: config})
		}
		return def
	}

	define = _makeDefine()
	define._ROOT_ = true
	define.amd = {

	}

	function _getDep(id, config, context) {
		var base, conf, nrmId, def, fullUrl, baseFullUrl, loader
		if(!id) {
			return {}
		}
		def = _defined[id]
		if(def) {//reserved
			loader = def.getLoader()
			if(loader) {
				return {inst: def, load: {loader: loader, id: id, nrmId: id, config: config}}
			} else {
				return {inst: def}
			}
		}
		conf = config
		base = context.base
		nrmId = _normalizeId(id, base, conf.paths)
		if(_isRelativePath(id)) {
			conf = base && base.config || conf
		}
		def = _getDefined(id, nrmId, conf)
		fullUrl = _getFullUrl(nrmId, conf.baseUrl)
		if(base) {
			baseFullUrl = _getFullUrl(base.nrmId, base.baseUrl)
			_setDepReverseMap(fullUrl, baseFullUrl)
			if(!def && _hasCircularDep(baseFullUrl, fullUrl)) {//cirular dependency
				return {}
			}
		}
		if(def) {
			return {inst: def}
		} else {
			return {load: {id: id, nrmId: nrmId, config: conf}}
		}
	}

	function _makeRequire(context) {
		var config
		context = context || {}
		context.parentConfig = context.parentConfig || _gcfg
		config = _extendConfig(['charset', 'baseUrl', 'paths', 'fallbacks', 'shim', 'enforceDefine'], context.parentConfig, context.config)
		function req(deps, callback, errCallback) {
			var over = false
			var loadList = []
			var def, count, callArgs, toRef
			if(typeof deps == 'string') {
				if(arguments.length === 1) {
					def = _getDep(deps, config, context)
					return def.inst && def.inst.getDef(context)
				} else {
					throw new Error('Wrong arguments for require.')
				}
			}
			callArgs = new Array(deps.length)
			_each(deps, function(id, i) {
				var def = _getDep(id, config, context)
				if(def.load) {
					loadList.push(def.load)
				} else if(def.inst) {
					callArgs[i] = def.inst.getDef(context)
				} else {
					callArgs[i] = null
				}
			})
			count = loadList.length
			if(count) {
				if(!context.base) {
					toRef = setTimeout(function() {
						if(over) {
							return
						}
						over = true
						_dealError(_ERR_CODE.TIMEOUT, errCallback)
					}, config.waitSeconds * 1000)
				}
				_each(loadList, function(item, i) {
					var hold
					if(item.loader) {//reserved module loader
						item.loader(context, onRequire)
					} else {
						hold = _getHold(item.nrmId, item.config.baseUrl)
						if(hold) {
							hold.push(onRequire)
						} else {
							_load(item.id, item.nrmId, item.config, onRequire)
						}
					}
				})
			} else {
				callback && callback.apply(null, callArgs)
			}
			function onRequire(errCode, opt) {
				if(over) {
					return
				}
				if(errCode) {
					over = true
					clearTimeout(toRef)
					if(context.base) {
						_dealError(errCode, opt, errCallback)
					} else {
						try {
							_dealError(errCode, opt, errCallback)
						} catch(e) {
							if(_gcfg.debug) {
								throw e
							}
						}
					}
				} else {
					count--
					if(count <= 0) {
						over = true
						clearTimeout(toRef)
						if(callback) {
							_each(callArgs, function(arg, i) {
								var def
								if(typeof arg == 'undefined') {
									arg = loadList.shift()
									def = _getDefined(arg.id, arg.nrmId, arg.config)
									callArgs[i] = def.getDef(context)
								}
							})
							if(context.base) {
								callback.apply(null, callArgs)
							} else {
								try {
									callback.apply(null, callArgs)
								} catch(e) {
									if(_gcfg.debug) {
										throw e
									}
								}
							}
						}
					}
				}
			}
			return req
		}
		req.config = function(conf) {
			config = _extendConfig(['debug', 'charset', 'baseUrl', 'paths', 'fallbacks', 'shim', 'enforceDefine', 'resolveUrl', 'errCallback', 'onLoadStart', 'onLoadEnd', 'waitSeconds'], config, conf)
			if(req._ROOT_) {
				_gcfg = config
				define.config(conf)
			}
			return req
		}
		req.extend = function(conf) {
			return _makeRequire({config: conf, parentConfig: config})
		}
		req.getConfig = function(key) {
			if(key) {
				return config[key]
			}
			return config
		}
		req.toUrl = function(url, onlyPath) {
			if(context.base) {
				url = _resolvePath(_getFullUrl(context.base.nrmId, context.base.baseUrl), url)
			} else {
				url = _resolvePath(config.baseUrl + '/', url)
			}
			if(onlyPath) {
				url = url.replace(/^https?:\/\/[^\/]*?\//, '/')
			}
			return url
		}
		req.ERR_CODE = _ERR_CODE
		return req
	}

	require = _makeRequire()

	require._YOM_ = true
	require._ROOT_ = true
	require.PAGE_BASE_URL = _PAGE_BASE_URL
	//for modules built with require.js or html builtin
	require.processDefQueue = _processDefQueue
	//for modules built with require.js or html builtin
	require.getBaseUrlConfig = function(baseUrl) {
		return _extendConfig(['baseUrl'], _gcfg, {baseUrl: baseUrl || _PAGE_BASE_URL})
	}
	//debug
	require._debug = {
		defQueue: _defQueue,
		postDefQueue: _postDefQueue,
		hold: _hold,
		defined: _defined,
		depReverseMap: _depReverseMap
	}

	if(!_gcfg.baseUrl) {
		_gcfg.baseUrl = _PAGE_BASE_URL
	}
})(this)

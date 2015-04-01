define(function(require) {
	return {
		config: require('./config'),
		css: require('./css'),
		cookie: require('./cookie'),
		localStorage: require('./local-storage'),
		util: require('./util'),
		ajax: require('./ajax'),
		alerts: require('./alerts'),
		scroll: require('./scroll'),
		toggle: require('./toggle'),
		wx: require('./wx')
	};
});
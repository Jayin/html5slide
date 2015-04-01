define(function(require) {
	var _ready = typeof WeixinJSBridge != 'undefined';
	
	var wx = {};

	wx.ready = function(callback) {
		if(_ready) {
			callback();
		} else {
			if(typeof WeixinJSBridge == 'undefined') {
				if(document.addEventListener) {
					document.addEventListener('WeixinJSBridgeReady', function() {
						_ready = true;
						callback();
					}, false);
				} else if (document.attachEvent) {
					document.attachEvent('WeixinJSBridgeReady', function() {
						_ready = true;
						callback();
					}); 
					document.attachEvent('onWeixinJSBridgeReady', function() {
						_ready = true;
						callback();
					});
				}
			} else {
				_ready = true;
				callback();
			}
		}
	};

	wx.version = function() {
		var wx = navigator.userAgent.match(/MicroMessenger\/([\d.]+)/i);
		if(wx) {
			return parseInt(wx[1]);
		} else {
			return -1;
		}
	};
	
	return wx;
});
;(function(window){
    var __WX_DEBUG__ = function(msg){
		var debug = true;
		if(debug){
			alert(msg);
		}
	}
	if(G.IS_PROTOTYPE){
		window.wxOpenId = '123456789';
		return;
	}
	/**
	 * 解析url
	 * @param  {[type]} url [description]
	 * @return {[type]}     [description]
	 */
	var parser = function(url) {
		var a = document.createElement('a');
		a.href = url;

		var search = function(search) {
			if (!search) return {};

			var ret = {};
			search = search.slice(1).split('&');
			for (var i = 0, arr; i < search.length; i++) {
				arr = search[i].split('=');
				var key = arr[0],
					value = arr[1];
				if (/\[\]$/.test(key)) {
					ret[key] = ret[key] || [];
					ret[key].push(value);
				} else {
					ret[key] = value;
				}
			}
			return ret;
		};

		return {
			protocol: a.protocol,
			host: a.host,
			hostname: a.hostname,
			pathname: a.pathname,
			search: search(a.search),
			hash: a.hash
		}
	};

	var url_obj = parser(window.location.href);

	//如果是回调页面
	if (url_obj.search.code == null || url_obj.search.code == undefined) {
		//没有code,跳转去拿code
		var redirect_uri = encodeURIComponent(window.location.href);
		var requestOpenIdUrl = 'https://open.weixin.qq.com/connect/oauth2/authorize?appid=APPID&redirect_uri=REDIRECT_URI&response_type=code&scope=SCOPE&state=STATE#wechat_redirect'

		var redir = requestOpenIdUrl.replace('APPID', 'wx3dd4674f2fb695c5')
			.replace('REDIRECT_URI', redirect_uri)
			.replace('SCOPE', 'snsapi_base')
            .replace('STATE', 'silent');//静默获取
		window.location.href = redir;
	} else {
		//有code,并且state=silent
        __WX_DEBUG__('have code, state='+ url_obj.search.state)
        //如果是静默获取
        if(url_obj.search.state && url_obj.search.state == 'silent'){
            window.wxOpenId = url_obj.search.code
            __WX_DEBUG__("silentor get code:"+url_obj.search.code)
        }else{
            //非静默获取,openId 就存在state里面(自己这么定义，以后面用code获取用户信息的openId为准)
            window.wxOpenId = url_obj.search.state
        }
	}
    __WX_DEBUG__("open id:"+window.wxOpenId)
})(window);

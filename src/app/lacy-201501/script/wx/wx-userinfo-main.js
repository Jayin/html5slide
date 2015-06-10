require(['app'], function(app) {
	var __WX_DEBUG__ = function(msg){
		var debug = false;
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
	/**
	 * 保存cookie
	 * @param {String} name       名
	 * @param {String} value      值
	 * @param {String} expiredays 保存天数
	 */
	var setCookie = function(name, value, expiredays) {
			var exdate = new Date();
			exdate.setDate(new Date().getDate() + expiredays);
			document.cookie = name + "=" + escape(value) +
				((expiredays == null) ? "" : ";expires=" + exdate.toGMTString());
		}
		/**
		 * 获取cookie
		 * @param  {String} name cookie
		 * @return {String|null}  cookie的值
		 */
	var getCookie = function(name) {
		if (document.cookie.length > 0) {
			var c_start = document.cookie.indexOf(name + "=")
			if (c_start != -1) {
				c_start = c_start + name.length + 1
				c_end = document.cookie.indexOf(";", c_start)
				if (c_end == -1) c_end = document.cookie.length
				return unescape(document.cookie.substring(c_start, c_end));
			}
		}
		return null;
	}

	var url_obj = parser(window.location.href);

	// var wxOpenId;
	var openIdCookieKey = 'userinfo_wxOpenId0610918';
	//尝试从cookie中获取
	var openIdInCookie = getCookie(openIdCookieKey);
	if (!openIdInCookie) {
		//如果是回调页面
		var code = url_obj.search.code;
		if (code == null || code == undefined) {
			//没有code,跳转去拿code
			var redirect_uri = encodeURIComponent(window.location.href);
			var requestOpenIdUrl = 'https://open.weixin.qq.com/connect/oauth2/authorize?appid=APPID&redirect_uri=REDIRECT_URI&response_type=code&scope=SCOPE&state=STATE#wechat_redirect'

			var redir = requestOpenIdUrl.replace('APPID', 'wx3dd4674f2fb695c5')
				.replace('REDIRECT_URI', redirect_uri)
				.replace('SCOPE', 'snsapi_userinfo');
			window.location.href = redir;
		} else {
			//有code，就请求后台获取userinfo
			__WX_DEBUG__("code:"+code)
			app.ajax.post({
				url: 'web/strait/oauth/55783312d4c62fc2baa29f54/'+code,
				success: function(res){
					if(res.code == 0){
						//获取到用户完整的信息
						setCookie(openIdCookieKey,res.data.openid,7);
						window.wxOpenId = res.data.openid;
						// alert('ajax get openid->'+ window.wxOpenId)
						__WX_DEBUG__('save cookie & wxopenid->'+window.wxOpenId);
					}else{
						alert('Error Code=' + res.code + " " + res.msg);
					}
				},
				error: function(){
					alert('网络繁忙，请重新再试');
				}
			});
		}

	} else {
		window.wxOpenId = openIdInCookie;
		__WX_DEBUG__('wxopenid from cookie->'+window.wxOpenId);
	}
});

/**
 * 静默获取微信用户的openId,openId就存放在code中
 * Usage:
 * 		1. 把这文件放到逻辑代码最前
 * 		2. 从window.wxOpenId 得到已获取的openId的值
 */

if (G.IS_PROTOTYPE) {
	//mockup data
    window.wxOpenId = '1234567890qwertyuiop123erfcvfazs'
} else {
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

    var wxOpenId;
    var openIdCookieKey = 'wxOpenId';
    //尝试从cookie中获取
    var openIdInCookie = getCookie(openIdCookieKey);
    if (openIdInCookie == null) {
        //如果是回调页面
        var urlParamOpenId = url_obj.search.code
        if (urlParamOpenId == null || urlParamOpenId == undefined) {
            //不是回调页就去回调
            var redirect_uri = encodeURIComponent(window.location.href);
            requestOpenIdUrl = 'https://open.weixin.qq.com/connect/oauth2/authorize?appid=APPID&redirect_uri=REDIRECT_URI&response_type=code&scope=SCOPE&state=STATE#wechat_redirect'

            var redir = requestOpenIdUrl.replace('APPID', 'wxd4f26aea63a05347')
                .replace('REDIRECT_URI', redirect_uri)
                .replace('SCOPE', 'snsapi_base');
            window.location = redir;
        } else {
            //保存在cookie 7日
            setCookie(openIdCookieKey, urlParamOpenId, 7);
            wxOpenId = urlParamOpenId;
        }

    } else {
        wxOpenId = openIdInCookie;
    }

    window.wxOpenId = wxOpenId;

}

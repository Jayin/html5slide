require(['jquery', 'http://res.wx.qq.com/open/js/jweixin-1.0.0.js', 'app'], function($, wx, app) {
    var shareUrl = location.href.split('#')[0];
    $(document).ready(function() {
        app.ajax.post({
            url: 'web/sharing/signWxshare/55783312d4c62fc2baa29f54',
            data: {
                url: shareUrl
            },
            timeout: 5000,
            error: function() {},
            success: function(result) {
                wx.config({
                    debug: false ,
                    appId: result.data.appId,
                    timestamp: result.data.timestamp,
                    nonceStr: result.data.nonceStr,
                    signature: result.data.signature,
                    jsApiList: [
                        'onMenuShareTimeline', 'onMenuShareAppMessage', 'onMenuShareQQ', 'onMenuShareWeibo'
                    ]
                });
                wx.ready(function() {
                    // 在这里调用 API
                    wx.onMenuShareTimeline({
                        title: '海峡两岸青年创业论坛', // 分享标题
                        link: shareUrl, // 分享链接
                        imgUrl: G.CDN_ORIGIN + '/static/app/lacy-201501/image/icon_share.jpg', // 分享图标
                        success: function() {
                        },
                        cancel: function() {
                            // 用户取消分享后执行的回调函数
                            // $('.close-bt').click();
                        }
                    });
                    wx.onMenuShareAppMessage({

                        title: '海峡两岸青年创业论坛', // 分享标题
                        desc: '造梦两岸 共话创想”新一季海峡两岸青年创业合作启动仪式',
                        link: shareUrl, // 分享链接
                        imgUrl: G.CDN_ORIGIN + '/static/app/lacy-201501/image/icon_share.jpg', // 分享图标
                        type: '', // 分享类型,music、video或link，不填默认为link
                        dataUrl: '', // 如果type是music或video，则要提供数据链接，默认为空
                        success: function() {
                        },
                        cancel: function() {
                            // 用户取消分享后执行的回调函数
                        }
                    });
                });
            }
        })
    });
});

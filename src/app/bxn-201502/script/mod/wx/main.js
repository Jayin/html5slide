require(['jquery', 'http://res.wx.qq.com/open/js/jweixin-1.0.0.js', 'app'], function($, wx, app) {
    var friendsCountIncrease = function() {
        app.ajax.post({
            url: "web/sharing/increaseSharingFriends/54f308fbd4c6505329ee48e7",
            success: function(response) {

                //$(".content").text("put success");
            },
            error: function(XMLHttpRequest, textStatus, errorThrown) {
                //$(".content").text(textStatus);
            }
        });
    };
    var momentsCountIncrease = function() {
        app.ajax.post({
            url: "web/sharing/increaseSharingMoments/54f308fbd4c6505329ee48e7",
            success: function(response) {

                //$(".content").text("put success");
            },
            error: function(XMLHttpRequest, textStatus, errorThrown) {
                //$(".content").text(textStatus);
            }
        });
    };
    var shareUrl = location.href.split('#')[0];
    $(document).ready(function() {
        app.ajax.post({
            // url: 'web/sharing/signWxshare/54f1b82a58f24d7d16c11e17',
            url: 'web/bxn/weixin/signature',
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
                        title: '我为最爱的人奉上了 求婚之舞，快来见证我们的幸福时刻吧！', // 分享标题        
                        link: shareUrl, // 分享链接
                        imgUrl: G.CDN_ORIGIN + '/static/app/bxn-201502/image/icon_share.jpg', // 分享图标
                        success: function() {
                            // 用户确认分享后执行的回调函数
                            momentsCountIncrease();
                        },
                        cancel: function() {
                            // 用户取消分享后执行的回调函数
                            // $('.close-bt').click();
                        }
                    });
                    wx.onMenuShareAppMessage({

                        title: '奉舞成婚', // 分享标题        
                        desc: '我为最爱的人奉上了 求婚之舞，快来见证我们的幸福时刻吧！',
                        link: shareUrl, // 分享链接
                        imgUrl: G.CDN_ORIGIN + '/static/app/bxn-201502/image/icon_share.jpg', // 分享图标
                        type: '', // 分享类型,music、video或link，不填默认为link
                        dataUrl: '', // 如果type是music或video，则要提供数据链接，默认为空
                        success: function() {
                            // 用户确认分享后执行的回调函数
                            friendsCountIncrease();
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
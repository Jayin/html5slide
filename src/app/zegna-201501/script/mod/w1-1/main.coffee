app = require 'app'
Skateboard = require 'skateboard'
$ = require 'jquery'

class Mod extends Skateboard.BaseMod
	_bodyTpl: require './body.tpl.html'

	init: ->
		setTimeout ->
			Skateboard.core.load 'view/w1-1/b1'
			Skateboard.core.load 'view/w1-1/b2'
			Skateboard.core.load 'view/w1-1/b3'
		, 2000

	render: ->
		super
		@$('[data-like-id]').each (i, el) ->
			$(el).removeClass 'hidden'

module.exports = Mod

__END__

@@ body.tpl.html
<%
var $ = require('jquery');
var app = require('app');
%>

<!-- include "body.scss" -->

<div class="body-inner">
	<div class="img-bg-wrapper">
		<img class="img-bg-img" src="<%=G.CDN_BASE%>/app/zegna-201501/image/w1-1-bg.jpg" />
		<div class="img-bg-cover"></div>

		<a data-click-tag="l1_top_wechat_open.<%=G.getStatCid()%>.<%=G.getStatMid()%>" class="img-btn header-wechat-btn" href="javascript:void(0);">wechat</a>
		<a data-click-tag="l1_top_share.<%=G.getStatCid()%>.<%=G.getStatMid()%>" class="img-btn header-share-btn share-btn" href="javascript:void(0);">share</a>
		<a data-click-tag="l1_top_locator.<%=G.getStatCid()%>.<%=G.getStatMid()%>" class="img-btn header-shop-btn" href="http://mp.weixin.qq.com/s?__biz=MzA3MjU1OTAwNg==&mid=211369012&idx=1&sn=42969187a2a93a423326e15b600ffae8#rd">shop</a>

		<a data-click-tag="l1_b1_jpgclick.<%=G.getStatCid()%>.<%=G.getStatMid()%>" class="img-btn" href="/view/w1-1/b1" style="left: 40%; top: 10%; width: 20%; height: 4.2%;">shirt</a>
		<a data-click-tag="l1_b1_txt1click.<%=G.getStatCid()%>.<%=G.getStatMid()%>" class="img-btn" href="/view/w1-1/b1" style="left: 3%; top: 17.4%; width: 42%; height: 1.55%;">shirt</a>
		<a data-click-tag="l1_b1_txt2click.<%=G.getStatCid()%>.<%=G.getStatMid()%>" class="img-btn" href="/view/w1-1/b1" style="left: 3%; top: 23.9%; width: 16%; height: 1.4%;">shirt</a>
		<button data-click-tag="l1_b1_jpglike.<%=G.getStatCid()%>.<%=G.getStatMid()%>" class="img-btn like-btn hidden" data-like-id="w1-1-b1" style="top: 15.6%;">like</button>

		<a data-click-tag="l1_b2_jpgclick.<%=G.getStatCid()%>.<%=G.getStatMid()%>" class="img-btn" href="/view/w1-1/b2" style="left: 40%; top: 28.8%; width: 20%; height: 4.2%;">jersey</a>
		<a data-click-tag="l1_b2_txt1click.<%=G.getStatCid()%>.<%=G.getStatMid()%>" class="img-btn" href="/view/w1-1/b2" style="left: 3%; top: 36.2%; width: 51%; height: 1.55%;">jersey</a>
		<a data-click-tag="l1_b2_txt2click.<%=G.getStatCid()%>.<%=G.getStatMid()%>" class="img-btn" href="/view/w1-1/b2" style="left: 3%; top: 42.6%; width: 16%; height: 1.4%;">jersey</a>
		<button data-click-tag="l1_b2_jpglike.<%=G.getStatCid()%>.<%=G.getStatMid()%>" data-click-tag="l1_b2_jpglike.<%=G.getStatCid()%>.<%=G.getStatMid()%>" class="img-btn like-btn hidden" data-like-id="w1-1-b2" style="top: 34.5%;">like</button>

		<a data-click-tag="l1_b3_jpgclick.<%=G.getStatCid()%>.<%=G.getStatMid()%>" class="img-btn" href="/view/w1-1/b3" style="left: 40%; top: 47.8%; width: 20%; height: 4.2%;">shoes</a>
		<a data-click-tag="l1_b3_txt1click.<%=G.getStatCid()%>.<%=G.getStatMid()%>" class="img-btn" href="/view/w1-1/b3" style="left: 3%; top: 55.15%; width: 44%; height: 1.55%;">shoes</a>
		<a data-click-tag="l1_b3_txt2click.<%=G.getStatCid()%>.<%=G.getStatMid()%>" class="img-btn" href="/view/w1-1/b3" style="left: 3%; top: 61.6%; width: 16%; height: 1.4%;">shoes</a>
		<button data-click-tag="l1_b3_jpglike.<%=G.getStatCid()%>.<%=G.getStatMid()%>" class="img-btn like-btn hidden" data-like-id="w1-1-b3" style="top: 53.4%;">like</button>

		<a data-click-tag="l1_b4_jpgclick.<%=G.getStatCid()%>.<%=G.getStatMid()%>" class="img-btn" href="http://mp.weixin.qq.com/s?__biz=MzA3MjU1OTAwNg==&mid=211145237&idx=1&sn=324a733248b661513cab7dca96dff048&scene=4#wechat_redirect" style="left: 40%; top: 66.6%; width: 20%; height: 4.2%;">tour</a>
		<a data-click-tag="l1_b4_txt1click.<%=G.getStatCid()%>.<%=G.getStatMid()%>" class="img-btn" href="http://mp.weixin.qq.com/s?__biz=MzA3MjU1OTAwNg==&mid=211145237&idx=1&sn=324a733248b661513cab7dca96dff048&scene=4#wechat_redirect" style="left: 3%; top: 74.1%; width: 61%; height: 1.55%;">tour</a>
		<a data-click-tag="l1_b4_txt2click.<%=G.getStatCid()%>.<%=G.getStatMid()%>" class="img-btn" href="http://mp.weixin.qq.com/s?__biz=MzA3MjU1OTAwNg==&mid=211145237&idx=1&sn=324a733248b661513cab7dca96dff048&scene=4#wechat_redirect" style="left: 3%; top: 80.5%; width: 16%; height: 1.4%;">tour</a>
		<button data-click-tag="l1_b4_jpglike.<%=G.getStatCid()%>.<%=G.getStatMid()%>" class="img-btn like-btn hidden" data-like-id="w1-1-b4" style="top: 72.4%;">like</button>

		<img class="qrcode-img" src="<%=G.CDN_BASE%>/app/zegna-201501/image/qrcode.jpg" />

		<a data-click-tag="l1_bot_locator.<%=G.getStatCid()%>.<%=G.getStatMid()%>" class="img-btn footer-l-btn" href="http://mp.weixin.qq.com/s?__biz=MzA3MjU1OTAwNg==&mid=211369012&idx=1&sn=42969187a2a93a423326e15b600ffae8#rd">shop</a>
		<a data-click-tag="l1_bot_share.<%=G.getStatCid()%>.<%=G.getStatMid()%>" class="img-btn footer-r-btn share-btn" href="javascript:void(0);">share</a>
	</div>
</div>

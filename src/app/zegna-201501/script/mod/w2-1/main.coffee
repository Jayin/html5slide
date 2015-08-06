app = require 'app'
Skateboard = require 'skateboard'
$ = require 'jquery'

class Mod extends Skateboard.BaseMod
	_bodyTpl: require './body.tpl.html'

	init: ->
		setTimeout ->
			Skateboard.core.load 'view/w2-1/b1'
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
		<img class="img-bg-img" src="<%=G.CDN_BASE%>/app/zegna-201501/image/w2-1-bg.jpg" />
		<div class="img-bg-cover"></div>

		<a data-click-tag="l1_top_wechat_open.<%=G.getStatCid()%>.<%=G.getStatMid()%>" class="img-btn header-wechat-btn" href="javascript:void(0);" style="left: 63%;top: 0.5%;">wechat</a>
		<a data-click-tag="l1_top_share.<%=G.getStatCid()%>.<%=G.getStatMid()%>" class="img-btn header-share-btn share-btn" href="javascript:void(0);" style="top: 0.5%;left: 75.4%;">share</a>
		<a data-click-tag="l1_top_locator.<%=G.getStatCid()%>.<%=G.getStatMid()%>" class="img-btn header-shop-btn" href="http://mp.weixin.qq.com/s?__biz=MzA3MjU1OTAwNg==&mid=211369012&idx=1&sn=42969187a2a93a423326e15b600ffae8#rd" style="left: 87%;top: 0.5%;">shop</a>

		<a data-click-tag="l1_b1_jpgclick.<%=G.getStatCid()%>.<%=G.getStatMid()%>" class="img-btn" href="/view/w2-1/b1" style="left: 5%; top: 11%; width: 91%; height: 11.2%;">shirt</a>
		<div data-click-tag="l1_b1_jpglike.<%=G.getStatCid()%>.<%=G.getStatMid()%>" class="img-btn like-btn hidden" data-like-id="w2-1-b1" style="top: 11.3%;">
			<div class="like alt"></div>
		</div>

		<a data-click-tag="l1_b2_jpgclick.<%=G.getStatCid()%>.<%=G.getStatMid()%>" class="img-btn" href="/view/w2-1/b1" style="left: 5%; top: 24%; width: 91%; height: 13.2%;">jersey</a>
		<div data-click-tag="l1_b2_jpglike.<%=G.getStatCid()%>.<%=G.getStatMid()%>" data-click-tag="l1_b2_jpglike.<%=G.getStatCid()%>.<%=G.getStatMid()%>" class="img-btn like-btn hidden" data-like-id="w2-1-b2" style="top: 23.5%;">
			<div class="like alt"></div>
		</div>

		<a data-click-tag="l1_b3_jpgclick.<%=G.getStatCid()%>.<%=G.getStatMid()%>" class="img-btn" href="/view/w2-1/b1" style="left: 5%; top: 38%; width: 91%; height: 22.2%;">shoes</a>
		<div data-click-tag="l1_b3_jpglike.<%=G.getStatCid()%>.<%=G.getStatMid()%>" class="img-btn like-btn hidden" data-like-id="w2-1-b3" style="top: 38.4%;">
			<div class="like alt"></div>
		</div>

		<a data-click-tag="l1_b4_jpgclick.<%=G.getStatCid()%>.<%=G.getStatMid()%>" class="img-btn" href="http://mp.weixin.qq.com/s?__biz=MjM5OTkxNDU4OA==&mid=228781007&idx=1&sn=0eaac282aa4adba63b082d6fdb21e1b1&scene=4#wechat_redirect" style="left: 5%; top: 62%; width: 91%; height: 17.2%;">tour</a>
		<div data-click-tag="l1_b4_jpglike.<%=G.getStatCid()%>.<%=G.getStatMid()%>" class="img-btn like-btn hidden" data-like-id="w2-1-b4" style="top: 60.4%;">
			<div class="like alt"></div>
		</div>

		<img class="qrcode-img" src="<%=G.CDN_BASE%>/app/zegna-201501/image/qrcode_zz.png" style="bottom: 8%;"/>

		<a data-click-tag="l1_bot_locator.<%=G.getStatCid()%>.<%=G.getStatMid()%>" class="img-btn footer-l-btn" href="http://mp.weixin.qq.com/s?__biz=MzA3MjU1OTAwNg==&mid=211369012&idx=1&sn=42969187a2a93a423326e15b600ffae8#rd">shop</a>
		<a data-click-tag="l1_bot_share.<%=G.getStatCid()%>.<%=G.getStatMid()%>" class="img-btn footer-r-btn share-btn" href="javascript:void(0);">share</a>
	</div>
</div>

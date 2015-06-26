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
		<a class="img-btn header-wechat-btn" href="javascript:void(0);">wechat</a>
		<a class="img-btn header-share-btn" href="javascript:void(0);">share</a>
		<a class="img-btn header-shop-btn" href="http://mp.weixin.qq.com/s?__biz=MzA3MjU1OTAwNg==&mid=211369012&idx=1&sn=42969187a2a93a423326e15b600ffae8#rd">shop</a>
		<a class="img-btn" href="/view/w1-1/b1" style="left: 40%; top: 10%; width: 20%; height: 4.2%;">shirt</a>
		<a class="img-btn" href="/view/w1-1/b2" style="left: 40%; top: 28.8%; width: 20%; height: 4.2%;">shoes</a>
		<a class="img-btn" href="/view/w1-1/b3" style="left: 40%; top: 47.8%; width: 20%; height: 4.2%;">shoes</a>
		<a class="img-btn" href="http://mp.weixin.qq.com/s?__biz=MzA3MjU1OTAwNg==&mid=211145237&idx=1&sn=324a733248b661513cab7dca96dff048&scene=4#wechat_redirect" style="left: 40%; top: 66.6%; width: 20%; height: 4.2%;">shoes</a>

		<a class="img-btn footer-l-btn" href="http://mp.weixin.qq.com/s?__biz=MzA3MjU1OTAwNg==&mid=211369012&idx=1&sn=42969187a2a93a423326e15b600ffae8#rd">shop</a>
		<a class="img-btn footer-r-btn" href="javascript:void(0);">share</a>
	</div>
</div>

app = require 'app'
Skateboard = require 'skateboard'
$ = require 'jquery'

class Mod extends Skateboard.BaseMod
	_bodyTpl: require './body.tpl.html'


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
		<img class="img-bg-img" src="<%=G.CDN_BASE%>/app/zegna-201501/image/w1-1-b1-bg.jpg" />
		<div class="img-bg-cover"></div>
		<a data-click-tag="l2_b1_top_back.<%=G.getStatCid()%>.<%=G.getStatMid()%>" class="img-btn header-back-btn" href="/:back">back</a>
		<a data-click-tag="l2_b1_top_save.<%=G.getStatCid()%>.<%=G.getStatMid()%>" data-id="w1-1-b1" class="img-btn header-download-btn" href="javascript:void(0);">download</a>
		<a data-click-tag="l2_b1_top_wechat_open.<%=G.getStatCid()%>.<%=G.getStatMid()%>" class="img-btn header-wechat-btn" href="javascript:void(0);">wechat</a>
		<a data-click-tag="l2_b1_top_share.<%=G.getStatCid()%>.<%=G.getStatMid()%>" class="img-btn header-share-btn share-btn" href="javascript:void(0);">share</a>
		<a data-click-tag="l2_b1_top_locator.<%=G.getStatCid()%>.<%=G.getStatMid()%>" class="img-btn header-shop-btn" href="http://mp.weixin.qq.com/s?__biz=MzA3MjU1OTAwNg==&mid=211369012&idx=1&sn=42969187a2a93a423326e15b600ffae8#rd">shop</a>
		<a data-click-tag="l2_b1_bot_locator.<%=G.getStatCid()%>.<%=G.getStatMid()%>" class="img-btn footer-c-btn" href="http://mp.weixin.qq.com/s?__biz=MzA3MjU1OTAwNg==&mid=211369012&idx=1&sn=42969187a2a93a423326e15b600ffae8#rd">shop</a>

		<img class="qrcode-img" src="<%=G.CDN_BASE%>/app/zegna-201501/image/qrcode.png" style="width: 30%;bottom: 5%;left: 35%;opacity: 0;z-index: 1500;" />
	</div>
</div>

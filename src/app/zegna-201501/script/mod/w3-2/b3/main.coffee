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
		<img class="img-bg-img" src="<%=G.CDN_BASE%>/app/zegna-201501/image/w3-1-b3-bg.jpg" />
		<div class="img-bg-cover"></div>
		<a data-click-tag="l2_b3_top_back.<%=G.getStatCid()%>.<%=G.getStatMid()%>" class="img-btn header-back-btn" href="/:back">back</a>
		<a data-click-tag="l2_b3_top_save.<%=G.getStatCid()%>.<%=G.getStatMid()%>" data-id="w3-1-b3" class="img-btn header-download-btn" href="javascript:void(0);">download</a>
		<a data-click-tag="l2_b3_top_wechat_open.<%=G.getStatCid()%>.<%=G.getStatMid()%>" class="img-btn header-wechat-btn" href="javascript:void(0);">wechat</a>
		<a data-click-tag="l2_b3_top_share_open.<%=G.getStatCid()%>.<%=G.getStatMid()%>" class="img-btn header-share-btn share-btn" href="javascript:void(0);">share</a>
		<a data-click-tag="l2_b3_top_locator.<%=G.getStatCid()%>.<%=G.getStatMid()%>" class="img-btn header-shop-btn" href="http://mp.weixin.qq.com/s?__biz=MzA3MjU1OTAwNg==&mid=211369012&idx=1&sn=42969187a2a93a423326e15b600ffae8#rd">shop</a>
		<a data-click-tag="l2_b3_bot_locator.<%=G.getStatCid()%>.<%=G.getStatMid()%>" class="img-btn footer-c-btn" href="http://mp.weixin.qq.com/s?__biz=MzA3MjU1OTAwNg==&mid=211369012&idx=1&sn=42969187a2a93a423326e15b600ffae8#rd">shop</a>
		<a data-click-tag="l2_b3_bot_locator2.<%=G.getStatCid()%>.<%=G.getStatMid()%>" class="img-btn footer-c-btn2" href="http://mp.weixin.qq.com/s?__biz=MzA3MjU1OTAwNg==&mid=211369012&idx=1&sn=42969187a2a93a423326e15b600ffae8#rd">shop</a>

		<img class="qrcode-img" src="<%=G.CDN_BASE%>/app/zegna-201501/image/qrcode_ez2.jpg" style="bottom: 4%;"/>
	</div>
</div>

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
		<img class="img-bg-img" src="<%=G.CDN_BASE%>/app/zegna-201501/image/w2-1-b1-bg.jpg" />
		<div class="img-bg-cover"></div>
		<a data-click-tag="l2_b1_top_back.<%=G.getStatCid()%>.<%=G.getStatMid()%>" class="img-btn header-back-btn" href="/:back" style="top: 0.5%;left: 2.5%;">back</a>
		<a data-click-tag="l2_b1_top_save.<%=G.getStatCid()%>.<%=G.getStatMid()%>" data-id="w2-1-b1" class="img-btn header-download-btn" href="javascript:void(0);" style="top: 0.5%;left: 51.6%;">download</a>
		<a data-click-tag="l2_b1_top_wechat_open.<%=G.getStatCid()%>.<%=G.getStatMid()%>" class="img-btn header-wechat-btn" href="javascript:void(0);" style="top: 0.5%;left: 62%;">wechat</a>
		<a data-click-tag="l2_b1_top_share_open.<%=G.getStatCid()%>.<%=G.getStatMid()%>" class="img-btn header-share-btn share-btn" href="javascript:void(0);" style="top: 0.5%;left: 75%;">share</a>
		<a data-click-tag="l2_b1_top_locator.<%=G.getStatCid()%>.<%=G.getStatMid()%>" class="img-btn header-shop-btn" href="http://mp.weixin.qq.com/s?__biz=MzA3MjU1OTAwNg==&mid=211369012&idx=1&sn=42969187a2a93a423326e15b600ffae8#rd" style="top: 0.5%;left: 87%;">shop</a>

		<a data-click-tag="l2_b1_bot_locator.<%=G.getStatCid()%>.<%=G.getStatMid()%>" class="img-btn footer-c-btn" href="http://mp.weixin.qq.com/s?__biz=MzA3MjU1OTAwNg==&mid=211369012&idx=1&sn=42969187a2a93a423326e15b600ffae8#rd" style="bottom: 1.8%;height: 3%;width: 44%;left: 4%;">shop</a>
		<a data-click-tag="l2_b1_bot_share.<%=G.getStatCid()%>.<%=G.getStatMid()%>" class="img-btn share-btn" href="javascript:void(0);" style="bottom: 1.8%;height: 3%;width: 44%;left: 52%;">shop</a>

		<img class="qrcode-img" src="<%=G.CDN_BASE%>/app/zegna-201501/image/qrcode_zz.png" style="bottom: 8%;"/>
	</div>
</div>

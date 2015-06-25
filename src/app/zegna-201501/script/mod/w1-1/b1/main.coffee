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
		<a class="img-btn header-back-btn" href="/:back">back</a>
		<a data-id="w1-1-b1" class="img-btn header-download-btn" href="javascript:void(0);">download</a>
		<a class="img-btn header-wechat-btn" href="javascript:void(0);">wechat</a>
		<a class="img-btn header-share-btn share-btn" href="javascript:void(0);">share</a>
		<a class="img-btn header-shop-btn" href="http://mp.weixin.qq.com/s?__biz=MzA3MjU1OTAwNg==&mid=211369012&idx=1&sn=42969187a2a93a423326e15b600ffae8#rd">shop</a>
		<a class="img-btn footer-c-btn" href="http://mp.weixin.qq.com/s?__biz=MzA3MjU1OTAwNg==&mid=211369012&idx=1&sn=42969187a2a93a423326e15b600ffae8#rd">shop</a>
	</div>
</div>

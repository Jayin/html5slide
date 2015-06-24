app = require 'app'
Skateboard = require 'skateboard'
$ = require 'jquery'

class Mod extends Skateboard.BaseMod
	_bodyTpl: require './body.tpl.html'

	init: ->
		setTimeout ->
			Skateboard.core.load 'view/shirt-w1/shirt'
			Skateboard.core.load 'view/shirt-w1/shoes'
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
		<img class="img-bg-img" src="<%=G.CDN_BASE%>/app/zegna-201501/image/shirt-w1-bg.jpg" />
		<div class="img-bg-cover"></div>
		<a class="img-btn" href="/view/shirt-w1/shirt" style="left: 40%; top: 10%; width: 20%; height: 4.2%;">shirt</a>
		<a class="img-btn" href="/view/shirt-w1/shoes" style="left: 40%; top: 47.8%; width: 20%; height: 4.2%;">shoes</a>
	</div>
</div>

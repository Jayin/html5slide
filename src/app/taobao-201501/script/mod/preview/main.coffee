app = require 'app'
Skateboard = require 'skateboard'

class Mod extends Skateboard.BaseMod
	cachable: true

	events:
		'click .btn-share': 'share'

	_bodyTpl: require './body.tpl.html'

	price: ''

	render: ->
		super
		@setAvatar G.state.get('avatar')
		@stateChange null, G.state.get()
		G.state.on 'change', @stateChange

	setAvatar: (avatar) ->
		if avatar.no is 5
			$('#good-avatar')[0].src = avatar.clipData
		else
			$('#good-avatar')[0].src = $('#avatar-' + avatar.no)[0].src

	setScene: (scene) ->
		$('#good-wrapper')[0].className = 'g' + scene.no
		$('#good-wrapper .good-bg-img').remove()
		require ['../buy/bg-0' + scene.no + '-main.tpl.html'], (tpl) ->
			$(tpl.render()).appendTo $('#good-wrapper')
		if scene.no is 9
			$('#good-customized-good-name').html scene.customized.goodName
			$('#good-customized-good-detail').html scene.customized.goodDetail
			@$('.customize').show()
		else
			@$('.customize').hide()

	share: =>
		if @price
			G.state.set
				price: @price
			Skateboard.core.view '/view/preview'
		else
			alert '请给宝贝定个价吧'

	stateChange: (evt, obj) =>
		@setAvatar obj.avatar if obj.avatar
		@setScene obj.scene if obj.scene
		$('#good-nick').text obj.nick if obj.nick
		$('.good-price .price').text obj.price if obj.price

	destroy: ->
		super
		G.state.off 'change', @stateChange

module.exports = Mod

__END__

@@ body.tpl.html
<%
var $ = require('jquery');
var app = require('app');
%>

<!-- include "body.scss" -->

<div class="body-inner">
	<div id="good-wrapper">
		<div class="good-price good-price--1">
			<div class="price"><%==G.state.get('price')%></div>
		</div>
		<img id="good-avatar" />
		<div id="good-nick"><%==G.state.get().nick%></div>
		<div class="customize">
			<div id="good-customized-good-name"></div>
			<div id="good-customized-good-detail"></div>
		</div>
		<div class="good-actions">
			<img src="../../../image/preview/good-action.png" />
			<a class="img-btn btn-back" href="/:back">返回</a>
			<button class="img-btn btn-share">分享</button>
		</div>
	</div>
</div>

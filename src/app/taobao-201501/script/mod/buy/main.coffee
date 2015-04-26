app = require 'app'
Skateboard = require 'skateboard'

class Mod extends Skateboard.BaseMod
	cachable: true

	events:
		'click .btn-next': 'next'
		'click .price .img-btn': 'clickPriceBtn'

	_bodyTpl: require './body.tpl.html'

	price: ''

	render: ->
		super
		@setAvatar G.state.get('avatar')
		@stateChange null, G.state.get()
		G.state.on 'change', @stateChange
		$('#customized-price').on 'focus', (evt) =>
			$(evt.target).addClass 'focus'
			@$('.price .img-btn').removeClass 'on'
		$('#customized-price').on 'change blur', (evt) =>
			target = evt.target
			target.value = target.value.trim()
			if target.value
				$(target).addClass 'focus'
			else
				$(target).removeClass 'focus'
			@price = target.value

	setAvatar: (avatar) ->
		if avatar.no is 5
			$('#price-avatar')[0].src = avatar.clipData
		else
			$('#price-avatar')[0].src = $('#avatar-' + avatar.no)[0].src

	setScene: (scene) ->
		$('#price-wrapper')[0].className = 'p' + scene.no
		$('#price-wrapper .price-bg-img').remove()
		require ['./bg-0' + scene.no + '-main.tpl.html'], (tpl) ->
			$(tpl.render()).appendTo $('#price-wrapper')
		if scene.no is 9
			$('#price-customized-good-name').html scene.customized.goodName
			$('#price-customized-good-detail').html scene.customized.goodDetail
			@$('.customize').show()
		else
			@$('.customize').hide()

	clickPriceBtn: (evt) =>
		@$('.price .img-btn').removeClass 'on'
		$(evt.target).addClass 'on'
		@price = $(evt.target).text()
		$('#customized-price').val('').removeClass 'focus'

	next: =>
		if @price
			G.state.set
				price: @price
			Skateboard.core.view '/view/preview'
		else
			alert '请给宝贝定个价吧'

	stateChange: (evt, obj) =>
		@setAvatar obj.avatar if obj.avatar
		@setScene obj.scene if obj.scene

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
	<div id="price-wrapper">
		<img id="price-avatar" />
		<div class="customize">
			<div class="customize-title">
				<img src="../../../image/price/customized-title-bg.png" />
				<div id="price-customized-good-name"></div>
			</div>
			<div id="price-customized-good-detail"></div>
		</div>
		<div class="price">
			<button class="img-btn price-btn-1">3美元</button>
			<button class="img-btn price-btn-2">打4下PP</button>
			<button class="img-btn price-btn-3">5下亲亲</button>
			<input id="customized-price" type="text" maxlength="5" />
		</div>
		<a class="img-btn btn-back" href="/:back">返回</a>
		<button class="img-btn btn-next">下一步</button>
	</div>
</div>

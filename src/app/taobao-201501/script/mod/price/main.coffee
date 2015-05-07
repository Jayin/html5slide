app = require 'app'
Skateboard = require 'skateboard'

class Mod extends Skateboard.BaseMod
	cachable: true

	events:
		'click .btn-back': 'back'
		'click .btn-next': 'next'
		'click .price .img-btn': 'clickPriceBtn'

	_bodyTpl: require './body.tpl.html'

	price: ''
	customizeNumber: 1 #自定义场景的标号

	render: ->
		super
		@setAvatar G.state.get('imgData')
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
		# preload next page
		require ['../preview/main', '../buy/bg-0' + G.state.get('scene').no + '-main.tpl.html']

	setAvatar: (imgData) ->
		$('#price-avatar')[0].src = imgData

	setScene: (scene) ->
		$('#price-wrapper')[0].className = 'p' + scene.no
		$('#price-wrapper .price-bg-img').remove()
		require ['./bg-0' + scene.no + '-main.tpl.html'], (tpl) ->
			$(tpl.render()).appendTo $('#price-wrapper')
		if scene.no is @customizeNumber
			$('#price-customized-good-name').html scene.goodName
			$('#price-customized-good-detail').html scene.goodDetail
			@$('.customize').show()
		else
			@$('.customize').hide()

	clickPriceBtn: (evt) =>
		@$('.price .img-btn').removeClass 'on'
		$(evt.target).addClass 'on'
		@price = $(evt.target).text()
		$('#customized-price').val('').removeClass 'focus'

	back: =>
		history.back()

	next: =>
		if @price
			G.state.set
				price: @price
			Skateboard.core.view '/view/preview'
			$('#audio-create')[0].play()
		else
			alert '请给宝贝定个价吧'

	stateChange: (evt, obj) =>
		@setAvatar obj.imgData if obj.imgData
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
			<div id="price-customized-good-detail" style="display: none;"></div>
		</div>
		<div class="price">
			<button class="img-btn price-btn-1">3元</button>
			<button class="img-btn price-btn-2">打4下PP</button>
			<button class="img-btn price-btn-3">5下亲亲</button>
			<input id="customized-price" type="text" maxlength="5" />
		</div>
		<button class="img-btn btn-back">返回</button>
		<button class="img-btn btn-next" onclick="G.record('4');">下一步</button>
	</div>
</div>

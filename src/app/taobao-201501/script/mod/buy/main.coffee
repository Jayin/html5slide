app = require 'app'
Skateboard = require 'skateboard'

class Mod extends Skateboard.BaseMod
	cachable: true

	_bodyTpl: require './body.tpl.html'

	render: ->
		super
		obj = G.state.get()
		@setAvatar obj.avatar if obj.avatar
		@setScene obj.scene if obj.scene
		$('#good-nick').text obj.nick if obj.nick
		$('.good-price .price').text obj.price if obj.price

	setAvatar: (avatar) ->
		if avatar.no is 1
			$('<img id="good-avatar" src="' + avatar.clipData + '" />').appendTo $('#good-wrapper')
		else
			require ['../avatar/avatar-0' + avatar.no + '-main.tpl.html'], (tpl) ->
				$(tpl.render()).appendTo $('#good-wrapper')

	setScene: (scene) ->
		$('#good-wrapper')[0].className = 'g' + scene.no
		require ['../buy/bg-0' + scene.no + '-main.tpl.html'], (tpl) ->
			$(tpl.render()).appendTo $('#good-wrapper')
		if scene.no is 9
			$('#good-customized-good-name').html scene.customized.goodName
			$('#good-customized-good-detail').html scene.customized.goodDetail
			@$('.customize').show()
		else
			@$('.customize').hide()

module.exports = Mod

__END__

@@ body.tpl.html
<!-- include "body.scss" -->

<div class="body-inner">
	<div id="good-wrapper">
		<div class="good-price good-price--1">
			<div class="price"></div>
		</div>
		<div id="good-nick"></div>
		<div class="customize">
			<div id="good-customized-good-name"></div>
			<div id="good-customized-good-detail"></div>
		</div>
		<div class="good-actions">
			<img src="../../../image/buy/good-action.png" />
			<a class="img-btn btn-go" href="/view/buy-confirm">我要下单</a>
		</div>
	</div>
</div>


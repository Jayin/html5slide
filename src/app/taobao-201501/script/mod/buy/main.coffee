app = require 'app'
Skateboard = require 'skateboard'

class Mod extends Skateboard.BaseMod
	cachable: true

	_bodyTpl: require './body.tpl.html'

	render: ->
		super
		obj = G.state.get()
		@setAvatar obj.imgRelativePath if obj.imgRelativePath
		@setScene obj.scene if obj.scene
		$('#good-nick').text obj.nick if obj.nick
		$('.good-price .price').text obj.price if obj.price
		# preload next page
		require ['../buy-confirm/main']

	setAvatar: (imgRelativePath) ->
		$('<img id="good-avatar" src="' + G.CDN_BASE + '/' + imgRelativePath + '" />').appendTo $('#good-wrapper')

	setScene: (scene) ->
		$('#good-wrapper')[0].className = 'g' + scene.no
		require ['../buy/bg-0' + scene.no + '-main.tpl.html'], (tpl) ->
			$(tpl.render()).appendTo $('#good-wrapper')
		if scene.no is 9
			$('#good-customized-good-name').text scene.goodName
			$('#good-customized-good-detail').text scene.goodDetail
			@$('.customize').show()
		else
			@$('.customize').hide()
		# preload next page
		require ['../buy-confirm/bg-0' + scene.no + '-main.tpl.html']

module.exports = Mod

__END__

@@ body.tpl.html
<!-- include "body.scss" -->

<div class="body-inner">
	<div id="good-wrapper">
		<div class="good-price good-price--2">
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


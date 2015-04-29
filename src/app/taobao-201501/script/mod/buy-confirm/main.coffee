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
		$('#buy-confirm-nick').text obj.nick if obj.nick
		@$('.buy-confirm-price').text obj.price if obj.price

	setAvatar: (imgRelativePath) ->
		$('<img id="buy-confirm-avatar" src="' + G.CDN_BASE + '/' + imgRelativePath + '" />').appendTo $('#buy-confirm-wrapper')

	setScene: (scene) ->
		$('#buy-confirm-wrapper')[0].className = 'g' + scene.no
		require ['./bg-0' + scene.no + '-main.tpl.html'], (tpl) ->
			$(tpl.render()).appendTo $('#buy-confirm-wrapper')
		if scene.no is 9
			$('#buy-confirm-customized-good-name').text scene.goodName
			$('#buy-confirm-customized-good-detail').text scene.goodDetail
			@$('.customize').show()
		else
			@$('.customize').hide()

module.exports = Mod

__END__

@@ body.tpl.html
<!-- include "body.scss" -->

<div class="body-inner">
	<div id="buy-confirm-wrapper">
		<div class="buy-confirm-price"></div>
		<div id="buy-confirm-nick"></div>
		<div class="customize">
			<img src="../../../image/buy-confirm/customized-title.png" />
			<div id="buy-confirm-customized-good-name"></div>
			<div id="buy-confirm-customized-good-detail"></div>
		</div>
	</div>
</div>


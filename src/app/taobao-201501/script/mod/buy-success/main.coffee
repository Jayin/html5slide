app = require 'app'
Skateboard = require 'skateboard'

class Mod extends Skateboard.BaseMod
	cachable: true

	events:
		'click .btn-back': 'back'
		'click .btn-share': 'showShare'

	render: ->
		designId = app.util.getUrlParam 'designId'
		@dataPromise = app.ajax.get
			url: 'web/taobao/design/' + designId
			success: (res) =>
				if res.code is 0
					obj = res.data
					G.state.set obj
					@setAvatar obj.imgRelativePath
					@setScene obj.scene
					$('#buy-success-nick').text obj.nick
					@$('.buy-success-price').text (obj.buyPrice || obj.price)
				else
					alert res.code + ': ' + res.msg
				G.hideLoading();
			error: ->
				alert '系统繁忙，请您稍后重试。'
				G.hideLoading();
		# preload next page
		require ['../buy/main']

	setAvatar: (imgRelativePath) ->
		$('<img id="buy-success-avatar" src="' + G.CDN_BASE + '/' + imgRelativePath + '" />').appendTo $('#buy-success-wrapper')

	setScene: (scene) ->
		$('#buy-success-wrapper')[0].className = 'g' + scene.no
		require ['./bg-0' + scene.no + '-main.tpl.html'], (tpl) ->
			$(tpl.render()).appendTo $('#buy-success-wrapper')
		if scene.no is 9
			$('#buy-success-customized-good-name').text scene.goodName
			$('#buy-success-customized-good-detail').text scene.goodDetail
			@$('.customize').show()
		else
			@$('.customize').hide()

	showShare: =>
		@$('.share-instruction').removeClass('singlemessage').fadeIn()

	closeShare: =>
		@$('.share-instruction').fadeOut()

	back: =>
		history.back()

module.exports = Mod


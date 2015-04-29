app = require 'app'
Skateboard = require 'skateboard'

class Mod extends Skateboard.BaseMod
	cachable: true

	events:
		'click .btn-back': 'back'
		'click .btn-share': 'showShare'
		'click .btn-close': 'closeShare'

	render: ->
		designId = app.util.getUrlParam 'designId'
		app.ajax.get
			url: 'web/taobao/design/' + designId
			success: (res) =>
				if res.code is 0
					obj = res.data
					@setAvatar obj.imgRelativePath if obj.imgRelativePath
					@setScene obj.scene if obj.scene
					$('#good-nick').text obj.nick if obj.nick
					$('.good-price .price').text obj.price if obj.price
				else
					alert res.code + ': ' + res.msg
				G.hideLoading()
			error: ->
				alert '系统繁忙，请您稍后重试。'
				G.hideLoading()

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

	showShare: =>
		@$('.share-instruction').removeClass('singlemessage').fadeIn()

	closeShare: =>
		@$('.share-instruction').fadeOut()

	back: =>
		history.back()

module.exports = Mod

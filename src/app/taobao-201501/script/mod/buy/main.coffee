app = require 'app'
Skateboard = require 'skateboard'

class Mod extends Skateboard.BaseMod
	cachable: true

	events:
		'click .mom-open__open-btn': 'openPackage'

	render: ->
		titleNo = Math.ceil Math.random() * 4
		$('#mo-title-' + (titleNo || 1)).show();
		setTimeout =>
			@$('.body-inner').removeClass 'off'
			G.hideLoading();
		, 0
		designId = app.util.getUrlParam 'designId'
		@dataPromise = app.ajax.get
			url: 'web/taobao/design/' + designId
			success: (res) =>
				if res.code is 0
					obj = res.data
					G.state.set obj
					@setAvatar obj.imgRelativePath if obj.imgRelativePath
					@setScene obj.scene if obj.scene
					$('#good-nick').text obj.nick if obj.nick
					$('.good-price .price').text obj.price if obj.price
				else
					alert res.code + ': ' + res.msg
			error: ->
				alert '系统繁忙，请您稍后重试。'
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

	openPackage: =>
		@$('.mom-open').fadeOut()

module.exports = Mod

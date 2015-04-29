app = require 'app'
Skateboard = require 'skateboard'

class Mod extends Skateboard.BaseMod
	cachable: true

	events:
		'click .open-btn': 'open'

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
					# preload next page
					require ['../buy/bg-0' + obj.scene.no + '-main.tpl.html']
				else
					alert res.code + ': ' + res.msg
			error: ->
				alert '系统繁忙，请您稍后重试。'
		# preload next page
		require ['../buy/main']

	open: =>
		@dataPromise.success ->
			if G.state.get 'buyPrice'
				designId = app.util.getUrlParam 'designId'
				location.href = "buy-success.html?designId=#{designId}"
			else
				Skateboard.core.view '/view/buy'

module.exports = Mod

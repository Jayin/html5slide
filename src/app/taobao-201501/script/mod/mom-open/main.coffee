app = require 'app'
Skateboard = require 'skateboard'

class Mod extends Skateboard.BaseMod
	cachable: true

	events:
		'click .open-btn': 'open'

	_bodyTpl: require './body.tpl.html'

	render: ->
		super
		titleNo = Math.ceil Math.random() * 4
		$('#mo-title-' + (titleNo || 1)).show();
		setTimeout =>
			@$('.body-inner').removeClass 'off'
		, 1000
		designId = app.util.getUrlParam 'designId'
		@dataPromise = app.ajax.get
			url: 'web/taobao/design/' + designId
			success: (res) =>
				if res.code is 0
					obj = res.data
					G.state.set obj
					if obj.avatar.no isnt 5
						# preload next page
						require ['../buy/avatar-0' + obj.avatar.no + '-main.tpl.html']
					if obj.scene.no isnt 9
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
			Skateboard.core.view '/view/buy'

module.exports = Mod

__END__

@@ body.tpl.html
<!-- include "body.scss" -->

<div class="body-inner off">
	<div class="title">
		<img id="mo-title-1" src="../../../image/mom-open/title-01.png" />
		<img id="mo-title-2" src="../../../image/mom-open/title-02.png" />
		<img id="mo-title-3" src="../../../image/mom-open/title-03.png" />
		<img id="mo-title-4" src="../../../image/mom-open/title-04.png" />
	</div>
	<div class="express">
		<img src="../../../image/mom-open/express.png" />
	</div>
	<button class="img-btn open-btn">go</button>
</div>

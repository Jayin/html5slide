app = require 'app'
Skateboard = require 'skateboard'
Hammer = require 'hammer'

class Mod extends Skateboard.BaseMod
	cachable: true

	confirm_time: 0
	Interval: 300
	isCounting: false

	events:
		'click .btn-next': 'jump'

	_bodyTpl: require './body.tpl.html'

	render: ->
		super
		hm = new Hammer(document.getElementById('comfirm-btn-press'))
		hm.on 'press', @pressStart
		hm.on 'pressup', @pressEnd

		# preload next page
		require ['../congratulation/main']


	comfirm: =>
		Skateboard.core.view '/view/congratulation'

	pressStart: =>
		@confirm_time = (new Date).getTime()
		@isCounting = true
		# $('#comfrim-line').addClass('action')
		setTimeout ()=>
			cur_time = (new Date).getTime()
			if cur_time - @confirm_time > @Interval - 50 and @isCounting
				@comfirm()
		,@Interval

	pressEnd: =>
		@isCounting = false
		# $('#comfrim-line').removeClass('action')




module.exports = Mod

__END__

@@ body.tpl.html

<!-- include "animate.css" -->
<!-- include "body.scss" -->

<div class="body-inner">
	<img class="comfirm-circle" src="../../../image/circle.png" height="37" width="318" alt="">
	<img id="comfrim-line" class="scan-line action" src="../../../image/line.png" height="37" width="318" alt="">
	<div id="comfirm-btn-press"></div>
</div>

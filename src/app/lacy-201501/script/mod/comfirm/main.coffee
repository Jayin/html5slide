app = require 'app'
Skateboard = require 'skateboard'
Hammer = require 'hammer'

class Mod extends Skateboard.BaseMod
	cachable: true

	confirm_time: 0
	Interval: 200
	isCounting: false

	events:
		'click .btn-next': 'jump'

	_bodyTpl: require './body.tpl.html'

	render: ->
		super
		hm = new Hammer(document.getElementById('comfirm-btn-press'))
		hm.on 'press', @pressStart
		hm.on 'pressup', @pressEnd


	comfirm: =>
		Skateboard.core.view '/view/congratulation'

	pressStart: =>
		@confirm_time = (new Date).getTime()
		@isCounting = true
		setTimeout ()=>
			cur_time = (new Date).getTime()
			if cur_time - @confirm_time > @Interval - 50 and @isCounting
				@comfirm()
		,@Interval

	pressEnd: =>
		@isCounting = false




module.exports = Mod

__END__

@@ body.tpl.html

<!-- include "body.scss" -->

<div class="body-inner">
	<div id="comfirm-btn-press"></div>
</div>

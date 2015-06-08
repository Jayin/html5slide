app = require 'app'
Skateboard = require 'skateboard'

class Mod extends Skateboard.BaseMod
	cachable: true

	events:
		'click .btn-next': 'jump'

	_bodyTpl: require './body.tpl.html'

	cur: 0

	init: (total=360)=>
		frag = $(document.createDocumentFragment())
		r = 60
		step = 5
		i = undefined
		x = undefined
		y = undefined
		point = undefined
		i = 0
		while i < total
			if i <= @cur
				point = $('<div class="point-hightline"></div>')
			else
				point = $('<div class="point"></div>')
			x = Math.sin(i / 180 * Math.PI) * r
			y = Math.sqrt(r * r - (x * x))
			if i<90 or i>270
				y = -y
			# fix 180deg in android browser
			if i == 180
				x = 0
				y = r

			point.css transform: 'translate(' + x + 'px, ' + y + 'px) rotate(' + i + 'deg)'
			point.appendTo frag
			i += step
		frag.appendTo $('.box')
		# number
		percent = Math.round(@cur / 360 * 100)
		if percent >= 100
			$('#home-text-number').text(99)
		else
			if percent < 10
				$('#home-text-number').text('0' + percent)
			else
				$('#home-text-number').text(percent)

	handleFinish:=>
		Skateboard.core.view '/view/comfirm'

	update: =>
		@init()
		@cur += 20
		if @cur == 360
			@init()
			setTimeout ()=>
				@handleFinish()
			,400
		else
			setTimeout @update, 100


	render: =>
		super
		G.state.set({'first':true})
		@update()
		# preload next
		require ['../comfirm/main']


module.exports = Mod

__END__

@@ body.tpl.html

<!-- include "body.scss" -->

<div class="body-inner">
	<div class="box">
	<div style="font-size: 4rem;color: white;position: relative;top: 15%;left: 20%;">
		<span id="home-text-number">00</span>
	</div>
	</div>
</div>

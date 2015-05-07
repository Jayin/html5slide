app = require 'app'
Skateboard = require 'skateboard'

class Mod extends Skateboard.BaseMod
	cachable: true

	events:
		'click .btn-go': 'next'

	render: ->
		# if G.goClicked
		# 	@showDialog()
		# 	G.goClicked = false
		# require ['./dialog-main'], (dialog) =>
		# 	dialog.on 'confirm', @confirm
		$audio = $('#audio-bg')[0]

		if $('#audio-btn').hasClass('on')
			$audio.play()

		# preload next page
		require ['../avatar/main']

	showDialog: =>
		require ['./dialog-main'], (dialog) ->
			dialog.show()
	next: =>
		G.state.set
			nick: 'xxx'
		Skateboard.core.view '/view/avatar'

	confirm: (evt, nick) =>
		G.state.set
			nick: nick
		Skateboard.core.view '/view/avatar'

module.exports = Mod

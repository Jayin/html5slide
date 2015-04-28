app = require 'app'
Skateboard = require 'skateboard'

class Mod extends Skateboard.BaseMod
	cachable: true

	events:
		'click .btn-go': 'showDialog'

	render: ->
		if G.goClicked
			@showDialog()
			G.goClicked = false
		require ['./dialog-main'], (dialog) =>
			dialog.on 'confirm', @confirm
		# preload next page
		require ['../avatar/main']

	showDialog: =>
		require ['./dialog-main'], (dialog) ->
			dialog.show()

	confirm: (evt, nick) =>
		G.state.set
			nick: nick
		Skateboard.core.view '/view/avatar'

module.exports = Mod

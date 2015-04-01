app = require 'app'
Skateboard = require 'skateboard'

class Mod extends Skateboard.BaseMod
	cachable: true

	_bodyTpl: require './body.tpl.html'

	_render: ->
		super
		require ['../canvas/main'], (CanvasMod) =>
			$(CanvasMod).on 'clipchange', @clipChange
			@resetClipData CanvasMod.clipData

	clipChange: (evt, clipData) =>
		@resetClipData clipData

	resetClipData: (clipData) ->
		@$('.preview').html '<img src="' + clipData + '" />'

module.exports = Mod

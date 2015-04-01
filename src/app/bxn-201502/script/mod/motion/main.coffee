app = require 'app'
BaseMod = require 'skateboard/base-mod'

class Mod extends BaseMod
	cachable: true

	_bodyTpl: require './body.tpl.html'

	_render: ->
		super
		require ['../canvas/main'], (CanvasMod) =>
			@$('.preview').html '<img src="' + CanvasMod.clipData + '" />'

module.exports = Mod

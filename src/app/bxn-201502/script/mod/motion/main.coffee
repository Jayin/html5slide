## @jsx #
React = require 'react'
app = require 'app'
Skateboard = require 'skateboard'
Preview = require './preview'

class Mod extends Skateboard.BaseMod
	cachable: true
	parentModNames:
		'home': 1
		'canvas': 1

	_bodyTpl: require './body.tpl.html'

	_render: ->
		super
		React.render <Preview />, @$('.body-inner')[0]

module.exports = Mod

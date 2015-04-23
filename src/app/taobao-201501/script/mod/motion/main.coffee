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

	render: ->
		React.render <Preview />, @$('.sb-mod__body')[0]

module.exports = Mod

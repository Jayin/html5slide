app = require 'app'
Skateboard = require 'skateboard'
$ = require 'jquery'
React = require 'react'
Container = require './component/Container'

class Mod extends Skateboard.BaseMod

	_afterFadeIn: ->
		scenic = G.state.get('scenic')
		React.render(
			React.createElement(Container, {scenic: scenic, currentPosition: G.state.get('currentPosition')}),
			@$('.sb-mod__body')[0]
		)

	render: ->
		super




module.exports = Mod

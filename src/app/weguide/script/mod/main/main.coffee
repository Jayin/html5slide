app = require 'app'
Skateboard = require 'skateboard'
$ = require 'jquery'
React = require 'react'
Container = require './component/Container'

class Mod extends Skateboard.BaseMod
	_bodyTpl: require './body.tpl.html'

	_afterFadeIn: ->
		scenic = G.state.get('scenic')
		React.render(
			React.createElement(Container, {scenic: scenic, currentPosition: G.state.get('currentPosition')}),
			@$('.body-inner')[0]
		)

	render: ->
		super




module.exports = Mod

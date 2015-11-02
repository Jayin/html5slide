app = require 'app'
Skateboard = require 'skateboard'
React = require 'react'
TagList = require '../../components/TagList/main'

class Mod extends Skateboard.BaseMod
	cachable: true


	_bodyTpl: require './body.tpl.html'

	udpateCotegory: =>
		app.ajax.get
			url: 'Data/Tag/2'
			success: (res)=>
				React.render(
					React.createElement(TagList, {jstreeContainerId: 'lowPressure-jstree-container', result: res, close: true}),
					document.getElementById('lowPressure-container')
				)
			error: ()->
				app.alerts.alert '系统繁忙，请稍后再试'

	_afterFadeIn: =>
		@udpateCotegory()

	_afterFadeOut: =>

	render: =>
		super

		@udpateCotegory()


module.exports = Mod

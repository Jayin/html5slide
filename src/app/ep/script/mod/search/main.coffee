app = require 'app'
Skateboard = require 'skateboard'
React = require 'react'
SearchList = require '../../components/SearchList/main'

class Mod extends Skateboard.BaseMod
	cachable: true

	_bodyTpl: require './body.tpl.html'

	search: (name)=>
		app.ajax.get
			url: 'Data/Search/' + name
			success: (res)=>
				# @transformSearchList(res)
				React.render(
					React.createElement(SearchList, {result: res, jstreeContainerId: 'search-jstree-container'}),
					document.getElementById('search-container')
				)
			error: ()->
				app.alerts.alert '系统繁忙，请稍后再试'



	_afterFadeIn: =>
		if G.state.get('search')
			@search(G.state.get('search'))

	_afterFadeOut: =>


	stateChange: =>
		if G.state.get('search')
			@search(G.state.get('search'))

	render: =>
		super
		G.state.on 'change', @stateChange

	destroy: =>
		G.state.off 'change', @stateChange



module.exports = Mod



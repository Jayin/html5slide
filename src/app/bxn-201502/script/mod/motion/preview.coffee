## @jsx #
React = require 'react'
bodyStyle = require './body.css'

Preview = React.createClass
	getInitialState: ->
		clipData: 'about:blank'

	componentDidMount: ->
		require ['../canvas/main'], (CanvasMod) =>
			$(CanvasMod).on 'clipchange', (evt, clipData) =>
				@setState clipData: clipData
			@setState clipData: CanvasMod.clipData

	render: ->
		<div className="body-inner">
			<style type="text/css">
				{bodyStyle.render()}
			</style>
			<div className="preview">
				<img src={@state.clipData} />
			</div>
		</div>

module.exports = Preview

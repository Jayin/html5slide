## @jsx #
React = require 'react'

Preview = React.createClass
	getInitialState: ->
		clipData: 'about:blank'

	componentDidMount: ->
		require ['../canvas/main'], (CanvasMod) =>
			$(CanvasMod).on 'clipchange', (evt, clipData) =>
				@setState clipData: clipData
			@setState clipData: CanvasMod.clipData

	render: ->
		<div className="preview">
			<img src={@state.clipData} />
		</div>

module.exports = Preview

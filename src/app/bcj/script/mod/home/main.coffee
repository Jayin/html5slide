define (require, exports, module)=>
	React = require 'react'
	MainPage = require './components/MainPage/main'

	React.render(
		React.createElement(MainPage, {}),
		document.getElementById('container')
	)

	return {}

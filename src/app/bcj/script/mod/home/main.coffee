app = require 'app'
Skateboard = require 'skateboard'
$ = require 'jquery'
React = require 'react'
Navigator = require './components/Navigator/main'
Carousel = require './components/Carousel/main'
ProductList = require './components/ProductList/main'

class Mod extends Skateboard.BaseMod
	_bodyTpl: require './body.tpl.html'


	render: ->
		super

		React.render(
			React.createElement(Navigator, {}),
			document.getElementById('container-navigator')
		)
		React.render(
			React.createElement(Carousel, {}),
			document.getElementById('container-carousel')
		)
		React.render(
			React.createElement(ProductList, {}),
			document.getElementById('container-productlist')
		)

		$(window).on 'scroll', ()->
			$('#container-navigator').css("top",$(window)[0].scrollY)




module.exports = Mod

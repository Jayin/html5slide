app = require 'app'
Skateboard = require 'skateboard'
$ = require 'jquery'
require('jstree')

class Mod extends Skateboard.BaseMod
	cachable: true

	# events:
	# 	'click #btn-submit': 'submit'
	# 	'click #btn-register': 'register'
	#

	_bodyTpl: require './body.tpl.html'



	_afterFadeIn: =>

	_afterFadeOut: =>

	render: =>
		super


module.exports = Mod



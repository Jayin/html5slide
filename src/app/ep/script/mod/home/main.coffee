app = require 'app'
Skateboard = require 'skateboard'
$ = require 'jquery'
React = require('react')
CompanyList = require('../../components/CompanyList/main')

class Mod extends Skateboard.BaseMod
	cachable: true

	# events:
	# 	'click #btn-submit': 'submit'
	# 	'click #btn-register': 'register'

	_bodyTpl: require './body.tpl.html'

	render: =>
		super
		companys = [
			{Name: "CA"},
			{Name: "CA1"},
			{Name: "CA2"},
			{Name: "CA3"}
		]
		React.render(
			React.createElement(CompanyList, {companys: companys}),
			document.getElementById('home-company-list')
		)




module.exports = Mod



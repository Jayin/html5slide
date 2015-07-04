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
	#
	companys: []

	_bodyTpl: require './body.tpl.html'


	# 获得公司列表
	getComanyList: =>
		app.ajax.get
			url: 'Data/Company'
			success: (res)=>
				console.log res
				React.render(
					React.createElement(CompanyList, {result: res}),
					document.getElementById('home-company-list')
				)
			error: ()->
				app.alerts.alert '系统繁忙，请稍后再试'

	transformSearchList: (result)=>
		@companys = result.Companies;

	_afterFadeIn: =>
		$('.side-words').css('display','block')

	_afterFadeOut: =>
		$('.side-words').css('display','none')

	render: =>
		super
		@getComanyList()



module.exports = Mod



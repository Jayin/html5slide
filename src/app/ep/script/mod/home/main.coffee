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

	#转换首页全部公司的数据
	transformCompanyList: (companys)=>
		companys.forEach (node)=>
			@companys = @companys.concat(node.Children)

		return @companys

	_afterFadeIn: =>
		# console.log('_afterFadeIn')
		# if G.state.get('search')
		# 	alert(1)

	render: =>
		super

		app.ajax.get
			url: 'Data/Company'
			success: (res)=>
				console.log(res)
				@transformCompanyList(res)
				React.render(
					React.createElement(CompanyList, {companys: @companys}),
					document.getElementById('home-company-list')
				)
			error: ()->
				app.alerts.alert '系统繁忙，请稍后再试'




module.exports = Mod



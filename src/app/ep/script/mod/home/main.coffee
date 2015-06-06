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

	# 获得公司列表
	getComanyList: =>
		app.ajax.get
			url: 'Data/Company'
			success: (res)=>
				@transformCompanyList(res)
				React.render(
					React.createElement(CompanyList, {companys: @companys}),
					document.getElementById('home-company-list')
				)
			error: ()->
				app.alerts.alert '系统繁忙，请稍后再试'

	transformSearchList: (result)=>
		@companys = result.Companies;

	# 搜索
	searchCompany: (name)=>
		app.ajax.get
			url: 'Data/Search/' + name
			success: (res)=>
				@transformSearchList(res)
				React.render(
					React.createElement(CompanyList, {companys: @companys}),
					document.getElementById('home-company-list')
				)
			error: ()->
				app.alerts.alert '系统繁忙，请稍后再试'

	stateChange: =>
		if G.state.get('search')
			@searchCompany(G.state.get('search'))

	render: =>
		super
		@getComanyList()

		G.state.on 'change', @stateChange


	destroy: =>
		G.state.off 'change', @stateChange


module.exports = Mod



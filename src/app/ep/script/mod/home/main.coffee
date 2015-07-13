app = require 'app'
Skateboard = require 'skateboard'
$ = require 'jquery'
React = require('react')
CompanyList = require('../../components/CompanyList/main')
LetterList = require('../../components/LetterList/main')

class Mod extends Skateboard.BaseMod
	cachable: true

	# events:
	# 	'click #btn-submit': 'submit'
	# 	'click #btn-register': 'register'
	#
	companys: []

	_bodyTpl: require './body.tpl.html'

	letters: []


	getLetters: (res)=>
		tmp = []
		res.forEach (ele)=>
			if ele.Name != ''
				tmp.push(ele.Name)
		return tmp

	# 获得公司列表
	getComanyList: =>
		app.ajax.get
			url: 'Data/Company'
			success: (res)=>
				React.render(
					React.createElement(CompanyList, {result: res}),
					document.getElementById('home-company-list')
				)
				@letters = []
				tmp = @getLetters(res)
				i = 0
				while i < (26 - tmp.length) / 2
					@letters.push('')
					i++

				@letters = @letters.concat tmp

				React.render(
					React.createElement(LetterList, {visitable: true, letters: @letters}),
					document.getElementById('letters-container')
				)
			error: ()->
				app.alerts.alert '系统繁忙，请稍后再试'

	transformSearchList: (result)=>
		@companys = result.Companies;

	_afterFadeIn: =>
		React.render(
			React.createElement(LetterList, {visitable: true, letters: @letters}),
			document.getElementById('letters-container')
		)

	_afterFadeOut: =>
		React.render(
			React.createElement(LetterList, {visitable: false, letters: @letters}),
			document.getElementById('letters-container')
		)

	render: =>
		super
		@getComanyList()



module.exports = Mod



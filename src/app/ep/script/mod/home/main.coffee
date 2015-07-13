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
	IS_IN_HOME_PAGE: true #由于切换时会scroll 因此用个变量来控制是否


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
					React.createElement(LetterList, {visitable: @isLetterListVisablable(), letters: @letters}),
					document.getElementById('letters-container')
				)
			error: ()->
				app.alerts.alert '系统繁忙，请稍后再试'

	transformSearchList: (result)=>
		@companys = result.Companies;

	isLetterListVisablable: ()=>
		$supportList = $('.invisitable').parent()
		# 无推荐
		if $supportList.length <= 0
			return true

		#1推荐列表高度<可视屏幕 2. 滑动的高度> 推荐列表超出可视区域的高度

		# 中间可视部分的高度
		midHeight = window.screen.availHeight - $('.bar-top-search').height() - $('.bar-bottom').height()
		# 推荐列表高度 > 可视高度 则不显示
		# if $supportList.height() > midHeight
		# 	return false
		# 推荐列表超出可视区域的高度 > 如果滑动的高度 >  则不显示
		if $supportList.height() - midHeight > $(window).scrollTop()
			return false
		return true

	_afterFadeIn: =>
		@IS_IN_HOME_PAGE = true
		@updateLetterList()
		# React.render(
		# 	React.createElement(LetterList, {visitable: @isLetterListVisablable(), letters: @letters}),
		# 	document.getElementById('letters-container')
		# )

	_afterFadeOut: =>
		@IS_IN_HOME_PAGE = false
		React.render(
			React.createElement(LetterList, {visitable: false, letters: @letters}),
			document.getElementById('letters-container')
		)

	updateLetterList: =>
		React.render(
			React.createElement(LetterList, {visitable: @isLetterListVisablable(), letters: @letters}),
			document.getElementById('letters-container')
		)
	render: =>
		super
		@getComanyList()
		$(window).scroll ()=>
			if @IS_IN_HOME_PAGE
				@updateLetterList()



module.exports = Mod



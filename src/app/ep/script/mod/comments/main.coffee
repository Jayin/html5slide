app = require 'app'
Skateboard = require 'skateboard'
React = require 'react'
SystemMessageList = require '../../components/SystemMessageList/main'
$ = require 'jquery'
utils = require '../../utils'

class Mod extends Skateboard.BaseMod
	cachable: true

	# events:
	# 	'click #btn-submit': 'submit'
	# 	'click #btn-register': 'register'
	#

	_bodyTpl: require './body.tpl.html'

	preMessage: '' #前一条留言
	lastPostTime: 0 # 最后一次留言时间
	pageIndex: 1 #当前页


	unresize: ()=>
		$('.page-wrapper').css('height', '')
		$('.page-wrapper').css('min-height', '100%');

	resize: ()=>
		wrapper_height = $(window).height() - $('.bar-bottom').height() - $('.bar-top-search').height()
		$('.page-wrapper').height(wrapper_height)
		$('.page-wrapper').css('min-height', '0%')
		$('#comments-container-commentsList').height(wrapper_height - $('.comments-options').height())

	update: (pageIndex = 1, pageSize = 40)=>
		@resize()
		if pageIndex <= 0
			pageIndex = 1
		@pageIndex = pageIndex
		$('.sb-mod--comments .pages currentPage').text(pageIndex)
		app.ajax.get
			url: "Data/CategoryNote/-1?pageIndex=#{pageIndex}&pageSize=#{pageSize}"
			success: (res)=>
				React.render(
					React.createElement(SystemMessageList, {result: res}),
					document.getElementById('comments-container-commentsList')
				)
				$('.sb-mod--comments .pages .totalPage').text(res.Count)
				# 数据更新后滚动到顶部
				$('#comments-container-commentsList').scrollTop(0)
				$('body').scrollTop(0)

			error: =>
				app.alerts.alert '系统繁忙，请稍后再试', 'info', 1000

	postMessage: ()=>
		$input = $('.sb-mod--comments input')
		# 发送间隔1秒限制
		if Date.now - @lastPostTime <= 1000
			app.alerts.alert '留言太快了，请休息一会儿再来', 'info', 1000
			return
		if $input.val() == ''
			app.alerts.alert '留言不能为空', 'info', 1000
			return
		if $input.val() == @preMessage
			app.alerts.alert '留言不能与上条相同', 'info', 1000
			return
		if utils.isAllNumber($input.val()) or utils.isAllLetter($input.val())
			app.alerts.alert '留言不能全为英文、数字', 'info', 1000
			return
		app.ajax.post
			url: '/Data/CategoryNote/-1'
			data:
				note: $input.val()
			success: (res)=>
				# {
					# result: true
					# message: ""
				# }

				if res.result
					app.alerts.alert '留言成功' , 'info', 1000
					@preMessage = $input.val('')
					@lastPostTime = Date.now
					$input.val('')
					# 发送后更新列表
					@update(@pageIndex)
				else
					app.alerts.alert res.message, 'info', 1000
			error: =>
				app.alerts.alert '系统繁忙，请稍后再试', 'info', 1000


	_afterFadeIn: =>
		@update()

	_afterFadeOut: =>
		@unresize()

	render: =>
		super

		$('.sb-mod--comments .btn-left-message').on 'click', ()=>
			@postMessage()

		$('.sb-mod--comments .btn-refresh').on 'click', ()=>
			page = parseInt($('.sb-mod--comments .pages .currentPage').text())
			@update(page)

		$('.sb-mod--comments .btn-pre').on 'click', ()=>
			page = parseInt($('.sb-mod--comments .pages .currentPage').text())
			@update(page - 1)

		$('.sb-mod--comments .btn-next').on 'click', ()=>
			page = parseInt($('.sb-mod--comments .pages .currentPage').text())
			total = parseInt($('.sb-mod--comments .pages .totalPage').text())
			if page + 1 > total
				app.alerts.alert '没有下一页了', 'info', 1000
				return
			@update(page + 1)

		$('.left-message input').on 'focus', ()->
			$(this).css('width', '90%')

		$('.left-message input').on 'blur', ()->
			$(this).css('width', '50%')


module.exports = Mod



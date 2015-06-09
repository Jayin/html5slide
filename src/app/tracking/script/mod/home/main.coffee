app = require 'app'
Skateboard = require 'skateboard'
$ = require 'jquery'

class Mod extends Skateboard.BaseMod
	cachable: true

	$username: null
	$password: null

	events:
		'click #btn-submit': 'submit'
		'click #btn-register': 'register'

	_bodyTpl: require './body.tpl.html'

	render: =>
		super
		@$username = $('.sb-mod--home #input-username')[0]
		@$password = $('.sb-mod--home #input-password')[0]

	submit: =>
		# TODO 登陆
		if @$username.value == '' or @$password.value == ''
			app.alerts.alert 'Please input username and password'
			return
		data = {}
		# data.username = @$username.value
		# data.password = @$password.value
		data.username = @$username.value
		data.password = @$password.value

		app.ajax.post
			url: 'tracking/j_spring_security_check.json'
			data: data
			notJsonParamData: true
			success: (res)=>
				# TODO switch to dashboard
				if res.code is 0
					app.alerts.alert '登陆成功'
					setTimeout ()->
						# redirect to where you visited
						if G.urlObj.search.redirectURL
							window.location.href =  decodeURIComponent(G.urlObj.search.redirectURL)
						else
							window.location.href =  'dashboard.html'
					,1000
				else
					app.alerts.alert 'Error code:' + res.code
			error: (res)=>
				app.alerts.alert '系统繁忙，请您稍后重试'

	register: =>
		# 注册
		app.alerts.alert '未开放注册'

module.exports = Mod



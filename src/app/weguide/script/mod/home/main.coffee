app = require 'app'
Skateboard = require 'skateboard'
$ = require 'jquery'

class Mod extends Skateboard.BaseMod
	_bodyTpl: require './body.tpl.html'

	TEXT_LOADING: '正在搜索离你最近的景区..'
	TEXT_NOMAL: '摇一摇，要出现场的导游来'

	success: (position)=>
		console.log position
		latitude = position.coords.latitude; # 纬度
		longitude = position.coords.longitude; # 经度
		G.state.set {currentPosition: {latitude: latitude, longitude: longitude}}

		# app.alerts.alert 'latitude'+latitude+'longitude'+longitude
		app.ajax.get
			url : "/Api/Scenic/search?longitude=#{longitude}&latitude=#{latitude}"
			success: (res)=>
				if res.code == 20000
						G.state.set
							scenic : res.response
						Skateboard.core.view 'view/main'
				else
					app.alerts.alert res.msg

			error: ()->
				app.alerts.alert '网络繁忙，请稍后再试'



	error: =>
		app.alerts.alert '获取地理位置失败'


	render: ->
		super

		$('.sb-mod--home p')[0].innerText = @TEXT_LOADING
		if G.IS_PROTOTYPE
			setTimeout @success.bind(this, {coords: {latitude: 22.5985796354, longitude: 113.0882406235}}), 1300
		else
			# setTimeout @success.bind(this, {coords: {latitude: 22.5985796354, longitude: 113.0882406235}}), 1300
			navigator.geolocation.getCurrentPosition @success, @error


module.exports = Mod

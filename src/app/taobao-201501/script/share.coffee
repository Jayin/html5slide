require ['jquery', 'app', 'http://res.wx.qq.com/open/js/jweixin-1.0.0.js'], ($, app, wx) ->
	getShareMessage = ->
		page = location.pathname.split('/').pop().split('.')[0]
		defaultMsg = '把自己打包成宝贝，发给老妈下单！'
		if page is 'index'
			defaultMsg
		else if page is 'share'
			scene = G.state.get 'scene'
			if scene
				nick = G.state.get 'nick'
				if nick
					msg = [
						"不服来战！#{nick}化身防隔壁王姨勾搭老爸特工队，成功歼灭围绕在粑粑身边的奇怪生物！",
						"起来嗨！#{nick}化身老爸私房钱探测器，帮麻麻搜寻到粑粑深藏在袜子里的300元！",
						"天哪噜！#{nick}化身逢把必自摸的雀神之手，帮麻麻连胡88把！",
						"什么鬼！#{nick}化身广场舞量贩式点歌机，老妈跳的根本停不下来啦！",
						"你能信！#{nick}化身花不完的支付宝，一次性清空了麻麻的购物车！",
						"给跪了！#{nick}化身时尚时尚最时尚的焕新机，让麻麻成功踏向巴黎时装周！"
					][scene.no - 2]
					if msg
						msg
					else
						"我的天！#{nick}变成宝贝上！架！了！"
				else
					defaultMsg
		else
			scene = G.state.get 'scene'
			if scene
				goodName = [
					'防隔壁王姨勾搭老爸特工队'
					'老爸私房钱探测器'
					'逢把必自摸的雀神之手'
					'广场舞量贩式点歌机'
					'花不完的支付宝'
					'时尚时尚最时尚的焕新机'
				][scene.no - 2]
				if goodName
					"我的宝贝化身为#{goodName}，我已迅速下单带回家！"
				else
					nick = G.state.get 'nick'
					if nick
						"我的天！#{nick}变成宝贝上！架！了！"
					else
						defaultMsg
			else
				defaultMsg

	getShareIcon = ->
		if G.state.get 'imgShareRelativePath'
			return G.CDN_ORIGIN + "/" + G.state.get 'imgShareRelativePath'
		else
			return G.CDN_ORIGIN + "/static/app/taobao-201501/image/home/head.png"


	shareUrl = location.href.split('#')[0]
	app.ajax.post
		url: 'web/sharing/signWxshare/tao1b82a58f24d7d16c11e16',
		data:
			url: shareUrl
		success: (res) ->
			wx.config
				debug: false
				appId: res.data.appId
				timestamp: res.data.timestamp
				nonceStr: res.data.nonceStr
				signature: res.data.signature
				jsApiList: [
					'onMenuShareTimeline', 'onMenuShareAppMessage'
				]
			wx.ready ->
				wx.onMenuShareTimeline
					title: getShareMessage()
					link: shareUrl
					imgUrl: getShareIcon()
					success: ->
						app.ajax.post url: 'web/sharing/increaseSharingMoments/tao308fbd4c6505329ee48e6'
						if G.shareTimeLineCallback
							G.shareTimeLineCallback()

				wx.onMenuShareAppMessage
					title: '我是你的宝贝'
					desc: getShareMessage()
					link: shareUrl
					imgUrl: getShareIcon()
					success: ->
						app.ajax.post url: 'web/sharing/increaseSharingFriends/tao308fbd4c6505329ee48e6'

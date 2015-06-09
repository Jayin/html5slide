app = require 'app'
Skateboard = require 'skateboard'
$ = require 'jquery'
require 'jstree'
React = require 'react'

ChartsBar = require '../../components/ChartsBar/main'

class Mod extends Skateboard.BaseMod
	cachable: true

	# events:
	# 	'click #btn-submit': 'submit'
	# 	'click #btn-register': 'register'
	# 	tenant
	TYPE_TENANT: 'tenant'
	TYPE_CAMPAIGN: 'campaign'

	cur_tenantId: 0
	cur_campaignId: 0

	jstreeInstance: null

	_bodyTpl: require './body.tpl.html'

	# Tenants / Campaigns
	initTree: =>
		handleTenants = (tenants)=>
			result = []
			tenants.forEach (element)=>
				element.text = element.name
				element.type = @TYPE_TENANT
				element.children =  true
				result.push(element)
			return result

		handleCampaigns= (campaigns)=>
			result = []
			campaigns.forEach (element)=>
				element.text = element.name
				element.type = @TYPE_CAMPAIGN
				result.push(element)
			return result

		jstree_config =  {
			core:
				themes:
					dots: false
				data: (node, callback)=> # 需要加载node的回调
					console.log '>>> invoke handler'
					console.log node
					console.log callback
					# 获取tenants
					if node.id is '#'
						app.ajax.get
							url: 'tracking/saas/tenants.json'
							success: (res)=>
								console.log(res)
								console.log handleTenants(res.data)
								callback(handleTenants(res.data))
					else #获取campaigns
						app.ajax.get
							url: 'tracking/saas/' + node.id +  '/campaigns.json'
							success: (res)=>
								console.log(res)
								console.log handleCampaigns(res.data)
								callback(handleCampaigns(res.data))
							error: ()=>
								callback([])
			types:
				default:
					icon: "frown icon"
				tenant:
					icon: "building outline icon"
				campaign:
					icon: "bar chart icon"

			plugins : ["types"]
		}

		$('#container').jstree jstree_config
		$('#container').on 'select_node.jstree', (event, data)=>
			if data.node.type is @TYPE_CAMPAIGN
				# 处理这个campign——获取campign数据
				@updateWechatData(data.node.parent, data.node.id)

			else if data.node.type is @TYPE_TENANT
				# 点击tenant则展开
				$('#container').jstree(true).open_node(data.node.id)

		@jstreeInstance = $('#container').jstree(true)

	updateWechatData: (tenantId, campaignId)=>
		# option init..(template option)
		option =
			title:
				show: true
				text: '微信端统计数据'
			legend:
				data: [ '分享到朋友圈', '分享給朋友' ]
			tooltip:
				show: true
			toolbox:
				show: true
				feature:
					saveAsImage:
						show: true
			xAxis: [
				{
					type: 'category'
					data: [
						''
					]
				}
			]
			yAxis: [
				{
					type: 'value'
				}
			]
			series:[
				{
					name: '数目'
					type: 'bar'
					data: [
						2300,452  #shareToTimeline, sahreToFriend
					]
				}
			]
		console.log('before ajax call')
		app.ajax.get
			url: 'tracking/saas/campaign/{campaignId}'.replace('{campaignId}', campaignId)
			success: (res)=>
				if res.code is 0
					# 转换数据
					console.log('in ajax get')
					newOption = app.util.cloneObject(option)
					newOption.series = []
					newOption.series.push({name: '分享到朋友圈', type: 'bar', data:[res.data.momentsCount]})
					newOption.series.push({name: '分享給朋友', type: 'bar', data:[res.data.friendsCount]})

					React.render(
						React.createElement(ChartsBar, {id: 'chart-wxshare', option: newOption, height: 400}),
						document.getElementById('chart-container-wxshare')
					)
				else
					app.alerts.alert 'Error Code:' + res.code

			error: (err)=>
				app.alerts.alert '网络繁忙,请稍后重试'

	render: =>
		super
		@initTree()


module.exports = Mod



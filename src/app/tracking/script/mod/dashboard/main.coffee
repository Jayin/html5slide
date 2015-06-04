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

	_bodyTpl: require './body.tpl.html'

	render: =>
		super

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
				element.text = element.adDescription
				element.type = @TYPE_CAMPAIGN
				result.push(element)
			return result

		jstree_config =  {
			core:
				themes:
					dots: false
				data: (node, callback)=>
					console.log '>>> invoke handler'
					console.log node
					console.log callback
					# 获取tenants
					if node.id is '#'
						app.ajax.get
							url: 'web/tracking/tenants.json'
							success: (res)=>
								console.log(res)
								console.log handleTenants(res.data.tenants)
								callback(handleTenants(res.data.tenants))
					else #获取campaigns
						app.ajax.get
							url: 'web/tracking/tenant/' + node.id +  '/campaigns.json'
							success: (res)=>
								console.log(res)
								console.log handleCampaigns(res.data.campaigns)
								callback(handleCampaigns(res.data.campaigns))
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
				# 处理这个campign
				alert('你点击了campaign-->'+data.node.id)
			else if data.node.type is @TYPE_TENANT
				$('#container').jstree(true).open_node(data.node.id)

		option =
			title:
				show: true
				text: '微信端统计数据'
			legend:
				data: [ '数目' ]
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
						'分享到朋友圈','分享给朋友'
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
						2300,452
					]
				}
			]

		React.render(
			React.createElement(ChartsBar, {id: 'chart-wxshare', option: option, height: 400}),
			document.getElementById('chart-container-wxshare')
		)


module.exports = Mod



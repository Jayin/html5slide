app = require 'app'
Skateboard = require 'skateboard'
$ = require 'jquery'
require 'jstree'

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

module.exports = Mod



app = require 'app'
Skateboard = require 'skateboard'
$ = require 'jquery'
require('jstree')

class Mod extends Skateboard.BaseMod
	cachable: true

	# events:
	# 	'click #btn-submit': 'submit'
	# 	'click #btn-register': 'register'
	#

	_bodyTpl: require './body.tpl.html'

	objectAttrLowercase: (obj)=>
		res = {}
		res.text = obj.Text
		res.id = obj.ID
		res.name = obj.Name
		res.alias = obj.Alias
		res.hierarchy = obj.Hierarchy
		res.companyName = obj.CompanyName
		res.companyCode = obj.CompanyCode
		res.groups = obj.Groups
		# 默认二级目录
		if res.hierarchy is 1
			res.state = {opened: true}
		else
			res.state = {opened: false}

		res.children = []
		obj.Children?.forEach (element)=>
			res.children.push @objectAttrLowercase(element)
		return res


	transformCategory: (data)=>
		result = []
		data.forEach (element)=>
			result.push @objectAttrLowercase(element)
		return result

	udpateCotegory: =>
		if !G.state.get('companyCode')
			Skateboard.core.view '/view/home'
			return

		jstree_config =  {
			core:
				themes:
					dots: false
				data: []
			types:
				default:
					icon: "icon-null" #see `./jstree-custom.scss`

			plugins : ["types"]
		}

		$('#category-container').on 'select_node.jstree', (event, data)=>
			console.log event
			console.log data
			if data.node.original.hierarchy is 3
				# 设置该原件的的所有给出的属性
				G.state.set category: data.node.original
				Skateboard.core.view '/view/info'

		app.ajax.get
			url: 'Data/Category/' + G.state.get('companyCode')
			success: (res)=>
				jstree_config.core.data = @transformCategory(res)

				$('#category-container').jstree(jstree_config)

			error: ()->
				app.alerts.alert '系统繁忙，请稍后再试'

	_afterFadeIn: =>
		@udpateCotegory()

	_afterFadeOut: =>
		console.log 'after fade out'
	render: =>
		super
		@udpateCotegory()


module.exports = Mod



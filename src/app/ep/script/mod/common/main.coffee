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
		res.text = obj.Text || obj.CompanyName
		res.id = obj.ID || obj.CompanyCode # 公司节点没有id
		res.name = obj.Name || obj.CompanyName # 公司节点没有name
		res.alias = obj.Alias
		res.hierarchy = obj.Hierarchy # may be undefine
		res.companyName = obj.CompanyName
		res.companyCode = obj.CompanyCode
		res.Groups = obj.Groups
		res.Categories = obj.Categories
		res.Children = obj.Children

		# 默认二级目录
		# if res.hierarchy is 1
		# 	res.state = {opened: true}
		# else
		# 	res.state = {opened: false}


		if obj.Children
			res.children = []
			obj.Children.forEach (element)=>
				res.children.push @objectAttrLowercase(element)

		if obj.Groups
			res.children = []
			obj.Groups.forEach (element)=>
				res.children.push @objectAttrLowercase(element)

		if obj.Categories
			res.children = []
			obj.Categories.forEach (element)=>
				res.children.push @objectAttrLowercase(element)

		return res


	transformCategory: (data)=>
		result = []
		data.forEach (element)=>
			result.push @objectAttrLowercase(element)
		return result

	udpateCotegory: =>

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

		$('#common-container').on 'select_node.jstree', (event, data)=>
			if data.node.original.hierarchy is 3
				# 设置该原件的的所有给出的属性
				G.state.set category: data.node.original
				Skateboard.core.view '/view/info'

		app.ajax.get
			url: 'Data/Tag/1'
			success: (res)=>
				jstree_config.core.data = @transformCategory(res)


				$('#common-container').jstree(jstree_config)

			error: ()->
				app.alerts.alert '系统繁忙，请稍后再试'

	_afterFadeIn: =>
		@udpateCotegory()

	_afterFadeOut: =>

	render: =>
		super
		@udpateCotegory()


module.exports = Mod



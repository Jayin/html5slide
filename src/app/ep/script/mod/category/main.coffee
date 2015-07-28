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

	objectAttrLowercase: (obj, parentId)=>
		parentId = parentId || ''
		res = {}
		res.text = obj.Text
		res.id = parentId + '-' + obj.ID
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
			res.children.push @objectAttrLowercase(element, res.id)
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
		$container = $('#category-container')

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

		$container.on 'select_node.jstree', (event, data)=>
			event.preventDefault();
			# console.log event
			# console.log data
			# console.log('select_node.jstree!!!!!!')
			if data.node.original.hierarchy is 3
				console.log(data)
				# 设置该原件的的所有给出的属性
				category = data.node.original
				#remove all parent id
				ids =  category.id.split('-')
				category.id = ids[ids.length - 1]

				G.state.set category: category, categoryName: data.node.original.text
				Skateboard.core.view '/view/info'
			else
				$container.jstree(true).open_node(data.node.id)
			#deselect node to prevent automaticly go to `/view/info` when come back in `/view/info`
			$container.jstree(true).deselect_node(data.node.id)
				# console.log($container)
				# console.log $container.jstree(true).is_open(data.node.id)
				# if $container.jstree(true).is_open(data.node.id)
				# 	$container.jstree(true).close_node(data.node.id)
				# else
				# 	$container.jstree(true).open_node(data.node.id)

		app.ajax.get
			url: 'Data/Category/' + G.state.get('companyCode')
			success: (res)=>
				jstree_config.core.data = @transformCategory(res)

				$container.jstree(jstree_config)

				$container.jstree(true).settings.core.data = jstree_config.core.data;
				$container.jstree(true).refresh(true);

			error: ()->
				app.alerts.alert '系统繁忙，请稍后再试'

	_afterFadeIn: =>
		@udpateCotegory()

	_afterFadeOut: =>
		# console.log 'after fade out'

	render: =>
		super
		@udpateCotegory()


module.exports = Mod

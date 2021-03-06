app = require 'app'
Skateboard = require 'skateboard'
$ = require 'jquery'
jstree = require('jstree')

class Mod extends Skateboard.BaseMod
	cachable: true

	# events:
	# 	'click #btn-submit': 'submit'
	# 	'click #btn-register': 'register'
	#

	_bodyTpl: require './body.tpl.html'

	$container: null

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

	#计算默认有多少个展开
	_calTotalItem: (result)=>
		count = result.length;
		for item in result
			#不计算根节点
			if item.Children && item.Children.length > 0
				count += @_calTotalItem(result[i].Children)

			if item.Groups && item.Groups.length > 0
				count += @_calTotalItem(result[i].Groups)

			if item.Categories && item.Categories.length > 0
				count += this._calTotalItem(result[i].Categories)
		return count

	udpateCotegory: =>
		if !G.state.get('companyCode')
			Skateboard.core.view '/view/home'
			return
		$container = @$container

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



		app.ajax.get
			url: 'Data/Category/' + G.state.get('companyCode')
			success: (res)=>
				jstree_config.core.data = @transformCategory(res)

				$container.jstree(jstree_config)

				$container.jstree(true).settings.core.data = jstree_config.core.data;
				$container.jstree(true).refresh(true);

				length = @_calTotalItem(res)*24
				$container.height(length)

			error: ()->
				app.alerts.alert '系统繁忙，请稍后再试'

	_afterFadeIn: =>
		@udpateCotegory()

	_afterFadeOut: =>
		# console.log 'after fade out'

	render: =>
		super
		$container = @$container = $('#category-container')

		$container.on 'select_node.jstree', (event, data)=>
			event.preventDefault();
			$container.jstree(true).deselect_node(data.node.id)
			if data.node.original.hierarchy is 3
				# console.log(data)
				# 设置该原件的的所有给出的属性
				category = data.node.original
				#remove all parent id
				ids =  category.id.split('-')
				category.id = ids[ids.length - 1]

				G.state.set category: category, categoryName: data.node.original.text
				Skateboard.core.view '/view/info'
			else
				if $container.jstree(true).is_open(data.node.id)
					$container.jstree(true).close_node(data.node.id)
				else
					$container.jstree(true).open_node(data.node.id)





module.exports = Mod

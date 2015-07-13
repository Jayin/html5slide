app = require 'app'
Skateboard = require 'skateboard'
$ = require 'jquery'

React = require 'react'
AccessoryList = require '../../components/AccessoryList/main'
PropertiesList = require '../../components/PropertiesList/main'
Distributor = require '../../components/Distributor/main'
Detail = require '../../components/Detail/main'
MessageList = require '../../components/MessageList/main'

class Mod extends Skateboard.BaseMod
	cachable: true

	events:
		'click .option': 'chooseOption'
		'change #info-input-body': 'onBodyChange'
		'change #info-input-accessory': 'onAccessoryChange'

	_bodyTpl: require './body.tpl.html'

	category: null
	productPrice: 0 # 产品价格
	product: null # 产品信息
	properties: []# 产品属性


	_afterFadeIn: =>
		# 每次进入该页面是清空数据
		G.state.set({accessory: null})

	_afterFadeOut: =>

	calPrice: =>
		return Math.round(@productPrice * (G.state.get('percent').body / 100) * 100)/100

	onBodyChange: (evt)=>
		val = $('#info-input-body')[0].value
		if parseInt(val)
			# handle the change
			percent = G.state.get('percent')
			percent.body = val
			G.state.set({percent: percent})
			# 四舍五入
			$('.product-price-number').text(@calPrice())
			if $('.option.option-active').data('index') is 2 #当前Tab是明细页，则更新
				@detail()
		else
			$('#info-input-body')[0].value = 100

	onAccessoryChange: (evt)=>
		val = $('#info-input-accessory')[0].value
		if parseInt(val)
			# handle the change
			percent = G.state.get('percent')
			percent.accessory = val
			G.state.set({percent: percent})
			if $('.option.option-active').data('index') is 2 #当前Tab是明细页，则更新
				@detail()
		else
			$('#info-input-accessory')[0].value = 100


	chooseOption: (evt)=>
		index = parseInt(evt.currentTarget.dataset.index)
		$('.option').removeClass('option-active')
		$($('.option')[index]).addClass('option-active')

		if index == 0
			@getProperties()
		else if index == 1
			@getAccessory()
		else if index == 2
			@detail()
		else if index == 3
			@getDistributor()
		else if index == 4
			@getMessage()
		else
			app.alerts.alert '你点击啥?'
	# 检测是否有三级分类
	_CheckCategory: ()=>
		category = G.state.get('category')
		if !category
			Skateboard.core.view '/view/home'
			return false

		@category = category
		return true
	# 留言列表
	getMessage: (pageIndex=1, pageSize=20)=>
		if !@_CheckCategory()
			return
		React.render(
					React.createElement(MessageList, {result: [], category: @category}),
					document.getElementById('info-cotent-container')
		)
	# 经销商列表
	getDistributor: ()=>
		if !@_CheckCategory()
			return
		app.ajax.get
			url: 'Data/Distributor/{companyCode}'.replace('{companyCode}', @category.companyCode)
			success: (res)=>
				React.render(
					React.createElement(Distributor, {Distributors: res}),
					document.getElementById('info-cotent-container')
				)
			error: (err)=>
				app.alerts.alert '系统繁忙，请稍后再试'


	# 明细列表
	detail: ()=>
		if !@_CheckCategory()
			return
		prd =
			Name: @product.Name
			price: @calPrice()
		React.render(
			React.createElement(Detail, {Accessorys: G.state.get('accessory'), Product: prd}),
			document.getElementById('info-cotent-container')
		)

	# TODO: 每次来到info页面的时候都有清空附件列表
	_saveAccessory: (accessory)=>
		newAccessory = accessory.map (element)=>
			element.Items.map (item)=>
				# 按照默认勾选
				item.IsSelected = item.IsDefault
				return item
			return element
		G.state.set({accessory: newAccessory})

	# 附体列表
	getAccessory: ()=>
		if !@_CheckCategory()
			return
		# 如果有数据，说明是当页tab的切换，不需要重新请求新数据，而是直接渲染
		if G.state.get('accessory')
			React.render(
					React.createElement(AccessoryList, {Accessorys: G.state.get('accessory')}),
					document.getElementById('info-cotent-container')
				)
			return
		url = 'Data/Accessory/{productID}?companyCode={companyCode}'
		app.ajax.get
			url: url.replace('{productID}', @product.ID).replace('{companyCode}', @category.companyCode)
			success: (res)=>
				# 处理& 保存
				@_saveAccessory(res)
				React.render(
					React.createElement(AccessoryList, {Accessorys: G.state.get('accessory')}),
					document.getElementById('info-cotent-container')
				)
			error: (err)=>
				app.alerts.alert '系统繁忙，请稍后再试'

	# 本体
	getProperties: ()=>
		if !@_CheckCategory()
			return
		url = 'Data/CategoryInfo/{category3Name}?companyCode={companyCode}'
		prd = G.state.get('Product')
		if prd
			url += "&"
			prd.Items.map (item, index)=>
				if item.Text != ''
					url += "p#{@properties[index].Index}=#{item.Text}&"

			url = url.slice(0, url.length - 1)
			# remove the data
			G.state.set({Product: null})

		app.ajax.get
			url: url.replace('{category3Name}', @category.name).replace('{companyCode}', @category.companyCode)
			success: (res)=>
				@properties = res.Properties
				@product = res.Product
				@productPrice = res.Product.Price
				$('.product-name').text(res.Product.Name)
				$('.product-price-number').text(Math.round(@productPrice * (G.state.get('percent').body / 100) * 100) / 100)
				React.render(
					React.createElement(PropertiesList, {Properties: res.Properties ,Product: res.Product }),
					document.getElementById('info-cotent-container')
				)
			error: (err)=>
				app.alerts.alert '系统繁忙，请稍后再试'

	# 初始化百分比
	initPercent: ()=>
		G.state.set {percent: {body: 100, accessory: 100}}
		# update the UI
		$('#info-input-body')[0].value = 100
		$('#info-input-accessory')[0].value = 100

	updatePercent: (body , accessory )=>
		#option option-active
		percent = G.state.get('percent')
		G.state.set {'percent': {body: body || percent.body, accessory: accessory || percent.accessory}}
		if $('.option.option-active').data('index') is 2 #当前Tab是明细页，则更新
			React.render(
				React.createElement(AccessoryList, {Accessorys: G.state.get('accessory')}),
				document.getElementById('info-cotent-container')
			)
	# 选择了不同的属性，需要重新加载
	onStateChange: =>
		if G.state.get('Product')
			@getProperties()
			@initPercent()
			# 清空附件数据
			G.state.set({accessory: null})

	render: =>
		super
		@initPercent()
		@getProperties()

		G.state.on 'change', @onStateChange

	destroy: =>
		G.state.off 'change', @onStateChange


module.exports = Mod



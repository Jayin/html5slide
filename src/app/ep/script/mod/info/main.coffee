app = require 'app'
Skateboard = require 'skateboard'
$ = require 'jquery'

React = require('react')
PropertiesList = require('../../components/PropertiesList/main')

class Mod extends Skateboard.BaseMod
	cachable: true

	events:
		'click .option': 'chooseOption'
		'change #info-input-body': 'onBodyChange'
		'change #info-input-accessory': 'onAccessoryChange'

	_bodyTpl: require './body.tpl.html'

	category: null


	_afterFadeIn: =>

	_afterFadeOut: =>

	onBodyChange: (evt)=>
		console.log 'onBodyChange-->'
		console.log evt

	onAccessoryChange: (evt)=>
		console.log 'onAccessoryChange--->'
		console.log evt


	chooseOption: (evt)=>
		index = evt.currentTarget.dataset.index
		if index == "1"
			@getProperties()
		else if index == "2"
			@getAccessory()
		else if index == "3"
			@detail()
		else if index == "4"
			@getDistributor()
		else
			app.alerts.alert '你点击啥?'

	_CheckCategory: ()=>
		category = G.state.get('category')
		console.log '_CheckCategory'
		console.log category
		if !category
			Skateboard.core.view '/view/home'
			return false

		@category = category
		return true

	getDistributor: ()=>
		if !@_CheckCategory()
			return
		console.log 'getDistributor page'
		app.ajax.get
			url: 'Data/Distributor/{companyCode}'.replace('{companyCode}', @category.companyCode)
			success: (res)=>
				console.log res
			error: (err)=>
				app.alerts.alert '系统繁忙，请稍后再试'


	# 明细
	detail: ()=>
		if !@_CheckCategory()
			return
		console.log 'detail page'

	# 更新附体数据
	getAccessory: ()=>
		console.log 'getAccessory page'
		if !@_CheckCategory()
			return
		url = 'Data/Accessory/{productID}?companyCode={companyCode}'
		app.ajax.get
			url: url.replace('{productID}', @category.id).replace('{companyCode}', @category.companyCode)
			success: (res)=>
				console.log res
			error: (err)=>
				app.alerts.alert '系统繁忙，请稍后再试'

	# 本体
	getProperties: ()=>
		if !@_CheckCategory()
			return
		url = 'Data/CategoryInfo/{category3Name}?companyCode={companyCode}'
		app.ajax.get
			url: url.replace('{category3Name}', @category.name).replace('{companyCode}', @category.companyCode)
			success: (res)=>
				console.log 'ret-->'
				console.log res
				$('.product-name').text(res.Product.Name)
				$('.product-price-number').text(res.Product.Price)
				React.render(
					React.createElement(PropertiesList, {Properties: res.Properties ,Product: res.Product }),
					document.getElementById('info-cotent-container')
				)
			error: (err)=>
				app.alerts.alert '系统繁忙，请稍后再试'

	render: =>
		super
		# @udpateCotegory()
		console.log 'info--->'
		console.log G.state.get('category')
		@getProperties()




module.exports = Mod



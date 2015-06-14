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


	_afterFadeIn: =>

	_afterFadeOut: =>

	onBodyChange: (evt)=>
		console.log 'onBodyChange-->'
		console.log evt

	onAccessoryChange: (evt)=>
		console.log 'onAccessoryChange--->'
		console.log evt


	chooseOption: (evt)=>
		console.log evt



	getProperties: (evt)=>
		console.log evt
		category = G.state.get('category')
		if !category
			Skateboard.core.view '/view/home'
			return
		url = 'Data/CategoryInfo/{category3Name}?companyCode={companyCode}'
		app.ajax.get
			url: url.replace('{category3Name}', category.name).replace('{companyCode}', category.companyCode)
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



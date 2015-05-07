app = require 'app'
Skateboard = require 'skateboard'

class Mod extends Skateboard.BaseMod
	cachable: true

	events:
		'click .mom-open__open-btn': 'openPackage'

	customizeNumber: 1 #自定义场景的标号

	render: ->
		designId = app.util.getUrlParam 'designId'
		@dataPromise = app.ajax.get
			url: 'web/taobao/design/' + designId
			success: (res) =>
				if res.code is 0
					obj = res.data
					G.state.set obj
					if obj.imgRelativePath
						@setAvatar obj.imgRelativePath 
					if obj.scene
						@setScene obj.scene 
					if obj.nick
						$('#nick-display').text obj.nick
					if obj.price
						$('#price-display').text obj.price 
				else
					alert res.code + ': ' + res.msg
			error: ->
				alert '系统繁忙，请您稍后重试。'
		# preload next page
		require ['../buy-confirm/main']

	setAvatar: (imgRelativePath) ->
		$('<img id="good-avatar" src="' + G.CDN_ORIGIN + '/' + imgRelativePath + '" />').appendTo $('#good-wrapper')

	setScene: (scene) ->
		$('#good-wrapper')[0].className = 'g' + scene.no
		require ['../buy/s-bg-0' + scene.no + '-main.tpl.html'], (tpl) ->
			$(tpl.render()).appendTo $('#good-wrapper')

		if scene.no is @customizeNumber
			$('#good-customized-good-detail').text scene.goodDetail + @getNickDescription(scene.no).description
		else
			$('#good-customized-good-detail').text  @getNickDescription(scene.no).description
			
		$('#suffix-display').text @getNickDescription(G.state.get().scene.no).suffix

		# preload next page
		require ['../buy-confirm/bg-0' + scene.no + '-main.tpl.html']

	openPackage: =>
		@$('.mom-open').fadeOut()

	
	getNickDescription: (number)->
		console.log number 
		if number == 1
			'suffix': '  无比机智与聪慧'
			'description': ' 新品首发'
		else if number ==  2
			'suffix': ' 文武双全 随时待命'
			'description': ' 防王姨勾搭 维护家庭和平 人气爆款特供'	
		else if number ==  3
			'suffix': ' 酷炫吊炸天'
			'description': ' 老爸私房钱无缝探测 正品包邮'	
		else if number ==  4
			'suffix': ' 无比机智与聪慧'
			'description': ' 雀神之手 逢把必自摸神技 新品首发'	
		else if number ==  5
			'suffix': ' 爱卖萌爱撒娇'
			'description': ' 广场舞无条件陪练 量贩式配乐播放 超强音质'	
		else if number ==  6
			'suffix': ' 财大气粗 任性'
			'description': '支付宝余额无限充值 全国联保'	
		else 
			'suffix': ' 洗护合一新升级'
			'description': ' 我是人肉洗衣机 超强去渍 送装同步'	

module.exports = Mod

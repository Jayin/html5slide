app = require 'app'
Skateboard = require 'skateboard'
Hammer = require 'hammer'

class Mod extends Skateboard.BaseMod
	cachable: true

	events:
		'click .buy-btn': 'buy'

	_bodyTpl: require './body.tpl.html'

	buyPrice: ''

	confirm_time: 0
	Interval: 200
	isCounting: false

	customizeNumber: 1 #自定义场景的标号

	render: ->
		super
		obj = G.state.get()
		
		if obj.imgRelativePath	
			@setAvatar obj.imgRelativePath 
		if obj.scene	
			@setScene obj.scene
		if obj.nick 
			$('#buy-confirm-nick').text obj.nick 
		if obj.price
			@$('.buy-confirm-price').text obj.price 

		$('#buy-confrim-price').on 'focus', (evt) =>
			$(evt.target).addClass 'focus'
		$('#buy-confrim-price').on 'change blur', (evt) =>
			target = evt.target
			target.value = target.value.trim()
			if target.value
				$(target).addClass 'focus'
			else
				$(target).removeClass 'focus'
			@buyPrice = target.value
			@$('.buy-confirm-price').text(@buyPrice || G.state.get('price'))

		hm = new Hammer(document.getElementById('btn-buy-comfrim'))
		hm.on 'press', @pressStart
		hm.on 'pressup', @pressEnd



	setAvatar: (imgRelativePath) ->
		$('<img id="buy-confirm-avatar" src="' + G.CDN_ORIGIN + '/' + imgRelativePath + '" />').appendTo $('#buy-confirm-wrapper')

	setScene: (scene) ->
		$('#buy-confirm-wrapper')[0].className = 'g' + scene.no
		require ['./bg-0' + scene.no + '-main.tpl.html'], (tpl) ->
			$(tpl.render()).appendTo $('#buy-confirm-wrapper')

		if scene.no is @customizeNumber
			$('#good-customized-good-detail').text scene.goodDetail + @getNickDescription(scene.no).description
		else
			$('#good-customized-good-detail').text  @getNickDescription(scene.no).description
			
		$('#suffix-display').text @getNickDescription(G.state.get().scene.no).suffix

	buy: =>
		designId = app.util.getUrlParam('designId')
		app.ajax.put
			url: 'web/taobao/design/' + designId + '/buy'
			data: 
				buyPrice: @buyPrice || G.state.get('price')
			success: (res) =>
				if res.code is 0
					location.href = "buy-success.html?designId=#{designId}"
				else
					alert res.code + ': ' + res.msg
			error: ->
				alert '系统繁忙，请您稍后重试。'

	pressStart: =>
		@confirm_time = (new Date).getTime()
		@isCounting = true
		setTimeout ()=>
			cur_time = (new Date).getTime()
			if cur_time - @confirm_time > @Interval - 50 and @isCounting
				@buy()
		,@Interval

	pressEnd: =>
		@isCounting = false



	getNickDescription: (number)->
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

__END__

@@ body.tpl.html
<!-- include "body.scss" -->

<div class="body-inner">
	<div id="buy-confirm-wrapper">
		<div class="buy-confirm-price"></div>
		<div class="buy-confirm-nick" style="margin: 2px;">
			<p ><sapn id="buy-confirm-nick"></sapn><span id="suffix-display"></span></p>
			<p id="good-customized-good-detail"></p>
		</div>
		<div class="customize">
			<img src="../../../image/buy-confirm/customized-title.png" />
			<div id="buy-confirm-customized-good-name"></div>
			<div id="buy-confirm-customized-good-detail"></div>
		</div>
		<input id="buy-confrim-price" type="text" maxlength="5"/>
		<button id="btn-buy-comfrim"class="img-btn buy-btn" onclick="G.record('9');">购买</button>
	</div>
</div>


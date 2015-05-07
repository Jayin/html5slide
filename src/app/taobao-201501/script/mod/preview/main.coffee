app = require 'app'
Skateboard = require 'skateboard'

class Mod extends Skateboard.BaseMod
	cachable: true

	events:
		'click .btn-back': 'back'
		'click .btn-share': 'share'

	_bodyTpl: require './body.tpl.html'

	price: ''
	customizeNumber: 1 #自定义场景的标号

	render: ->
		super
		@setAvatar G.state.get('imgData')
		@stateChange null, G.state.get()
		G.state.on 'change', @stateChange

	setAvatar: (imgData) ->
		$('#good-avatar')[0].src = imgData

	setScene: (scene) ->
		$('#good-wrapper')[0].className = 'g' + scene.no
		$('#good-wrapper .good-bg-img').remove()
		require ['../buy/bg-0' + scene.no + '-main.tpl.html'], (tpl) ->
			$(tpl.render()).appendTo $('#good-wrapper')

		if scene.no is @customizeNumber
			$('#good-customized-good-detail').text scene.goodDetail + @getNickDescription(scene.no).description
		else
			$('#good-customized-good-detail').text  @getNickDescription(scene.no).description

		$('#suffix-display').text @getNickDescription(G.state.get().scene.no).suffix
		

	back: =>
		history.back()

	share: =>
		state = G.state.get()
		app.ajax.post
			url: 'web/taobao/design'
			data: state
			success: (res) =>
				if res.code is 0
					location.href = "share.html?designId=#{res.data.designId}"
				else
					alert res.code + ': ' + res.msg
			error: ->
				alert '系统繁忙，请您稍后重试。'

	stateChange: (evt, obj) =>
		if obj.imgData
			@setAvatar obj.imgData 
		if obj.scene
			@setScene obj.scene 
		if obj.nick
			$('#nick-display').text obj.nick

		if obj.price			
			$('#price-display').text obj.price 

	destroy: ->
		super
		G.state.off 'change', @stateChange


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
<%
var $ = require('jquery');
var app = require('app');
%>

<!-- include "body.scss" -->

<div class="body-inner">
	<div id="good-wrapper">
		<div class="good-price">
			<div class="price">
				<div id="price-display" style="float: left;font-size: 1.2rem;"></div>
				<img src="../../../image/buy/price-baner.jpg" style="float:left;">
			</div>
		</div>
		<img id="good-avatar" />
		<div id="good-nick">
			<p><span id="nick-display"></span><span id="suffix-display"></span></p>
			<p id="good-customized-good-detail"></p>
		</div>
		<div class="good-actions">
			<img src="../../../image/share/good-action.png" />
			<button class="img-btn btn-back">返回</button>
			<button class="img-btn btn-share" onclick="G.record('5');">分享</button>
		</div>
	</div>
</div>

app = require 'app'
Skateboard = require 'skateboard'

class Mod extends Skateboard.BaseMod
	cachable: true

	events:
		'click .btn-back': 'back'
		'click .btn-next': 'next'
		'click .btn-arrow-left': 'prevScene'
		'click .btn-arrow-right': 'nextScene'

	_bodyTpl: require './body.tpl.html'

	sceneNo: 1
	sceneTotal: 7 #场景总数
	customizeNumber: 1 #自定义场景的标号
	detailMaxLength: 15 #自定义详情的长度

	render: ->
		super
		@setAvatar G.state.get('imgData')
		G.state.on 'change', @stateChange
		$('#customized-good-detail').on 'focus', ->
			$(this).addClass 'focus'
		$('#customized-good-detail').on 'change blur', ->
			this.value = this.value.trim()
			if this.value
				$(this).addClass 'focus'
			else
				$(this).removeClass 'focus'
			# 过长就切割
			if this.value.length > @detailMaxLength
				this.value = this.value.slice 0, @detailMaxLength
		# 第一个是自定义
		@$('.customize').show()

		# preload next page
		require ['../price/main', '../price/bg-01-main.tpl.html']

	setAvatar: (imgData) ->
		$('#scene-avatar')[0].src = imgData

	updateScene: ->
		$('#scene-wrapper')[0].className = 's' + @sceneNo
		if @sceneNo is @customizeNumber
			@$('.customize').show()
		else
			@$('.customize').hide()
		# preload next page
		require ['../price/bg-0' + @sceneNo + '-main.tpl.html']

	prevScene: =>
		@sceneNo = (@sceneNo - 1) || @sceneTotal
		if @sceneNo == 5
			@sceneNo = 2
		@updateScene()

	nextScene: =>
		@sceneNo = (@sceneNo % @sceneTotal) + 1
		if @sceneNo == 3
			@sceneNo = 6
		@updateScene()

	back: =>
		history.back()

	next: =>
		if @sceneNo is @customizeNumber
			goodName = $('#customized-good-name').val()
			goodDetail = $('#customized-good-detail').val()
			if goodName and goodDetail
				G.state.set
					scene:
						no: @sceneNo
						goodName: goodName
						goodDetail: goodDetail
				Skateboard.core.view '/view/price'
			else
				alert '请输入宝贝详情'
		else
			G.state.set
				scene:
					no: @sceneNo
			Skateboard.core.view '/view/price'

	stateChange: (evt, obj) =>
		@setAvatar obj.imgData if obj.imgData

	destroy: ->
		super
		G.state.off 'change', @stateChange

module.exports = Mod

__END__

@@ body.tpl.html
<%
var $ = require('jquery');
var app = require('app');
%>

<!-- include "body.scss" -->

<div class="body-inner">
	<div id="scene-wrapper" class="s1">
		<img id="scene-avatar" />
		<div class="customize">
			<img class="customize-title" src="../../../image/scene/customize-title.png" />
			<input id="customized-good-name" type="text" maxlength="15" value="<%==G.state.get('nick')%>"/>
			<textarea id="customized-good-detail" maxlength="15"></textarea>
		</div>
		<button class="img-btn btn-arrow-left">&lt;</button>
		<button class="img-btn btn-arrow-right">&gt;</button>
		<button class="img-btn btn-back">返回</button>
		<button class="img-btn btn-next" onclick="G.record('3');">下一步</button>
	</div>
</div>

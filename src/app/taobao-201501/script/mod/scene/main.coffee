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

	render: ->
		super
		@setAvatar G.state.get('avatar')
		G.state.on 'change', @stateChange
		$('#customized-good-name, #customized-good-detail').on 'focus', ->
			$(this).addClass 'focus'
		$('#customized-good-name, #customized-good-detail').on 'change blur', ->
			this.value = this.value.trim()
			if this.value
				$(this).addClass 'focus'
			else
				$(this).removeClass 'focus'
			if this.id is 'customized-good-detail'
				if this.value.length > 25
					this.value = this.value.slice 0, 25
		# preload next page
		require ['../price/main', '../price/bg-01-main.tpl.html']

	setAvatar: (avatar) ->
		if avatar.no is 1
			$('#scene-avatar')[0].src = avatar.clipData
		else
			$('#scene-avatar')[0].src = $('#avatar-' + avatar.no)[0].src

	updateScene: ->
		$('#scene-wrapper')[0].className = 's' + @sceneNo
		if @sceneNo is 9
			@$('.customize').show()
		else
			@$('.customize').hide()
		# preload next page
		require ['../price/bg-0' + @sceneNo + '-main.tpl.html']

	prevScene: =>
		@sceneNo = (@sceneNo - 1) || 9
		@updateScene()

	nextScene: =>
		@sceneNo = (@sceneNo % 9) + 1
		@updateScene()

	back: =>
		history.back()

	next: =>
		if @sceneNo is 9
			customized =
				goodName: $('#customized-good-name').val()
				goodDetail: $('#customized-good-detail').val()
			if customized.goodName and customized.goodDetail
				G.state.set
					scene:
						no: @sceneNo
						customized: customized
				Skateboard.core.view '/view/price'
			else
				alert '请输入宝贝名称和宝贝详情'
		else
			G.state.set
				scene:
					no: @sceneNo
			Skateboard.core.view '/view/price'

	stateChange: (evt, obj) =>
		@setAvatar obj.avatar if obj.avatar

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
			<input id="customized-good-name" type="text" maxlength="12" />
			<textarea id="customized-good-detail"></textarea>
		</div>
		<button class="img-btn btn-arrow-left">&lt;</button>
		<button class="img-btn btn-arrow-right">&gt;</button>
		<button class="img-btn btn-back">返回</button>
		<button class="img-btn btn-next">下一步</button>
	</div>
</div>

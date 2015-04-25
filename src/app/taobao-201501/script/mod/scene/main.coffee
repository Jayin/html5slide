app = require 'app'
Skateboard = require 'skateboard'

class Mod extends Skateboard.BaseMod
	cachable: true

	events:
		'change .upload-btn': 'fileChange'
		'click .btn-next': 'next'
		'click .btn-arrow-left': 'prevScene'
		'click .btn-arrow-right': 'nextScene'

	_bodyTpl: require './body.tpl.html'

	sceneNo: 1

	render: ->
		super
		@setAvatar G.state.get('avatar')
		G.state.on 'change', @stateChange
		# preload next page
		require ['../canvas/main']

	setAvatar: (avatar) ->
		if avatar.no is 5
			$('#scene-avatar')[0].src = avatar.clipData
		else
			$('#scene-avatar')[0].src = $('#avatar-' + avatar.no)[0].src

	updateScene: ->
		$('#scene-wrapper')[0].className = 's' + @sceneNo
		if @sceneNo is 9
			@$('.customize').show()
		else
			@$('.customize').hide()

	prevScene: =>
		@sceneNo = (@sceneNo - 1) || 9
		@updateScene()

	nextScene: =>
		@sceneNo = (@sceneNo % 9) + 1
		@updateScene()

	back: =>
		Skateboard.core.view '/view/home'

	next: =>
		Skateboard.core.view '/view/canvas'

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
		<a class="img-btn btn-back" href="/:back">返回</a>
		<button class="img-btn btn-next">下一步</button>
	</div>
</div>

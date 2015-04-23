app = require 'app'
Skateboard = require 'skateboard'

class Mod extends Skateboard.BaseMod
	cachable: true

	events:
		'change .upload-btn': 'fileChange'
		'click .btn-next': 'next'
		'click .btn-arrow-left': 'prevAvatar'
		'click .btn-arrow-right': 'nextAvatar'

	_bodyTpl: require './body.tpl.html'

	avatarNo: 1

	init: ->
		G.state.on 'change', (evt, obj) =>
			@$('.nick').text obj.nick if obj.nick

	render: ->
		super
		# preload next page
		require ['../canvas/main']

	resetFileInput: ->
		$('.upload-btn input').remove()
		$('<input type="file" capture="camera" accept="image/*" />').appendTo $('.upload-btn')

	fileChange: (evt) =>
		URL = window.URL || window.webkitURL
		file = evt.originalEvent.srcElement.files[0]
		imgUrl = URL.createObjectURL(file)
		img = new Image()
		img.onload = =>
			avatar = 
				file: file
				url: imgUrl
				width: img.naturalWidth
				height: img.naturalHeight
			G.state.set avatar: avatar
			@resetFileInput()
			Skateboard.core.view '/view/canvas'
		img.src = imgUrl

	updateAvatar: ->
		$('#avatar-wrapper')[0].className = 'a' + @avatarNo
		if @avatarNo is 5
			@$('.upload-btn').show()
		else
			@$('.upload-btn').hide()

	prevAvatar: =>
		@avatarNo = (@avatarNo - 1) || 5
		@updateAvatar()

	nextAvatar: =>
		@avatarNo = (@avatarNo % 5) + 1
		@updateAvatar()

	back: =>
		Skateboard.core.view '/view/home'

	next: =>
		Skateboard.core.view '/view/canvas'

module.exports = Mod

__END__

@@ body.tpl.html
<%
var $ = require('jquery');
var app = require('app');
%>

<!-- include "body.scss" -->

<div class="body-inner">
	<div id="avatar-wrapper" class="a1">
		<div class="avatar-title">
			<div class="a1"><span>萌蠢少女</span></div>
			<div class="a2"><span>多汁小鲜肉</span></div>
			<div class="a3"><span>顶级女神经</span></div>
			<div class="a4"><span>抠脚糙汉</span></div>
			<div class="a5"><span>上传靓照</span></div>
		</div>
		<div class="avatars">
			<div class="a1">
				<img src="../../../image/avatar/avatar-01.png" />
			</div>
			<div class="a2">
				<img src="../../../image/avatar/avatar-02.png" />
			</div>
			<div class="a3">
				<img src="../../../image/avatar/avatar-03.png" />
			</div>
			<div class="a4">
				<img src="../../../image/avatar/avatar-04.png" />
			</div>
			<div class="a5">
				<img src="../../../image/avatar/avatar-05.png" />
				<div class="upload-btn">
					<input type="file" capture="camera" accept="image/*" />
				</div>
			</div>
		</div>
		<div class="nick"><%==G.state.get('nick')%></div>
		<div class="avatar-desc">
			<div class="a1">卖萌撒娇都无敌</div>
			<div class="a2">八面玲珑巧舌如簧</div>
			<div class="a3">擦大气粗真土豪</div>
			<div class="a4">奔放洋气有深度</div>
		</div>
		<ul class="indicator">
			<li class="indicator__item a1">1</li>
			<li class="indicator__item a2">2</li>
			<li class="indicator__item a3">3</li>
			<li class="indicator__item a4">4</li>
			<li class="indicator__item a5">5</li>
		</ul>
		<button class="img-btn btn-arrow-left">&lt;</button>
		<button class="img-btn btn-arrow-right">&gt;</button>
		<a class="img-btn btn-back" href="/:back">返回</a>
		<button class="img-btn btn-next">下一步</button>
	</div>
</div>

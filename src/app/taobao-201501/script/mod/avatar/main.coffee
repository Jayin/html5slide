app = require 'app'
Skateboard = require 'skateboard'

class Mod extends Skateboard.BaseMod
	cachable: true

	events:
		'change .upload-btn': 'fileChange'
		'click .btn-back': 'back'
		'click .btn-next': 'next'

	_bodyTpl: require './body.tpl.html'

	resetFileInput: ->
		$('.upload-btn input').remove()
		$('<input type="file" capture="camera" accept="image/*" />').appendTo $('.upload-btn')

	fileChange: (evt) =>
		URL = window.URL || window.webkitURL
		file = evt.originalEvent.srcElement.files[0]
		imgUrl = URL.createObjectURL(file)
		img = new Image()
		img.onload = =>
			newImg = 
				file: file
				url: imgUrl
				width: img.naturalWidth
				height: img.naturalHeight
			Mod.img = newImg
			$(Mod).trigger 'imgchange', newImg
			@resetFileInput()
			Skateboard.core.view '/view/canvas'
		img.src = imgUrl

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
			<span class="a1">萌蠢少女</span>
		</div>
		<ul class="indicator">
			<li class="a1">1</li>
			<li class="a2">2</li>
			<li class="a3">3</li>
			<li class="a4">4</li>
			<li class="a5">5</li>
			<li class="a6">6</li>
		</ul>
		<div class="upload-btn">
			<input type="file" capture="camera" accept="image/*" />
		</div>
		<button class="img-btn btn-arrow-left">&lt;</button>
		<button class="img-btn btn-arrow-right">&gt;</button>
		<button class="img-btn btn-back">返回</button>
		<button class="img-btn btn-next">下一步</button>
	</div>
</div>

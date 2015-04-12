app = require 'app'
Skateboard = require 'skateboard'

class Mod extends Skateboard.BaseMod
	cachable: true

	events:
		'change .upload-btn': 'fileChange'
		'click .rules__link': 'showRules'

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

	showRules: =>
		require ['./dialog-main'], (dialog) ->
			dialog.show [
				'<p>世界只有一个，地球只有一个</p>'
				'<p>人类有N中，你是哪一种</p>'
				'<p><strong>我们是荧光人类</strong></p>'
				'<p>赶紧拿起手机拍照吧，或者从相册中选取一张，点击你喜欢的模板、道具、口号从现在开始，你就是荧光人类的主角带上你的小伙伴一起疯狂夜跑吧</p>'
			].join('')

module.exports = Mod

__END__

@@ body.tpl.html
<%
var $ = require('jquery');
var app = require('app');
%>

<!-- include "body.scss" -->

<div class="body-inner">
	&nbsp;
	<div class="upload-btn">
		<input type="file" capture="camera" accept="image/*" />
	</div>
	<div class="rules">
		<a class="rules__link" href="javascript:void(0);">活动规则</a>
	</div>
</div>

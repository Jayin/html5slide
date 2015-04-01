app = require 'app'
sb = require 'skateboard/core'
BaseMod = require 'skateboard/base-mod'

class Mod extends BaseMod
	cachable: true

	events:
		'change .upload-btn': 'fileChange'

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
			sb.view '/view/canvas'
		img.src = imgUrl

module.exports = Mod

__END__

@@ body.tpl.html
<%
var $ = require('jquery');
var app = require('app');
%>

<!-- include "body.css" -->

<div class="body-inner">
	&nbsp;
	<div class="upload-btn">
		<span>Select Image</span>
		<input type="file" capture="camera" accept="image/*" />
	</div>
</div>

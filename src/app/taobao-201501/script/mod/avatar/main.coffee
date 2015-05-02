app = require 'app'
Skateboard = require 'skateboard'

class Mod extends Skateboard.BaseMod
	cachable: true

	events:
		'change .upload-btn': 'fileChange'
		'click .btn-back': 'back'
		'click .btn-next': 'next'

	_bodyTpl: require './body.tpl.html'
	

	avatarNo: 1

	_afterFadeIn: ->
		if G.goClicked
			G.goClicked = false
			require ['../home/dialog-main'], (dialog)=>
				dialog.on 'confirm', @confirm
				dialog.show()

	render: ->
		super
		G.state.on 'change', @stateChange
		
		# preload next page
		require ['../canvas/main', '../scene/main']

	resetFileInput: ->
		$('.upload-btn input').remove()
		$('<input type="file" capture="camera" accept="image/*" />').appendTo $('.upload-btn')

	fileChange: (evt) =>
		URL = window.URL || window.webkitURL
		file = evt.originalEvent.srcElement.files[0]
		imgUrl = URL.createObjectURL(file)
		img = new Image()
		img.onload = =>
			uploadedImg = 
				file: file
				url: imgUrl
				width: img.naturalWidth
				height: img.naturalHeight
			G.state.set uploadedImg: uploadedImg
			@resetFileInput()
			Skateboard.core.view '/view/canvas'
		img.src = imgUrl

	back: =>
		#history.back()
		require ['../home/dialog-main'], (dialog)=>
			dialog.show()

	next: =>
		alert '请客官上传靓照'

	stateChange: (evt, obj) =>
		@$('.nick').text obj.nick if obj.nick

	destroy: ->
		super
		G.state.off 'change', @stateChange

	confirm: (evt, nick) =>
		G.state.set
			nick: nick



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
		<div class="avatars">
			<div class="a1">
				<img src="../../../image/avatar/avatar-01.png" />
				<div class="upload-btn">
					<input type="file" capture="camera" accept="image/*" />
				</div>
			</div>
		</div>
		<div class="nick"><%==G.state.get('nick')%></div>
		<button class="img-btn btn-back">返回</button>
		<button class="img-btn btn-next">下一步</button>
	</div>
</div>

app = require 'app'
Skateboard = require 'skateboard'
MegaPixImage = require 'mega-pix-image'
EXIF = require 'exif'
Hammer = require 'hammer'

class Mod extends Skateboard.BaseMod
	cachable: true

	events:
		'touchstart canvas': 'touchStart'
		'touchmove canvas': 'touchMove'
		'touchend canvas': 'touchEnd'
		'click .btn-next': 'confirm'
		'click .btn-back': 'back'

	_bodyTpl: require './body.tpl.html'

	CONTEXT_W: 411
	CONTEXT_H: 411
	ENABLE_ROTATE: false

	render: ->
		super
		@canvas = @$('canvas')[0]
		@context = @canvas.getContext('2d')
		@resetImg G.state.get('uploadedImg')
		G.state.on 'change', @stateChange
		@initPinch()

	initPinch: ->
		toRef = null
		tp1 = null
		tr1 = null
		mc = new Hammer.Manager @canvas
		pinch = new Hammer.Pinch()
		rotate = new Hammer.Rotate()
		pinch.recognizeWith rotate if @ENABLE_ROTATE
		mc.add [pinch, rotate]
		mc.on 'pinchstart', (evt) =>
			@imgWhPinch = 
				w: @imgWh.w
				h: @imgWh.h
			@poPinch = 
				x: @po.x
				y: @po.y
			tp1 = new Date().getTime()
		mc.on 'pinchmove', (evt) =>
			tp2 = new Date().getTime()
			# make the draw smooth
			if tp2 - tp1 > 300
				tp1 = tp2
				@pinchDraw evt.scale
		mc.on 'pinchend', (evt) =>
			@pinchDraw evt.scale
		preDeg = 0
		mc.on 'pinchstart', (evt) =>
			@rotateDeg = @deg
			tr1 = new Date().getTime()
			preDeg = 0
		mc.on 'rotatemove', (evt) =>
			tr2 = new Date().getTime()
			# make the draw smooth
			if tr2 - tr1 > 300 and Math.abs(evt.rotation - preDeg) < 90
				tr1 = tr2
				preDeg = evt.rotation
				@deg = (@rotateDeg + evt.rotation) % 360
				@draw()
		mc.on 'rotateend', (evt) =>
			if Math.abs(evt.rotation - preDeg) < 90
				@deg = (@rotateDeg + evt.rotation) % 360
				@draw()

	pinchDraw: (scale) ->
		@imgWh = 
			w: @imgWhPinch.w * scale
			h: @imgWhPinch.h * scale
		@po = 
			x: @CONTEXT_W / 2 + (@poPinch.x - @CONTEXT_W / 2) * scale
			y: @CONTEXT_H / 2 + (@poPinch.y - @CONTEXT_H / 2) * scale
		@draw()

	touchStart: (evt) =>
		touches = evt.originalEvent.targetTouches
		if touches.length is 1
			touch = touches[0]
			@movePt = 
				x: touch.clientX
				y: touch.clientY
		else
			@movePt = null

	touchMove: (evt) =>
		touches = evt.originalEvent.targetTouches
		if touches.length is 1 and @movePt
			evt.preventDefault()
			touch = touches[0]
			@po.x = @po.x + touch.clientX - @movePt.x
			@po.y = @po.y + touch.clientY - @movePt.y
			@movePt = 
				x: touch.clientX
				y: touch.clientY
			@draw()
		else
			@movePt = null

	touchEnd: (evt) =>
		@movePt = null

	resetImg: (newImg) ->
		app.ajax.showLoading()
		@context.clearRect 0, 0, @CONTEXT_W, @CONTEXT_H
		setTimeout =>
			app.ajax.showLoading()
			@rawImg = newImg
			@po = 
				x: @CONTEXT_W / 2
				y: @CONTEXT_H / 2
			@img = new Image()
			#缩放图片，使图片填满圆圈
			if (newImg.height / @CONTEXT_H) > (newImg.width / @CONTEXT_W)
				@imgWh = 
					w: @CONTEXT_W
					h: newImg.height * @CONTEXT_W / newImg.width
			else
				@imgWh = 
					w: newImg.width * @CONTEXT_H / newImg.height
					h: @CONTEXT_H
			console.log "width:#{@imgWh.w} height:#{@imgWh.h}"
			@img.onload = =>
				EXIF.getData @img, =>
					URL = window.URL || window.webkitURL
					URL.revokeObjectURL @rawImg.url
					# fix ios mega pixel image rendering bug
					orientation = EXIF.getTag @img, 'Orientation'
					if orientation is 3
						@deg = 180
					else if orientation is 6
						@deg = 90
					else if orientation is 8
						@deg = -90
					else
						@deg = 0
					@draw()
					app.ajax.hideLoading()
			@img.src = newImg.url
		, 100

	drawImg: ->
		context = @context
		context.save()
		context.translate @po.x, @po.y
		if @deg
			context.rotate @deg * Math.PI / 180
		# fix ios mega pixel image rendering bug
		MegaPixImage.renderImageToCanvasContext @img, context,
			x: -@imgWh.w / 2
			y: -@imgWh.h / 2
			width: @imgWh.w
			height: @imgWh.h
			doSquash: @rawImg.file.type is 'image/jpeg'
		context.restore()

	drawFrame: ->
		context = @context
		context.save()
		context.globalAlpha = 1
		maskImg = $('#canvas-frame')[0]
		context.drawImage maskImg, 0, 0, @CONTEXT_W, @CONTEXT_H
		context.restore()

	draw: ->
		@context.clearRect 0, 0, @CONTEXT_W, @CONTEXT_H
		@drawImg()
		@drawFrame()

	getClipData: ->
		fw = @CONTEXT_W - 12
		fh = @CONTEXT_H - 12
		@context.clearRect 0, 0, @CONTEXT_W, @CONTEXT_H
		@drawImg()
		tmpCanvas = document.createElement 'canvas'
		tmpCanvas.width = fw
		tmpCanvas.height = fh
		tmpCtx = tmpCanvas.getContext '2d'
		tmpCtx.drawImage @canvas, (@CONTEXT_W - fw) / 2, (@CONTEXT_H - fh) / 2, fw, fh, 0, 0, fw, fh
		@drawFrame()
		imgData = tmpCtx.getImageData 0, 0, fw, fh
		i = 0
		ox = Math.floor fw / 2
		oy = Math.floor fh / 2
		while i < imgData.data.length
			y = Math.floor i / 4 / fw
			x = i / 4 % fw
			if Math.sqrt(Math.pow(Math.abs(x - ox), 2) + Math.pow(Math.abs(y - oy), 2)) > ox
				imgData.data[i + 3] = 0
			i += 4
		tmpCtx.putImageData imgData, 0, 0
		tmpCanvas.toDataURL()

	# 生成分享图片，宽高均为原图片的1/4
	getShareData: ->
		tmpImg = new Image
		tmpImg.src = @getClipData()
		tmpCanvas = document.createElement 'canvas'
		tmpCanvas.width = @CONTEXT_W / 4
		tmpCanvas.height = @CONTEXT_H / 4
		tmpCtx = tmpCanvas.getContext '2d'
		@context.clearRect 0, 0, @CONTEXT_W, @CONTEXT_H
		@drawImg()
		tmpCtx.drawImage @canvas, 0,0,@CONTEXT_W, @CONTEXT_H,  0, 0, @CONTEXT_W / 4, @CONTEXT_H / 4
		@drawFrame()
		maskImg = $('#canvas-frame')[0]
		tmpCtx.drawImage maskImg, 0, 0, @CONTEXT_W, @CONTEXT_H,  0, 0, @CONTEXT_W / 4, @CONTEXT_H / 4
		tmpCanvas.toDataURL()


	back: =>
		history.back()

	confirm: =>
		G.state.set 
			imgData: @getClipData()
			imgDataShare: @getShareData()

		Skateboard.core.view '/view/scene'

	stateChange: (evt, obj) =>
		@$('.nick').text obj.nick if obj.nick
		@resetImg obj.uploadedImg if obj.uploadedImg

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
	<canvas width="411" height="411">
		Your browser does not support HTML5 Canvas.
	</canvas>
	<div class="nick"><%==G.state.get('nick')%></div>
		<button class="img-btn btn-back">返回</button>
	<button class="img-btn btn-next" onclick="G.record('2');">下一步</button>
	<div style="display:none">
		<img id="canvas-frame" src="../../../image/canvas/canvas-frame.png" />
	</div>
</div>


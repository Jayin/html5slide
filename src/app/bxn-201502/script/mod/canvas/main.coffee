app = require 'app'
sb = require 'skateboard/core'
BaseMod = require 'skateboard/base-mod'
MegaPixImage = require 'mega-pix-image'
EXIF = require 'exif'
Hammer = require 'hammer'

class Mod extends BaseMod
	cachable: true

	events:
		'touchstart canvas': 'touchStart'
		'touchmove canvas': 'touchMove'
		'touchend canvas': 'touchEnd'
		'click .btn-confirm': 'confirm'

	_bodyTpl: require './body.tpl.html'

	CONTEXT_W: 310
	CONTEXT_H: 310

	_render: ->
		super
		@canvas = @$('canvas')[0]
		@context = @canvas.getContext('2d')
		require ['../home/main'], (HomeMod) =>
			$(HomeMod).on 'imgchange', @imgChange
			@resetImg HomeMod.img
			@initPinch()

	initPinch: ->
		toRef = null
		t1 = null
		mc = new Hammer.Manager @canvas
		mc.add [new Hammer.Pinch()]
		mc.on 'pinchstart', (evt) =>
			@imgWhPinch = 
				w: @imgWh.w
				h: @imgWh.h
			@poPinch = 
				x: @po.x
				y: @po.y
			t1 = new Date().getTime()
		mc.on 'pinchmove', (evt) =>
			t2 = new Date().getTime()
			# make the draw smooth
			if t2 - t1 > 300
				t1 = t2
				@pinchDraw evt.scale
		mc.on 'pinchend', (evt) =>
			@pinchDraw evt.scale

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
			margin = 50
			w = @imgWh.w
			h = @imgWh.h
			if @orientation is 6 or @orientation is 8
				w = @imgWh.h
				h = @imgWh.w
			@po.x = Math.max(@po.x, -w / 2 + margin)
			@po.x = Math.min(@po.x, @CONTEXT_W + w / 2 - margin)
			@po.y = Math.max(@po.y, -h / 2 + margin)
			@po.y = Math.min(@po.y, @CONTEXT_H + h / 2 - margin)
			@draw()
		else
			@movePt = null

	touchEnd: (evt) =>
		@movePt = null

	imgChange: (evt, newImg) =>
		@resetImg newImg

	resetImg: (newImg) ->
		app.ajax.showLoading()
		@context.clearRect 0, 0, @CONTEXT_W, @CONTEXT_H
		setTimeout =>
			app.ajax.showLoading()
			@rawImg = newImg
			@po = 
				x: @CONTEXT_W / 2
				y: @CONTEXT_H / 2
			@img = img = new Image()
			@imgWh = 
				w: newImg.width * @CONTEXT_H / newImg.height
				h: @CONTEXT_H
			img.src = newImg.url
			EXIF.getData @img, =>
				URL = window.URL || window.webkitURL
				URL.revokeObjectURL @rawImg.url
				@orientation = EXIF.getTag @img, 'Orientation'
				@draw()
				app.ajax.hideLoading()
		, 500

	drawImg: ->
		context = @context
		context.save()
		context.translate @po.x, @po.y
		if @orientation is 3
			context.rotate 180 * Math.PI / 180
		else if @orientation is 6
			context.rotate 90 * Math.PI / 180
		else if @orientation is 8
			context.rotate -90 * Math.PI / 180
		MegaPixImage.renderImageToCanvasContext @img, context,
			x: -@imgWh.w / 2
			y: -@imgWh.h / 2
			width: @imgWh.w
			height: @imgWh.h
			doSquash: @rawImg.file.type is 'image/jpeg'
		context.restore()

	drawMask: ->
		context = @context
		context.save()
		context.globalAlpha = 0.7
		maskImg = $('#face-mask')[0]
		context.drawImage maskImg, 0, 0, @CONTEXT_W, @CONTEXT_H
		context.restore()

	draw: ->
		@context.clearRect 0, 0, @CONTEXT_W, @CONTEXT_H
		@drawImg()
		@drawMask()

	confirm: =>
		fw = 160
		fh = 190
		@context.clearRect 0, 0, @CONTEXT_W, @CONTEXT_H
		@drawImg()
		tmpCanvas = document.createElement 'canvas'
		tmpCanvas.width = fw
		tmpCanvas.height = fh
		tmpCtx = tmpCanvas.getContext '2d'
		tmpCtx.drawImage @canvas, (@CONTEXT_W - fw) / 2, (@CONTEXT_H - fh) / 2, fw, fh, 0, 0, fw, fh
		@drawMask()
		Mod.clipData = tmpCanvas.toDataURL()
		$(Mod).trigger 'clipchange', Mod.clipData
		sb.view '/view/motion'

	destroy: ->
		super
		require ['../home/main'], (HomeMod) =>
			$(HomeMod).off 'imgchange', @imgChange

module.exports = Mod

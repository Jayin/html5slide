app = require 'app'
Skateboard = require 'skateboard'
MegaPixImage = require 'mega-pix-image'
EXIF = require 'exif'
Hammer = require 'hammer'
$ = require 'jquery'

class Mod extends Skateboard.BaseMod
    cachable: true

    events:
        'touchstart canvas': 'touchStart'
        'touchmove canvas': 'touchMove'
        'touchend canvas': 'touchEnd'
        'click .btn-confirm': 'confirm'
        'click .frame-btns__btn': 'changeFrame'

    _bodyTpl: require './body.tpl.html'

    CONTEXT_W: 640
    CONTEXT_H: 960
    ENABLE_ROTATE: false

    frame: 'shidai'
    selectTemplateCode: 'sd'

    _afterFadeIn: ->
        require ['../home/main'], (HomeMod) =>
            if not HomeMod.img
                Skateboard.core.view '/view/home', replaceState: true

    render: ->
        super
        $('#audio1')[0].pause()
        $('#audio1')[0].play()

        @canvas = @$('canvas')[0]
        @context = @canvas.getContext('2d')
        require ['../home/main'], (HomeMod) =>
            if HomeMod.img
                @resetImg HomeMod.img
            else
                Skateboard.core.view '/view/home', replaceState: true
            $(HomeMod).on 'imgchange', @imgChange
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

    imgChange: (evt, newImg) =>
        @resetImg newImg

    changeFrame: (evt) =>
        @frame = $(evt.target).data 'frame'
        @selectTemplateCode = $(evt.target).data 'value'
        @draw()

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
            @imgWh = 
                w: newImg.width * @CONTEXT_H / newImg.height
                h: @CONTEXT_H
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
        , 500

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
        maskImg = $('#frame-' + @frame)[0]
        context.drawImage maskImg, 0, 0, @CONTEXT_W, @CONTEXT_H
        context.restore()

    drawQRCode:->
        context = @context
        context.save()
        img_qr_code = $('#qr_code')[0]
        context.drawImage img_qr_code, 0, 0, img_qr_code.width, img_qr_code.height, @CONTEXT_W-100,@CONTEXT_H-100,100, 100
        context.restore()

    draw: ->
        @context.clearRect 0, 0, @CONTEXT_W, @CONTEXT_H
        @drawImg()
        @drawFrame()
        @drawQRCode()

    confirm: =>
        Mod.clipData = @canvas.toDataURL()
        $(Mod).trigger 'clipchange', Mod.clipData
        #Skateboard.core.view '/view/motion'
        #return
        app.ajax.post
            url: 'web/run/design'
            data:
                imgData: Mod.clipData
                templateCode: @selectTemplateCode
            success: (res) =>
                if res.code is 0
                    location.href = "/static/app/illumirun-201501/share.html?designId=#{res.data.designId}&templateCode=#{@selectTemplateCode}"
                else
                    alert res.code + ': ' + res.msg
            error: ->
                alert '系统繁忙，请您稍后重试。'

    destroy: ->
        super
        require ['../home/main'], (HomeMod) =>
            $(HomeMod).off 'imgchange', @imgChange

module.exports = Mod

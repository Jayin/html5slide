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
        'click .btn-checkin': 'checkin'

    _bodyTpl: require './body.tpl.html'

    CONTEXT_W: 233
    CONTEXT_H: 233
    ENABLE_ROTATE: false

    checkin: =>
        console.log $('.sb-mod--checkin canvas')[0].toDataURL()
        # Skateboard.core.view 'view/success'
        wxOpenId = G.state.get('wxOpenId')
        if G.url_obj.search.state is 'silent'
            # 拍照上传
            app.ajax.post
                url: 'web/egg/upload/sign'
                data:
                    openid: wxOpenId
                    imgData: $('.sb-mod--checkin canvas')[0].toDataURL()
                success: (res)=>
                    if res.code is 0
                        Skateboard.core.view 'view/success'
                    else
                        app.alerts.alert res.msg, 'info', 1000
                error: =>
                    app.alerts.alert '系统繁忙,请稍后再试', 'info', 1000
        else # 微信授权
            app.ajax.post
                url: 'web/egg/wx/sign'
                data:
                    openid: wxOpenId
                success: (res)=>
                    if res.code is 0
                        Skateboard.core.view 'view/success'
                    else
                        app.alerts.alert res.msg, 'info', 1000
                error: ()=>
                    app.alerts.alert '系统繁忙,请稍后再试', 'info', 1000

    _afterFadeIn: ->
        if !G.state.get('wxOpenId')
            Skateboard.core.view '/view/home', replaceState: true
        require ['../home/main'], (chooseImgMod) =>
            # if not chooseImgMod.img || not chooseImgMod.url
            #     Skateboard.core.view '/view/home', replaceState: true
            if not (chooseImgMod.img || chooseImgMod.url)
                Skateboard.core.view '/view/home', replaceState: true


    render: ->
        super

        @canvas = @$('canvas')[0]
        @context = @canvas.getContext('2d')
        require ['../home/main'], (chooseImgMod) =>
            if chooseImgMod.img
                @resetImg chooseImgMod.img
            else if chooseImgMod.url
                @resetImgUrl chooseImgMod.url
            else
                Skateboard.core.view '/view/home', replaceState: true
            $(chooseImgMod).on 'imgchange', @imgChange  #来自拍照
            $(chooseImgMod).on 'imgchange-src', @imgChangeSrc # 来自微信
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

        $('.sb-mod--checkin img').hide()
        $('.sb-mod--checkin canvas').show()

    imgChangeSrc: (evt, url)=>
        @resetImgUrl url

    resetImgUrl: (newUrl)->
        # alert 'resetImgUrl! ==>' +  newUrl
        $('.sb-mod--checkin img')[0].src = newUrl
        $('.sb-mod--checkin img').show()
        $('.sb-mod--checkin canvas').hide()

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

    drawImg: (ctx)->
        context = ctx or @context
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

    draw: ->
        @context.clearRect 0, 0, @CONTEXT_W, @CONTEXT_H
        @drawImg()

    destroy: ->
        super
        require ['../home/main'], (HomeMod) =>
            $(HomeMod).off 'imgchange', @imgChange

module.exports = Mod

app = require 'app'
Skateboard = require 'skateboard'

class Mod extends Skateboard.BaseMod
    cachable: true

    # events:

    _bodyTpl: require './body.tpl.html'


    renderHeaders: (headers)=>
        headers.forEach (header)=>
            img = new Image()
            img.onload = ()=>
                # 源图片
                sx = 0
                sy = 0
                sWidth = img.width
                sHeight = img.height
                # 目标
                dx = 0
                dy = 0
                dWidth = 64
                dHeight = 64
                @context.drawImage(img, sx, sy, sWidth, sHeight, dx, dy, dWidth, dHeight)
            img.src = header.link

    canvas: null
    context: null

    updateHeader: ()=>
        app.ajax.get
            url: 'egg0722/getHeader.json'
            success: (res)=>
                @renderHeaders(res)

            error: ()=>
                app.alerts.alert "系统繁忙请稍后再试"

    _afterFadeIn: ()=>
        @updateHeader()

    render: ->
        super
        @canvas = $('.sb-mod--home canvas')[0]
        @context = @canvas.getContext('2d')



module.exports = Mod

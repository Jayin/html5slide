app = require 'app'
Skateboard = require 'skateboard'
positions = require('./positions')

class Mod extends Skateboard.BaseMod
    cachable: true

    # events:

    _bodyTpl: require './body.tpl.html'

    canvas: null
    context: null

    BigHeaderMaxIndex: 11 # [0,10]共11个
    BigSize: 233 #266 #135 #大图宽高
    SmallHeaderMaxIndex: 15  # [0,14]共15个
    SmallSize: 120 #153 # 78 # 小图宽高

    handleBigHeaders: (headers, index)=>
        for i in [index..index+@BigHeaderMaxIndex-1]
            if headers[i]
                img_url = headers[i].wxPath || G.CDN_ORIGIN + '/' + headers[i].relativePath
                pos_index = 0
                if i == index
                    pos_index = 0
                else if i % @BigHeaderMaxIndex == 0
                    pos_index = @BigHeaderMaxIndex
                else
                    pos_index = i % @BigHeaderMaxIndex
                pos = positions.big[pos_index]
                pos.height = @BigSize
                pos.width = @BigSize
                @loadImage(img_url, pos)
        nextIndex = if @BigHeaderMaxIndex > headers.length then 0 else index + @BigHeaderMaxIndex
        setTimeout ()=>
            @getBigHeaders(nextIndex)
        , 1000 * 5

    getBigHeaders: (index)=>
        console.log 'getBigHeaders==> index=' + index
        app.ajax.get
            url: "web/egg/participants.json?index=#{index}"
            success: (res)=>
                @handleBigHeaders(res.data.participants, index)
            error: ()=>
                app.alerts.alert "系统繁忙,请稍后再试", 'info', 1500

    handleSmallHeaders: (res, index)=>
        for i in [index..index+@SmallHeaderMaxIndex-1]
            if res[i] and res[i][0]
                img_url = res[i][0]
                pos_index = 0
                if i == index
                    pos_index = 0
                else if i % @SmallHeaderMaxIndex == 0
                    pos_index = @SmallHeaderMaxIndex
                else
                    pos_index = i % @SmallHeaderMaxIndex
                pos = positions.small[pos_index]
                pos.height = @SmallSize
                pos.width = @SmallSize
                @loadImage(img_url, pos)
        nextIndex = if index + @SmallHeaderMaxIndex > res.length then 0 else index + @SmallHeaderMaxIndex
        setTimeout ()=>
            @handleSmallHeaders(res, nextIndex)
        , 1000 * 5


    getSmallHeaders: ()=>
        app.ajax.get
            url: 'egg0722/getHeader.json'
            success: (res)=>
                # @renderHeaders(res)
                @handleSmallHeaders(res, 0)
            error: ()=>
                app.alerts.alert "系统繁忙,请稍后再试", 'info', 1500


    loadImage: (url, pos)=>
        console.log "loadImage: #{url}"
        @img = new Image()
        @img.onload = @renderImage.bind(this, @img, pos)
        @img.src = url


    renderImage: (img, pos)=>
        #可能会并发
        # 源图片
        sx = 0
        sy = 0
        sWidth = img.width
        sHeight = img.height
        # 目标
        dx = pos.top
        dy = pos.left
        dWidth = pos.width || 64
        dHeight = pos.height || 64
        @context.drawImage(img, sx, sy, sWidth, sHeight, dx, dy, dWidth, dHeight)

    _afterFadeIn: ()=>
        @loadImage(window.location.origin + '/static/app/egg-20150702/image/home.png', positions.home)
        @getSmallHeaders()
        @getBigHeaders(0)


    render: =>
        super
        @canvas = $('.sb-mod--home canvas')[0]
        @context = @canvas.getContext('2d')


module.exports = Mod

app = require 'app'
Skateboard = require 'skateboard'
positions = require('./positions')

class Mod extends Skateboard.BaseMod
    cachable: true

    events:
        'click #btn-fullscreen': 'fullscreen'

    _bodyTpl: require './body.tpl.html'

    canvas: null
    context: null
    BigIndex: 0 # 大图是分页的
    BigHeaderMaxIndex: 11 # [0,10]共11个
    BigSize: 233 #266 #135 #大图宽高
    SmallHeaderMaxIndex: 15  # [0,14]共15个
    SmallSize: 120 #153 # 78 # 小图宽高

    fullscreen: =>
        window.launchIntoFullscreen(document.documentElement)

    repeatBigHeader: (res, index)=>
        # console.log 'pos_index==>'
        if res[index]
            img_url = res[index].wxPath ||  G.CDN_ORIGIN + '/' + res[index].relativePath#headers[i].wxPath || G.CDN_ORIGIN + '/' + headers[i].relativePath
            pos_index = 0
            if index % @BigHeaderMaxIndex == 0
                pos_index = 0
            else
                pos_index = index % @BigHeaderMaxIndex
            pos = positions.big[pos_index]
            pos.height = @BigSize
            pos.width = @BigSize
            @loadImage(img_url, pos)
            nextIndex = index + 1
            # 该列数据刷新完毕，那就去后台那数据
            if nextIndex >= res.length
                nextIndex = 0
                #如果列表数据条数最大容量，说明改列表是最后一页了，下一页就是返回第0也
                if res.length < @BigHeaderMaxIndex
                    @BigIndex = 0
                else
                    @BigIndex += 1
                setTimeout ()=>
                    @getBigHeaders(@BigIndex, true)
                , 1000 * 5
            else
                setTimeout ()=>
                    @repeatBigHeader(res, nextIndex)
                , 1000 * 5
        else #该页一个都没有 PS.因为若有1个以上，index会确保在这的数组长度范围内
            setTimeout ()=>
                @BigIndex = 0
                @getBigHeaders(@BigIndex, true)
            , 1000 * 5



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
        # setTimeout ()=>
        #     # 加载第1页，从0页开始
        #     @getBigHeaders(1, true)
        # , 1000 * 5
        setTimeout ()=>
            if headers.length < @BigHeaderMaxIndex
                @BigIndex = 0
            else
                @BigIndex += 1
            @getBigHeaders(@BigIndex)

        , 1000 * 5

    #这里的参数index 未每页的第一个编号
    getBigHeaders: (index, repeating)=>
        # console.log 'getBigHeaders==> index=' + index
        app.ajax.get
            url: "web/egg/participants.json?index=#{index}"
            success: (res)=>
                if repeating
                    @repeatBigHeader(res.data.participants, 0)
                else
                    @handleBigHeaders(res.data.participants, 0)
            error: ()=>
                app.alerts.alert "系统繁忙,请稍后再试", 'info', 1500


    repeatSmallHeader: (res, index)=>
        # console.log 'pos_index==>'
        if res[index] && res[index][0]
            img_url = res[index][0]
            pos_index = 0
            if index % @SmallHeaderMaxIndex == 0
                pos_index = 0
            else
                pos_index = index % @SmallHeaderMaxIndex
            # console.log positions.small
            # console.log pos_index
            pos = positions.small[pos_index]
            pos.height = @SmallSize
            pos.width = @SmallSize
            @loadImage(img_url, pos)
            nextIndex = index + 1
            if nextIndex >= res.length
                nextIndex = 0
            setTimeout ()=>
                @repeatSmallHeader(res, nextIndex)
            , 1000 * 5


    handleSmallHeaders: (res, index)=>
        for i in [index..index+@SmallHeaderMaxIndex-1]
            if res[i] and res[i][0]
                img_url = res[i][0]
                pos_index = 0
                if i == index
                    pos_index = 0
                # else if i % @SmallHeaderMaxIndex == 0
                #     pos_index = @SmallHeaderMaxIndex
                else
                    pos_index = i % @SmallHeaderMaxIndex
                pos = positions.small[pos_index]
                pos.height = @SmallSize
                pos.width = @SmallSize
                @loadImage(img_url, pos)
        nextIndex = if index + @SmallHeaderMaxIndex > res.length then 0 else index + @SmallHeaderMaxIndex

        setTimeout ()=>
            @repeatSmallHeader(res, nextIndex)
        , 1000 * 5


    getSmallHeaders: ()=>
        $.get '/egg0728/getHeader.php', (res)=>
                result = JSON.parse(res.trim())
                @handleSmallHeaders(result, 0)


    loadImage: (url, pos)=>
        # console.log "loadImage: #{url}"
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
        if img.width > img.height
            sx = (img.width - img.height) / 2
            sWidth = img.height
        if img.height > img.width
            sy = (img.height - img.width) / 2
            sHeight = img.width
        # 目标
        dx = pos.top
        dy = pos.left
        dWidth = pos.width || 64
        dHeight = pos.height || 64
        @context.drawImage(img, sx, sy, sWidth, sHeight, dx, dy, dWidth, dHeight)

    _afterFadeIn: ()=>
        @loadImage(window.location.origin + '/static/app/egg-20150702/image/home.png', positions.home)
        @getSmallHeaders()
        @getBigHeaders(@BigIndex)


    render: =>
        super
        @canvas = $('.sb-mod--home canvas')[0]
        @context = @canvas.getContext('2d')


module.exports = Mod

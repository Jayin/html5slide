require ['jquery', 'app'], ($, app)->
    tpl = {}

    tpl.blue = [
        G.CDN_ORIGIN + '/static/app/bxn-201502/' +'image/action_blue_straight.png',
        G.CDN_ORIGIN + '/static/app/bxn-201502/' +'image/action_blue_lower_left.png',
        G.CDN_ORIGIN + '/static/app/bxn-201502/' +'image/action_blue_mid_left.png',
        G.CDN_ORIGIN + '/static/app/bxn-201502/' +'image/action_blue_top_left.png',
        G.CDN_ORIGIN + '/static/app/bxn-201502/' +'image/action_blue_lower_right.png',
        G.CDN_ORIGIN + '/static/app/bxn-201502/' +'image/action_blue_mid_right.png',
        G.CDN_ORIGIN + '/static/app/bxn-201502/' +'image/action_blue_top_right.png'
    ]

    tpl.red = [
        G.CDN_ORIGIN + '/static/app/bxn-201502/' +'image/action_red_straight.png',
        G.CDN_ORIGIN + '/static/app/bxn-201502/' +'image/action_red_lower_left.png',
        G.CDN_ORIGIN + '/static/app/bxn-201502/' +'image/action_red_mid_left.png',
        G.CDN_ORIGIN + '/static/app/bxn-201502/' +'image/action_red_top_left.png',
        G.CDN_ORIGIN + '/static/app/bxn-201502/' +'image/action_red_lower_right.png',
        G.CDN_ORIGIN + '/static/app/bxn-201502/' +'image/action_red_mid_right.png',
        G.CDN_ORIGIN + '/static/app/bxn-201502/' +'image/action_red_top_right.png'
    ]

    bg_music = G.CDN_ORIGIN + '/static/app/bxn-201502/image/bg_dance.mp3'

    canvas = $('#action_canvas')[0]
    context = canvas.getContext('2d')
    action_img = null

    CONTEXT_W = 600
    CONTEXT_H = 1067

    avatar = new Image
    avatar_direction =  'straight'
    AvatarTarget_Width = 102
    AvatarTarget_Height = 113
    clolor = 'black'
    play_queue = [] # 播放动作顺序
    timeline = [4000,4500,5000,5500,5800,6100,6600,7300,7800,8300,9000,9500] # 显示的时间点
    isPlaying = false
    retry = 0

    # 人物动作图片加载回调
    app.ajax.showLoading()
    loadImageNumber = 0
    loadImageTotal = 8
    imageLoadCallback = =>
        loadImageNumber += 1
        if loadImageNumber < loadImageTotal
            app.ajax.showLoading()
        else 
            app.ajax.hideLoading()
            drawReady()

    # 人物动作
    action = {}
    action.straight = new Image
    action.top_left = new Image
    action.mid_left = new Image
    action.lower_left = new Image
    action.top_right = new Image
    action.mid_right = new Image
    action.lower_right = new Image


    audio = $('#audio1')[0]

    audio.onloadeddata = imageLoadCallback

    avatar.onload = imageLoadCallback
    action.straight.onload = imageLoadCallback
    action.top_left.onload = imageLoadCallback
    action.mid_left.onload = imageLoadCallback
    action.lower_left.onload = imageLoadCallback
    action.top_right.onload = imageLoadCallback
    action.mid_right.onload = imageLoadCallback
    action.lower_right.onload = imageLoadCallback

    # 播放按钮
    action.start = $('#action_start')[0]

    action_data = 
        straight: 
            top: 0.093
            left: 0.405
            deg: 0
        top_left: 
            top: 0.120
            left: 0.362
            deg: -5
        mid_left: 
            top: 0.270
            left: -0.320
            deg: -45
        lower_left: 
            top:  0.315
            left: -0.305
            deg: -45

        top_right: 
            top: 0.12
            left: 0.395
            deg: -5

        mid_right: 
            top: -0.010
            left: 0.775
            deg: 30
        lower_right: 
            top: -0.071
            left: 0.895
            deg: 45


    drawAction = =>
        context.save()
        context.drawImage(action_img,0,0,CONTEXT_W,CONTEXT_H)
        context.restore()

    drawAvatar = =>
        direction = action_data[avatar_direction]

        deg = direction.deg
        dest_x = CONTEXT_W * direction.left
        dest_y = CONTEXT_H * direction.top
        dest_width = AvatarTarget_Width
        dest_height = AvatarTarget_Height

        context.save()
        context.rotate(deg * Math.PI / 180)
        context.drawImage(avatar, 0, 0, avatar.width, avatar.height, dest_x, dest_y, dest_width, dest_height)
        context.restore()

    # 开始按钮
    drawStart = =>
        context.save()
        context.fillRect(0,0,@CONTEXT_W,@CONTEXT_H)
        context.drawImage(action.start,0,0,CONTEXT_W,CONTEXT_H)
        context.restore()


    draw = =>
        context.clearRect 0, 0, CONTEXT_W, CONTEXT_H
        # drawBackground()
        
        drawAvatar()
        drawAction()

    drawReady = =>
        action_img = action.straight
        avatar_direction = 'straight'
        draw()
        context.save('draw action.start')
        context.drawImage(action.start,0,0,CONTEXT_W,CONTEXT_H)
        context.restore()


    play = =>
        audio.pause();
        audio.currentTime = 0;
        audio.play()
  
        cur_time_point = 0
        action_img =  action.straight
 
        avatar_direction = 'straight'
        draw()

        tmpQueue = app.util.cloneObject(play_queue, 1)
        tmpTimeline = app.util.cloneObject(timeline, 1)

        # 最后要等到第10秒才结束
        tmpQueue[tmpQueue.length] = tmpQueue[tmpQueue.length - 1]
        tmpTimeline[tmpTimeline.length] = 10*1000;


        tmp_action = tmpQueue.shift()
        tmp_time_point = tmpTimeline.shift()

        # 每隔一段时间播放
        repeat = =>
            avatar_direction = tmp_action
            action_img = action[tmp_action]
            draw()

            cur_time_point = tmp_time_point
            tmp_action = tmpQueue.shift()
            tmp_time_point = tmpTimeline.shift()

            if tmp_time_point
                setTimeout ()=>
                        repeat()
                    , tmp_time_point - cur_time_point
            else
                # play is done
                drawReady()
                isPlaying = false
                audio.pause()
                retry += 1

                if retry % 2 != 0
                    play()
                

        setTimeout ()=>
            repeat()
        , tmp_time_point - cur_time_point
        
    parser = (url) ->
        a = document.createElement('a')
        a.href = url

        search = (search) ->
            if !search
              return {}
            ret = {}
            search = search.slice(1).split('&')
            i = 0
            arr = undefined
            while i < search.length
              arr = search[i].split('=')
              key = arr[0]
              value = arr[1]
              if /\[\]$/.test(key)
                ret[key] = ret[key] or []
                ret[key].push value
              else
                ret[key] = value
              i++
            return  ret

        return {
            protocol: a.protocol
            host: a.host
            hostname: a.hostname
            pathname: a.pathname
            search: search(a.search)
            hash: a.hash
        }


    # 先画出播放按钮
    drawStart()
    # 获取designId -> 获取设计顺序
    url_obj = parser(window.location)
    designId = url_obj.search.designId

    #  判断是否来朋友圈
    from = url_obj.search.from

    if from
        $('.group-share-finish-timeline').show()
        $('.group-share-finish-default').hide()      
    else
        $('.group-share-finish-timeline').hide()
        $('.group-share-finish-default').show()

    app.ajax.get
        url: "web/bxn/design/#{designId}"
        success: (result)->
            if result.code is 0
                avatar.src = G.CDN_ORIGIN + '/'  + result.data.relativePath
                color = result.data.color
                play_queue = result.data.sequence

                audio.src = bg_music
                audio.load()

                action.straight.src = tpl[color][0]
                action.lower_left.src = tpl[color][1]
                action.mid_left.src = tpl[color][2]
                action.top_left.src = tpl[color][3]
                action.lower_right.src = tpl[color][4]
                action.mid_right.src = tpl[color][5]
                action.top_right.src = tpl[color][6]

            else 
                app.alerts.alert '该视频不存在','info',1500

        error: ->
            app.alerts.alert '系统繁忙，请您稍后重试。','info',1500

    # 播放
    $('#btn-play').on 'click',=>
        if loadImageNumber < loadImageTotal
            app.alerts.alert '加载中,请稍等','info',1500
            return
        if isPlaying
            app.alerts.alert '正在播放', 'info', 1000 
            return
        isPlaying = true
        play()

    # 分享
    $('#btn-finish-share').on 'click', =>
       document.getElementById('dialog-share').style.display = 'block' 

    # 重来
    $('#btn-finish-again').on 'click', =>
        window.location = 'index.html'

    # 定制
    $('#btn-finish-custom').on 'click', =>
        window.location = 'http://www.baoxiniao.com.cn';
    # 惊喜
    $('#btn-finish-suprise').on 'click', =>
        document.getElementById('dialog-suprise').style.display = 'block' 

    # 我也要玩
    $('#btn-finish-want-play').on 'click',=>
        window.location = 'index.html'



     







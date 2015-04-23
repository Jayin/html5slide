require ['jquery', 'app'], ($, app)->
    tpl = {}

    tpl.black = [
        G.CDN_ORIGIN + '/static/app/bxn-201502/' +'image/action_black_straight.png',
        G.CDN_ORIGIN + '/static/app/bxn-201502/' +'image/action_black_lower_left.png',
        G.CDN_ORIGIN + '/static/app/bxn-201502/' +'image/action_black_mid_left.png',
        G.CDN_ORIGIN + '/static/app/bxn-201502/' +'image/action_black_top_left.png',
        G.CDN_ORIGIN + '/static/app/bxn-201502/' +'image/action_black_lower_right.png',
        G.CDN_ORIGIN + '/static/app/bxn-201502/' +'image/action_black_mid_right.png',
        G.CDN_ORIGIN + '/static/app/bxn-201502/' +'image/action_black_top_right.png'
    ]

    tpl.background =  G.CDN_ORIGIN + '/static/app/bxn-201502/' +'image/bg_canvas_play.jpg';
    

    canvas = $('#action_canvas')[0]
    context = canvas.getContext('2d')
    action_img = null

    CONTEXT_W = 600
    CONTEXT_H = 1067

    avatar = null
    avatar_direction =  'straight'
    AvatarTarget_Width = 137
    AvatarTarget_Height = 145
    clolor = 'black'
    play_queue = [] # 播放动作顺序
    timeline = [
        3000,3250,3500,4750,4250,4500,5750,5000,6500,6750,7000,7250

    ] # 显示的时间点
    isPlaying = false

    # 人物动作图片加载回调
    loadImageNumber = 0
    imageLoadCallback = =>
        loadImageNumber += 1
        console.log "load img: #{loadImageNumber}" 
        if loadImageNumber < 7
            app.ajax.showLoading()
        else 
            app.ajax.hideLoading()

    # 人物动作
    action = {}
    action.straight = new Image
    action.top_left = new Image
    action.mid_left = new Image
    action.lower_left = new Image
    action.top_right = new Image
    action.mid_right = new Image
    action.lower_right = new Image

    action.background = new Image


    action.straight.onload = imageLoadCallback
    action.top_left.onload = imageLoadCallback
    action.mid_left.onload = imageLoadCallback
    action.lower_left.onload = imageLoadCallback
    action.top_right.onload = imageLoadCallback
    action.mid_right.onload = imageLoadCallback
    action.lower_right.onload = imageLoadCallback

    action.background.onload = imageLoadCallback
    action.background.src = tpl.background

    console.log action.background

    # 播放按钮
    action.start = $('#action_start')[0]

    action_data = 
        straight: 
            top: 0.060
            left: 0.375
            deg: 0
        top_left: 
            top: 0.08
            left: 0.33
            deg: -5
        mid_left: 
            top: 0.240
            left: -0.360
            deg: -45
        lower_left: 
            top: 0.270
            left: -0.345
            deg: -45

        top_right: 
            top: 0.089
            left: 0.358
            deg: -5

        mid_right: 
            top: -0.035
            left: 0.73
            deg: 30
        lower_right: 
            top: -0.091
            left: 0.865
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
        context.drawImage(action.start,0,0,CONTEXT_W,CONTEXT_H)
        context.restore()

    # 舞台背景
    drawBackground = =>
        context.save()
        context.drawImage(action.background,0,0,CONTEXT_W,CONTEXT_H)
        context.restore()

    draw = =>
        context.clearRect 0, 0, CONTEXT_W, CONTEXT_H
        drawBackground()
        drawAction()
        drawAvatar()


    play = =>
        console.log '开始播放'
        cur_time_point = 0
        action_img =  action.straight
        console.log action
        avatar_direction = 'straight'
        draw()

        tmpQueue = app.util.cloneObject(play_queue, 1)
        tmpTimeline = app.util.cloneObject(timeline, 1)

        console.log '播放信息'
        console.log tmpQueue
        console.log tmpTimeline

        tmp_action = tmpQueue.shift()
        tmp_time_point = tmpTimeline.shift()

        # 每隔一段时间播放
        repeat = =>
            avatar_direction = tmp_action
            action_img = action[tmp_action]
            draw()
            console.log "play action: #{tmp_action}"

            cur_time_point = tmp_time_point
            tmp_action = tmpQueue.shift()
            tmp_time_point = tmpTimeline.shift()

            if tmp_time_point
                setTimeout ()=>
                        repeat()
                    , tmp_time_point - cur_time_point
            else
                # play is done
                drawStart()
                
                console.log '结束播放'
                console.log '原来的isPlaying=' + isPlaying
                isPlaying = false
                

        setTimeout ()=>
            console.log '执行repeate'
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
    app.ajax.get
        url: "web/bxn/design/#{designId}"
        success: (result)->
            console.log result
            if result.code is 0
                avatar = new Image
                avatar.src = G.CDN_ORIGIN + '/'  + result.data.relativePath
                color = result.data.color
                play_queue = result.data.sequence

                action.straight.src = tpl[color][0]
                action.lower_left.src = tpl[color][1]
                action.mid_left.src = tpl[color][2]
                action.top_left.src = tpl[color][3]
                action.lower_right.src = tpl[color][4]
                action.mid_right.src = tpl[color][5]
                action.top_right.src = tpl[color][6]

            else 
                app.alerts.alert '请刷新'

        error: ->
            alert '系统繁忙，请您稍后重试。'


    $('#action_canvas').on 'click',=>
        if loadImageNumber < 7 
            alert('加载中ing,请稍等')
            return
        if isPlaying 
            return
        isPlaying = true
        play()




    # drawAvatar: ->

     







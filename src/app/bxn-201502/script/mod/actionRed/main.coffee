app = require 'app'
Skateboard = require 'skateboard'

class Mod extends Skateboard.BaseMod
    cachable: false

    events:
        'click .btn-top-left': 'click_top_left'
        'click .btn-mid-left': 'click_mid_left'
        'click .btn-lower-left': 'click_lower_left'
        'click .btn-top-right': 'click_top_right'
        'click .btn-mid-right': 'click_mid_right'
        'click .btn-lower-right': 'click_lower_right'
        'click #btn-action-confirm': 'confirm'
        'click #btn-action-reset': 'reset'

    _bodyTpl: require './body.tpl.html'

    CONTEXT_W: 600
    CONTEXT_H: 1067

    action_img: null

    avatar: null # 头像数据(base64)
    avatar_img: new Image
    avatar_direction: 'straight'
    AvatarTarget_Width: 102
    AvatarTarget_Height: 113

    queue: [] # 选择的顺序
    selectColor: null # 选择的颜色

    action_data:
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

    # 人物动作
    action: 
        straight: null
        top_left: null
        mid_left: null
        lower_left: null
        top_right: null
        mid_right: null
        lower_right: null

    # 人物动作图片加载
    loadImageNumber: 0
    loadImageTotal: 7
    imageLoadCallback : =>
        @loadImageNumber += 1
        console.log "load img: #{@loadImageNumber}"
        if @loadImageNumber < @loadImageTotal
            app.ajax.showLoading()
        else 
            app.ajax.hideLoading()
            @draw()


    resize: =>
        wrapper = $('.page-wrapper')
        ww = $(window).width()
        wrapper.height ww * 1067 / 600


    _afterFadeIn: =>
        @resize()

    render: =>
        super

        @resize()

        $audio = $('#audio1')[0]
        console.log $audio
        if $('#audio-btn').hasClass('on')
            $audio.pause()
            $audio.play()
        else 
            $audio.pause()

        @canvas = @$('#action_canvas')[0]
        @context = @canvas.getContext('2d')

        require ['../canvas/main'],(CanvasMod) =>
            if CanvasMod.color and CanvasMod.clipData
                @avatar_img.onload = =>
                    @draw()

                @avatar = CanvasMod.clipData
                @avatar_img.src = CanvasMod.clipData
                @selectColor = CanvasMod.color

                @action.straight = $('#action_straight')[0]
                @action.lower_left = $('#action_lower_left')[0]
                @action.mid_left = $('#action_mid_left')[0]
                @action.top_left = $('#action_top_left')[0]
                @action.lower_right = $('#action_lower_right')[0]
                @action.mid_right = $('#action_mid_right')[0]
                @action.top_right = $('#action_top_right')[0]
                
                # Draw this first
                @action.straight.onload = =>
                    @imageLoadCallback()
                    @action_img =  @action.straight
                    

                @action.top_left.onload = @imageLoadCallback
                @action.mid_left.onload = @imageLoadCallback
                @action.lower_left.onload = @imageLoadCallback
                @action.top_right.onload = @imageLoadCallback
                @action.mid_right.onload = @imageLoadCallback
                @action.lower_right.onload = @imageLoadCallback


                # @action_img =  @action.straight
                # @draw()
            else
                Skateboard.core.view '/view/chooseImg', replaceState: true
        

    drawAction: =>
        context = @context

        context.save()
        if @action_img
            context.drawImage(@action_img,0,0,@CONTEXT_W,@CONTEXT_H)
        context.restore()

    drawAvatar: =>
        context = @context
        direction = @action_data[@avatar_direction]
        
        deg = direction.deg
        dest_x = @CONTEXT_W * direction.left
        dest_y = @CONTEXT_H * direction.top
        dest_width = @AvatarTarget_Width
        dest_height = @AvatarTarget_Height

        context.save()
        context.rotate(deg * Math.PI / 180)
        context.drawImage(@avatar_img, 0, 0, @avatar_img.width, @avatar_img.height, dest_x, dest_y, dest_width, dest_height)
        context.restore()

    draw: =>
        @context.clearRect 0, 0, @CONTEXT_W, @CONTEXT_H
       
        @drawAvatar()
        @drawAction()
        
    addActionQueue: (action)=>
        if @queue.length >= 12 
            return
        @queue.push action
        $("#round-#{@queue.length}").removeClass().addClass("round round-#{action}")


    click_top_left: =>
        @action_img = @action.top_left
        @avatar_direction = 'top_left'
        @addActionQueue(@avatar_direction)
        @draw()

    click_mid_left: =>
        @action_img = @action.mid_left
        @avatar_direction = 'mid_left'
        @addActionQueue(@avatar_direction)
        @draw()

    click_lower_left: =>
        @action_img = @action.lower_left
        @avatar_direction = 'lower_left'
        @addActionQueue(@avatar_direction)
        @draw()

    click_top_right: =>
        @action_img = @action.top_right
        @avatar_direction = 'top_right'
        @addActionQueue(@avatar_direction)
        @draw()

    click_mid_right: =>
        @action_img = @action.mid_right
        @avatar_direction = 'mid_right'
        @addActionQueue(@avatar_direction)
        @draw()

    click_lower_right: =>
        @action_img = @action.lower_right
        @avatar_direction = 'lower_right'
        @addActionQueue(@avatar_direction)
        @draw()

    confirm: =>
        if @queue.length < 12
            app.alerts.alert '请选择12个动作', 'info', 3000
            return
        console.log 'upload info:'
        console.log @queue
        console.log @selectColor
        console.log @avatar
        app.ajax.post
            url: 'web/bxn/design'
            data:
                imgData: @avatar
                color: @selectColor
                sequence: @queue
            success: (res) =>
                if res.code is 0
                    location.href = "/static/app/bxn-201502/share.html?designId=#{res.data.designId}"
                else
                    alert res.code + ': ' + res.msg
            error: ->
                alert '系统繁忙，请您稍后重试。'


    reset: =>
        # 动作复原
        @action_img =  @action.straight
        @avatar_direction = 'straight'
        @draw()

        @queue = []
        i = 1
        while i <= 12
            $("#round-#{i}").removeClass().addClass('round')
            i++

module.exports = Mod




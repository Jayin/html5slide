app = require 'app'
Skateboard = require 'skateboard'
$ = require 'jquery'

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

    avatar: null # 头像数据(base64)
    avatar_img: null
    avatar_img_arr: null
    action_img: null
    action_img_arr: null

    queue: [] # 选择的顺序
    selectColor: null # 选择的颜色

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
        
        if @loadImageNumber < @loadImageTotal
            app.ajax.showLoading()
        else 
            app.ajax.hideLoading()
            @draw('straight')

    resize: =>
        wrapper = $('.page-wrapper')
        ww = $(window).width()
        wrapper.height ww * 1067 / 600
        wrapper.css 'width', '100%'

    _afterFadeIn: =>
        @resize()

    render: =>
        super

        @resize()

        $audio = $('#audio1')[0]
    
        if $('#audio-btn').hasClass('on')
            $audio.pause()
            $audio.play()
        else 
            $audio.pause()

        @avatar_img_arr = $('#img-avatar');
        @avatar_img = @avatar_img_arr[0]

        @action_img_arr = $('#img-action')
        @action_img = @action_img_arr[0]

        console.log @avatar_img
        console.log @avatar_img_arr
        console.log @action_img
        console.log @action_img_arr


        require ['../canvas/main'],(CanvasMod) =>
            if CanvasMod.color and CanvasMod.clipData

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
                    

                @action.top_left.onload = @imageLoadCallback
                @action.mid_left.onload = @imageLoadCallback
                @action.lower_left.onload = @imageLoadCallback
                @action.top_right.onload = @imageLoadCallback
                @action.mid_right.onload = @imageLoadCallback
                @action.lower_right.onload = @imageLoadCallback


            else
                Skateboard.core.view '/view/chooseImg', replaceState: true
        

    drawAction: (action_name)=>
        @action_img.src = @action[action_name].src

    drawAvatar:(action_name) =>
        @avatar_img_arr.removeClass().addClass("img-avatar action-#{action_name}")

    draw: (action_name)=>
       
        @drawAvatar(action_name)
        @drawAction(action_name)
        
    addActionQueue: (action_name)=>
        if @queue.length >= 12 
            return
        @queue.push action_name
        $("#round-#{@queue.length}").removeClass().addClass("round round-#{action_name}")


    click_top_left: =>
        @addActionQueue('top_left')
        @draw('top_left')

    click_mid_left: =>
        @addActionQueue('mid_left')
        @draw('mid_left')

    click_lower_left: =>
        @addActionQueue('lower_left')
        @draw('lower_left')

    click_top_right: =>
        @addActionQueue('top_right')
        @draw('top_right')

    click_mid_right: =>
        @addActionQueue('mid_right')
        @draw('mid_right')

    click_lower_right: =>
        @addActionQueue('lower_right')
        @draw('lower_right')

    confirm: =>
        if @queue.length < 12
            app.alerts.alert '请选择12个动作', 'info', 3000
            return

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
        @draw('straight')

        @queue = []
        i = 1
        while i <= 12
            $("#round-#{i}").removeClass().addClass('round')
            i++

module.exports = Mod




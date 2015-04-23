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
    blackTpl = require './black.tpl.html'
    blueTpl = require './blue.tpl.html'

    CONTEXT_W: 600
    CONTEXT_H: 1067

    action_img: null

    avatar: null # 头像数据(base64)
    avatar_direction: 'straight'
    AvatarTarget_Width: 137
    AvatarTarget_Height: 145

    queue: [] # 选择的顺序
    selectColor: null # 选择的颜色

    action_data:
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

    render: =>
        super
        @canvas = @$('#action_canvas')[0]
        @context = @canvas.getContext('2d')


        require ['../canvas/main'],(CanvasMod) =>
            if CanvasMod.color and CanvasMod.clipData
                @addClothesImage(CanvasMod.color)
                @action_straight = $("#action_#{CanvasMod.color}_straight")[0]
                @action_top_left = $("#action_#{CanvasMod.color}_top_left")[0]
                @action_mid_left = $("#action_#{CanvasMod.color}_mid_left")[0]
                @action_lower_left = $("#action_#{CanvasMod.color}_lower_left")[0]
                @action_top_right = $("#action_#{CanvasMod.color}_top_right")[0]
                @action_mid_right = $("#action_#{CanvasMod.color}_mid_right")[0]
                @action_lower_right = $("#action_#{CanvasMod.color}_lower_right")[0]

                @avatar = CanvasMod.clipData
                @selectColor = CanvasMod.color
    
                @action_straight.onload = =>
                    @action_img =  @action_straight
                    @draw()
                
                
            else
                Skateboard.core.view '/view/chooseImg', replaceState: true

    addClothesImage:(color) ->
        ele = $('.action-img-container')
        if color is 'black'
            ele.html(blackTpl.render())
        else
            ele.html(blueTpl.render())

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


        avatar = new Image()
        avatar.src = @avatar

        context.save()
        context.rotate(deg * Math.PI / 180)
        context.drawImage(avatar, 0, 0, avatar.width, avatar.height, dest_x, dest_y, dest_width, dest_height)
        context.restore()

    draw: =>
        @context.clearRect 0, 0, @CONTEXT_W, @CONTEXT_H
        @drawAction()
        @drawAvatar()

    addActionQueue: (action)=>
        if @queue.length >= 12 
            return
        @queue.push action
        $("#round-#{@queue.length}").removeClass().addClass("round round-#{action}")


    click_top_left: =>
        @action_img = @action_top_left
        @avatar_direction = 'top_left'
        @addActionQueue(@avatar_direction)
        @draw()

    click_mid_left: =>
        @action_img = @action_mid_left
        @avatar_direction = 'mid_left'
        @addActionQueue(@avatar_direction)
        @draw()

    click_lower_left: =>
        @action_img = @action_lower_left
        @avatar_direction = 'lower_left'
        @addActionQueue(@avatar_direction)
        @draw()

    click_top_right: =>
        @action_img = @action_top_right
        @avatar_direction = 'top_right'
        @addActionQueue(@avatar_direction)
        @draw()

    click_mid_right: =>
        @action_img = @action_mid_right
        @avatar_direction = 'mid_right'
        @addActionQueue(@avatar_direction)
        @draw()

    click_lower_right: =>
        @action_img = @action_lower_right
        @avatar_direction = 'lower_right'
        @addActionQueue(@avatar_direction)
        @draw()


    confirm: =>
        alert(@queue.length)
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
                console.log res
                alert('request ok')
                if res.code is 0
                    location.href = "/static/app/bxn-201502/share.html?designId=#{res.data.designId}"
                else
                    alert res.code + ': ' + res.msg
            error: ->
                alert '系统繁忙，请您稍后重试。'


    reset: =>
        # 动作复原
        @action_img =  @action_straight
        @avatar_direction = 'straight'
        @draw()

        @queue = []
        i = 1
        while i <= 12
            $("#round-#{i}").removeClass().addClass('round')
            i++

module.exports = Mod


__END__

<%
var $ = require('jquery');
var app = require('app');
%>

@@ black.tpl.html

<img id="action_black_straight" src="../../../image/action_black_straight.png" >
<img id="action_black_lower_left" src="../../../image/action_black_lower_left.png" >
<img id="action_black_mid_left" src="../../../image/action_black_mid_left.png" >
<img id="action_black_top_left" src="../../../image/action_black_top_left.png" >
<img id="action_black_lower_right" src="../../../image/action_black_lower_right.png" >
<img id="action_black_mid_right" src="../../../image/action_black_mid_right.png" >
<img id="action_black_top_right" src="../../../image/action_black_top_right.png" >


@@ blue.tpl.html

<img id="action_black_straight" src="../../../image/action_black_straight.png" >
<img id="action_black_lower_left" src="../../../image/action_black_lower_left.png" >
<img id="action_black_mid_left" src="../../../image/action_black_mid_left.png" >
<img id="action_black_top_left" src="../../../image/action_black_top_left.png" >
<img id="action_black_lower_right" src="../../../image/action_black_lower_right.png" >
<img id="action_black_mid_right" src="../../../image/action_black_mid_right.png" >
<img id="action_black_top_right" src="../../../image/action_black_top_right.png" >




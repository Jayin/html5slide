require ['jquery', 'app', 'http://res.wx.qq.com/open/js/jweixin-1.0.0.js'], ($, app, wx)->

    window.onload = ->
        app.ajax.hideLoading();

    # 调整背景图的高度
    need_height = document.body.clientWidth * 1207 / 750
    (->
        $('.share-bg').css 'background-size', document.body.clientWidth + 'px ' + need_height + "px"
        $('.share-bg').css 'height', need_height + "px"
    )()

    # 根据用户状态显示
    if location.href.indexOf('status=1') != -1 
        $('#btn-share').show()
        $('#btn-again').css('opacity', '1')
        $('#btn-like').css('opacity', '0')
        $('#btn-show').hide()

    else
        $('#btn-share').hide();
        $('#btn-again').css('opacity', '0');
        $('#btn-like').css('opacity', '1');
        $('#btn-show').show();

    # 点赞
    $('#btn-like').on 'click', ->
        console.log "点赞"


    $('#btn-submit').on 'click', ->
        alert('submit')

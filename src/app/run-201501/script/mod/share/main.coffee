require ['jquery', 'app', 'http://res.wx.qq.com/open/js/jweixin-1.0.0.js'], ($, app, wx)->
    wxOpenId = null
    designId = null
    from = null
    likeNum = 0
    alreadyLike = false
    reachReward = false
    frame = "shidai"

    getUrlParameter = (sParam)->
        sPageURL = window.location.search.substring(1);
        sURLVariables = sPageURL.split('&')
        for i in [0...sURLVariables.length]
            sParameterName = sURLVariables[i].split('=')
            if sParameterName[0] == sParam
                return sParameterName[1]
        return null

    getWxOpenId = ()->
        openIdCookie = app.cookie.get('wxopenid');
        if not openIdCookie
            urlParamOpenId = getUrlParameter('code')
            if not urlParamOpenId
                requestOpenIdUrl = "https://open.weixin.qq.com/connect/oauth2/authorize?appid=wxd4f26aea63a05347&redirect_uri=#{encodeURIComponent(location.href.split('#')[0])}&response_type=code&scope=snsapi_base&state=null#wechat_redirect"
                window.location.href = requestOpenIdUrl
            else
                app.cookie.set('wxopenid', urlParamOpenId, G.DOMAIN, '/', 24)
                wxOpenId = urlParamOpenId
        return openIdCookie

    loadDesign = (designId)->
        app.ajax.get 
            url: "web/design/#{designId}"
            success: (result)->
                likeNum = result.data.likeNum
                $("#like-num").text(result.data.likeNum)
                if not G.IS_PROTOTYPE
                    $(".img-preview-size").attr('src', "/" + result.data.relativePath)
                else 
                    $(".img-preview-size").attr('src', result.data.relativePath)

    if not G.IS_PROTOTYPE
        wxOpenId = getWxOpenId()
    designId = getUrlParameter("designId")
    from = getUrlParameter("from")
    frame = getUrlParameter("style")

    loadDesign(designId)

    window.onload = ->
        app.ajax.hideLoading();


    # 调整背景图的高度
    need_height = document.body.clientWidth * 1207 / 750
    (->
        $('.share-bg').css 'background-size', document.body.clientWidth + 'px ' + need_height + "px"
        $('.share-bg').css 'height', need_height + "px"
    )()

    # 根据用户状态显示
    #if location.href.indexOf('status=1') != -1 
    if not from 
        $('#btn-share').show()
        $('#btn-again').css('opacity', '1')
        $('#btn-like').css('opacity', '0')
        $('#btn-show').hide()
        $('.get-prize').show()

    else
        $('#btn-share').hide()
        $('#btn-again').css('opacity', '0')
        $('#btn-like').css('opacity', '1')
        $('#btn-show').show()
        $('.get-prize').show();

    $(".text-slogan-#{frame}").show()

    # 点赞
    $('#btn-like').on 'click', ->
        console.log "点赞"
        app.ajax.post
            url: "web/design/#{designId}"
            contentType: 'application/json; charset=UTF-8'
            data: JSON.stringify
                openId: wxOpenId
            error: (e)->
                alert 'hello error'
            success: (result)->
                alreadyLike = result.data.alreadyLike
                reachReward = result.data.reachReward
                if not alreadyLike
                    $("#like-num").text(likeNum+1)


    $(".get-prize a").on 'click', ->
        # $("#dialog-win").show()
        if likeNum >= 50 or reachReward
            $("#dialog-win").show()
        else
            $("#dialog-nowin").show()


    $('#btn-submit').on 'click', ->
        name = $("#submit-name").val()
        phone = $("#submit-phone").val()
        sex = parseInt($("input:radio[name ='sex']:checked").val())
        if not name 
            alert('名字不能为空')
            return
        if not phone
            alert('电话不能为空')
            return

        app.ajax.post
            url: "web/reward/#{designId}"
            contentType: 'application/json; charset=UTF-8'
            data: JSON.stringify
                name: name
                phone: phone
                sex: sex
                openId: wxOpenId
            success: (result)->
                console.log result
                $("#dialog-win").hide()
                $("#dialog-submit-ok").show()
            error: (e)->
                console.log e
        

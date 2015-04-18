require ['jquery', 'app', 'http://res.wx.qq.com/open/js/jweixin-1.0.0.js'], ($, app, wx)->

    designId = null
    from = null
    templateCode = "sd"

    getUrlParameter = (sParam)->
        sPageURL = window.location.search.substring(1);
        sURLVariables = sPageURL.split('&')
        for i in [0...sURLVariables.length]
            sParameterName = sURLVariables[i].split('=')
            if sParameterName[0] == sParam
                return sParameterName[1]
        return null

    loadDesign = (designId)->
        app.ajax.get 
            url: "web/run/design/#{designId}"
            success: (result)->
                if not G.IS_PROTOTYPE
                    $(".img-preview-size").attr('src', "/" + result.data.relativePath)
                else 
                    $(".img-preview-size").attr('src', result.data.relativePath)


    loadRanklist = ()->
        app.ajax.get
            url:'web/run/templates.json'
            success:(result)->
                jiqing = result.data.templates[4].number;
                haiyang = result.data.templates[3].number;
                zuanshi = result.data.templates[1].number;
                modeng = result.data.templates[2].number;
                shidai   = result.data.templates[0].number;
                total = jiqing + haiyang + zuanshi + modeng + shidai 

                $('#rank-number-jiqing').text(jiqing+'')
                $('#rank-number-haiyang').text(haiyang+'')
                $('#rank-number-zuanshi').text(zuanshi+'')
                $('#rank-number-modeng').text(modeng+'')
                $('#rank-number-shidai').text(shidai+'')

                $('#rank-rating-jiqing').css 'width', (jiqing/total*100) + '%'
                $('#rank-rating-haiyang').css 'width', (haiyang/total*100) + '%'
                $('#rank-rating-zuanshi').css 'width', (zuanshi/total*100) + '%'
                $('#rank-rating-modeng').css 'width', (modeng/total*100) + '%'
                $('#rank-rating-shidai').css 'width', (shidai/total*100) + '%'

            error:->
                alert '系统繁忙，请您稍后重试。'

    designId = getUrlParameter("designId")
    from = getUrlParameter("from")
    templateCode = getUrlParameter("templateCode")

    loadDesign(designId)

    loadRanklist();

    window.onload = ->
        app.ajax.hideLoading();


    # 调整背景图的高度
    need_height = document.body.clientWidth * 1207 / 750
    (->
        $('.share-bg').css 'background-size', document.body.clientWidth + 'px ' + need_height + "px"
        $('.share-bg').css 'height', need_height + "px"

        # 全屏模态框
        $('.modal-full').css 'background-size', document.body.clientWidth + 'px ' + need_height + "px"
        $('.modal-full').css 'height', need_height + "px"
        
    )()

    # 根据用户状态显示
    #if location.href.indexOf('status=1') != -1 
    if not from 
        $('#btn-share').show()
        $('#btn-again').css('opacity', '1')
        $('#btn-like').css('opacity', '0')
        $('#btn-show').hide()
        # $('.get-prize').hide()

    else
        $('#btn-share').hide()
        $('#btn-again').css('opacity', '0')
        $('#btn-like').css('opacity', '1')
        $('#btn-show').show()
        # $('.get-prize').show();

    if not from
        $(".text-slogan-#{frame}").show()
    else 
        $('.text-slogan-timeline').show()


    $(".btn-lottery").on 'click', ->
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
            url: "web/run/user"
            contentType: 'application/json; charset=UTF-8'
            data: JSON.stringify
                name: name
                phone: phone
                sex: sex
                templateCode: templateCode
            success: (result)->
                console.log result
                $("#dialog-win").hide()
                $("#dialog-submit-ok").show()
            error: (e)->
                console.log e
        

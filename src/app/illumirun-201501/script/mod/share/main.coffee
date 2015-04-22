require ['jquery', 'app', 'http://res.wx.qq.com/open/js/jweixin-1.0.0.js'], ($, app, wx)->

    designId = null
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
                $(".img-preview-size").attr('src', G.CDN_ORIGIN + '/' +result.data.relativePath)


    loadRanklist = ()->
        app.ajax.get
            url:'web/run/templates.json'
            success:(result)->
                jiqing = result.data.templates[3].number;
                haiyang = result.data.templates[2].number;
                zuanshi = result.data.templates[4].number;
                modeng = result.data.templates[0].number;
                shidai   = result.data.templates[1].number;
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
    templateCode = getUrlParameter("templateCode")
    frame = templateCode

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
        $('.ranklist-bg').css 'background-size', document.body.clientWidth + 'px ' + need_height + "px"
        $('.ranklist-bg').css 'height', need_height + "px"
        
    )()

    
    $(".text-slogan-#{frame}").show()


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
                $("#dialog-win").hide()
                $("#dialog-submit-ok").show()
            error: (e)->
                console.log e


    $('#btn-ranklist-close').on 'click',()->
        $('.ranklist-bg').hide()
        $('.share-bg').show()

    $('#btn-ranklist').on 'click',()->
        $('.ranklist-bg').show()
        $('.share-bg').hide()
        

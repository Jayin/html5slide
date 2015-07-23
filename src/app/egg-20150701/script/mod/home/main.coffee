app = require 'app'
Skateboard = require 'skateboard'

class Mod extends Skateboard.BaseMod
    cachable: true

    events:
        'change .btn-input': 'fileChange'
        'click .btn-wx': 'goWx'

    _bodyTpl: require './body.tpl.html'

    goWx: ()=>
        # Skateboard.core.view 'view/checkin'
        # 处于静默状态才获取
        if G.url_obj.search.state == 'silent'
            window.location.href = 'redirect.html?wxOpenId=' + window.wxOpenId

    getCheckinState: ()=>
        openId = window.wxOpenId
        alert "getCheckinState: web/egg/participant/" + openId
        app.ajax.get
            url: "web/egg/participant/#{openId}"
            success: (res)=>
                if res.code is 2
                    #未签到
                    app.alerts.alert '未签到', 'info', 1000
                else
                    # 已签到
                    Skateboard.core.view 'view/success'
            error: =>
                app.alerts.alert '系统繁忙,请稍后再试!', 'info', 1000

    handleFromRedirect: ()=>

        # 获取openId + 头像信息就跳转到第二页
        if G.url_obj.search.state != 'silent'
            # 先load头像 + alert提示 =>cc => filechagne()
            tenantId = '54f1b82a58f24d7d16c11e15'
            code = G.url_obj.search.code
            alert('handleFromRedirect: reqeust url=>' +  "web/egg/oauth/#{tenantId}/#{code}")
            app.ajax.post
                url: "web/egg/oauth/#{tenantId}/#{code}"
                success: (res)=>
                    img = new Image()
                    img.onload = =>
                        newImg =
                            file:
                                type: 'image/' + img.src.substring(img.src.lastIndexOf('.') + 1)
                            url: res.data.headimgurl
                            width: img.naturalWidth
                            height: img.naturalHeight
                        Mod.img = newImg
                        $(Mod).trigger 'imgchange', newImg
                        Skateboard.core.view '/view/checkin'
                    img.src = res.data.headimgurl

                error: =>
                    app.alerts.alert '系统繁忙,请稍后再试', 'info', 1000

    _afterFadeIn: ()=>

    render: ->
        super
        # 检测签到情况
        @getCheckinState()
        # 从redirect.html过来
        @handleFromRedirect()

    resetFileInput: ->
        $('.btn-input input').remove()
        $('<input type="file" capture="camera" accept="image/*" />').appendTo $('.btn-input')

    fileChange: (evt) =>

        URL = window.URL || window.webkitURL
        file = evt.originalEvent.srcElement.files[0]
        imgUrl = URL.createObjectURL(file)
        img = new Image()
        img.onload = =>
            newImg =
                file: file
                url: imgUrl
                width: img.naturalWidth
                height: img.naturalHeight
            Mod.img = newImg
            $(Mod).trigger 'imgchange', newImg
            @resetFileInput()
            Skateboard.core.view '/view/checkin'
        img.src = imgUrl


module.exports = Mod

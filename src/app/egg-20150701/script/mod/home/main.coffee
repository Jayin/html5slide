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
            window.location.href = 'redirect.html'

    getCheckinState: ()=>

    handleFromRedirect: ()=>
        # 获取openId + 头像信息就跳转到第二页
        if G.url_obj.search.state != 'silent'
            window.location.href = 'redirect.html'
            # 先load头像 + alert提示 =>cc => filechagne()

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

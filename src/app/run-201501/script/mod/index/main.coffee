require ['jquery', 'app', 'fabric'], ($, app, fabric)->
    window.onload = ()->
        app.ajax.hideLoading()

    need_height = document.body.clientWidth * 1207 / 750

    # 初始化UI：调整高度
    (->
        $('.index-bg').css 'background-size', document.body.clientWidth + 'px ' + need_height + "px"
        $('.index-bg').css 'height', need_height + "px"
        $('.camera').css 'padding-top', need_height * 0.58 + "px"

        # 隐藏设计页面
        $('.index-bg').show()
        $('.design-bg').hide();
    )()


    canvas = new fabric.StaticCanvas('c');

    frame_user = new fabric.Image($('#frame_user')[0])

    frame_haiyang = new fabric.Image($('#frame_haiyang')[0])
    frame_jiqing = new fabric.Image($('#frame_jiqing')[0])
    frame_modeng = new fabric.Image($('#frame_modeng')[0])
    frame_shidai = new fabric.Image($('#frame_shidai')[0])
    frame_zuanshi = new fabric.Image($('#frame_zuanshi')[0])

    # 默认的相框:海洋
    frame_tmp = frame_shidai 
    # 标记选择号
    selected_item = 0;

    

    # 用户选择图片
    $('#btn-upload').on 'change', ->
        input = $(this)[0]
        if (input.files and input.files[0])
            reader = new FileReader()
            reader.onload = (e)->
                img = new Image()
                img.src = e.target.result
                
                img.onload = ->
                    user_pic = null
                    console.log('width'+img.naturalWidth)
                    console.log 'height'+img.naturalHeight

                    dest_height =  if canvas.height > img.naturalHeight then canvas.height else img.naturalHeight


                    if img.naturalHeight > img.naturalWidth
                        user_pic = new fabric.Image(img, {
                              left: 0,
                              top: 0,
                              width: canvas.width, #canvas.width=197
                              height:img.naturalHeight * canvas.width / img.naturalWidth #351
                            })
                    else
                        user_pic = new fabric.Image(img, {
                              left: 0,
                              top: 0,
                              width:img.naturalWidth * canvas.heightv/ imt.naturalHeight, #canvas.width=197
                              height:canvas.height #canva.height=351
                            })

                    console.log(user_pic)
                    canvas.centerObject(user_pic)
                    canvas.add user_pic
                    canvas.add frame_tmp

                    console.log canvas.toDataURL()
                    # 切换到设计页面
                    $('.design-bg').show();
                    $('.index-bg').hide()

            reader.readAsDataURL(input.files[0])

    $('#btn-shidai').on 'click', ->
        selected_item = 0
        canvas.remove(frame_tmp).add(frame_tmp = frame_shidai)

    $('#btn-zuanshi').on 'click', ->
        selected_item = 1
        canvas.remove(frame_tmp).add(frame_tmp = frame_zuanshi)

    $('#btn-modeng').on 'click', ->
        selected_item = 2
        canvas.remove(frame_tmp).add(frame_tmp = frame_modeng)

    $('#btn-haiyang').on 'click', ->
        selected_item = 3
        canvas.remove(frame_tmp).add(frame_tmp = frame_haiyang)

    $('#btn-jiqing').on 'click', ->
        selected_item = 4
        canvas.remove(frame_tmp).add(frame_tmp = frame_jiqing)

    # 重拍
    $('#btn-again').on 'click', ->
        canvas.dispose()        
        $('.design-bg').hide();
        $('.index-bg').show()

    # 完成
    $('#btn-finish').on 'click', ->
        # 发送数据
        data_imgage = canvas.toDataURL('png')

        # $.post 'http://demo.createcdigital.com:8080/uploadImage/54f1b82a58f24d7d16c11e18', {
        #         # 'select':,
        #         'imgData':data_imgage
        #     },(data)->
        #         console.log(data)
        #         alert(data)

        #     ,'json'        

        $.ajax({
            url: 'http://demo.createcdigital.com:8080/wechat/uploadImage/54f1b82a58f24d7d16c11e18.json',
            type: 'post',
            data: JSON.stringify({
                 'imgData':data_imgage
            }),
            dataType: 'json',
            contentType: 'application/json; charset=utf-8',
            error: ->
                alert('Error');
            ,
            success: (result) ->
                console.log result
                # wx.config({
                #     debug: false,
                #     appId: result.data.appId,
                #     timestamp: result.data.timestamp,
                #     nonceStr: result.data.nonceStr,
                #     signature: result.data.signature,
                #     jsApiList: [
                #         'chooseImage'
                #     ]
                # });
        })
        console.log 'item you select:'+selected_item
        console.log(data_imgage)







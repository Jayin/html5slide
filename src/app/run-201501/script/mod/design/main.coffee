require ['jquery', 'app', 'fabric'], ($, app, fabric)->
    # remove the loading manually
    window.onload = ->
        app.ajax.hideLoading()

    canvas = new fabric.StaticCanvas('c');

    $('#frame_user')[0].onload = ->
        console.log "Load Finish!"


    frame_user = new fabric.Image($('#frame_user')[0])

    frame_haiyang = new fabric.Image($('#frame_haiyang')[0])
    frame_jiqing = new fabric.Image($('#frame_jiqing')[0])
    frame_modeng = new fabric.Image($('#frame_modeng')[0])
    frame_shidai = new fabric.Image($('#frame_shidai')[0])
    frame_zuanshi = new fabric.Image($('#frame_zuanshi')[0])

    # 默认的相框
    frame_tmp = frame_haiyang


    canvas.add(frame_user).add(frame_tmp)

    $('#btn-shidai').on 'click', ->
        canvas.remove(frame_tmp).add(frame_tmp = frame_shidai)

    $('#btn-zuanshi').on 'click', ->
        canvas.remove(frame_tmp).add(frame_tmp = frame_zuanshi)

    $('#btn-modeng').on 'click', ->
        canvas.remove(frame_tmp).add(frame_tmp = frame_modeng)

    $('#btn-haiyang').on 'click', ->
        canvas.remove(frame_tmp).add(frame_tmp = frame_haiyang)

    $('#btn-jiqing').on 'click', ->
        canvas.remove(frame_tmp).add(frame_tmp = frame_jiqing)

    # 完成
    $('#btn-finish').on 'click', ->
        # 发送数据
        data_imgage = canvas.toDataURL('png')

        console.log(data_imgage)
   

# 点击各个按钮 替换掉 图片 

# 
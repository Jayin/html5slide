require ['jquery', 'app'], ($,app)->
    window.onload = ()->
        app.ajax.hideLoading()

    need_height = document.body.clientWidth * 1207 / 750

    (->
        $('.index-bg').css 'background-size', document.body.clientWidth + 'px ' + need_height + "px"
        $('.index-bg').css 'height', need_height + "px"
        $('.camera').css 'padding-top', need_height * 0.58 + "px"

    )()

    $('#btn-upload').on 'change', ->
        input = $(this)[0]
        if (input.files and input.files[0])
            reader = new FileReader()
            reader.onload = (e)->
                # $('#img-preview').attr 'src', e.target.result
                # 先按比例缩小，减少传输压力
                canvas =   document.getElementById('c')              
                ctx = canvas.getContext('2d')
                img = new Image()
                img.src = e.target.result
                ctx.drawImage(img,0,0,img.width,img.height,0,0,131,234)

                console.log canvas.toDataURL()
                # upload file here
                $.post('/upload',
                        {
                            'imgData':canvas.toDataURL()
                        }, (data)->
                            alert(data)
                            # TODO 若完成则跳转

                    )
            reader.readAsDataURL(input.files[0])



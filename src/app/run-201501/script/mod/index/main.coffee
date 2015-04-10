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
                $('#img-preview').attr 'src', e.target.result
                # upload file here
                $.post('/image/upload',
                        {
                            'image':e.target.result
                        }, (data)->
                            alert(data)
                            # TODO 若完成则跳转

                    )
            reader.readAsDataURL(input.files[0])



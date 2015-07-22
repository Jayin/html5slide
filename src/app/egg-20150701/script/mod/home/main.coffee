app = require 'app'
Skateboard = require 'skateboard'

class Mod extends Skateboard.BaseMod
    cachable: true

    events:
        'change .btn-input': 'fileChange'
        'click .btn-wx': 'goWx'

    _bodyTpl: require './body.tpl.html'

    goWx: ()=>
        Skateboard.core.view 'view/checkin'

    render: ->
        super

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

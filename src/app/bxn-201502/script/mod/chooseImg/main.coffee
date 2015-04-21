app = require 'app'
Skateboard = require 'skateboard'

class Mod extends Skateboard.BaseMod
    cachable: true

    events:
        'change .upload-btn': 'fileChange'
        'click .btn-choose': 'chose'

    _bodyTpl: require './body.tpl.html'

    resetFileInput: ->
        $('.upload-btn input').remove()
        $('<input type="file" capture="camera" accept="image/*" />').appendTo $('.upload-btn')

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
            Skateboard.core.view '/view/canvas'
        img.src = imgUrl

module.exports = Mod

__END__

@@ body.tpl.html

<!-- include "body.scss" -->

<div class="body-inner">
    &nbsp;
   <div class="upload-btn">
        <input type="file" capture="camera" accept="image/*" />
    </div>
</div>

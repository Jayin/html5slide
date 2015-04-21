app = require 'app'
Skateboard = require 'skateboard'
$ = require 'jquery'

class Mod extends Skateboard.BaseMod
    cachable: true

    events:
        'change .upload-btn': 'fileChange'
        'click .btn-rules': 'showRules'

    _bodyTpl: require './body.tpl.html'

    resetFileInput: ->
        $('.upload-btn input').remove()
        $('<input type="file" capture="camera" accept="image/*" />').appendTo $('.upload-btn')

    fileChange: (evt) =>

        $('#audio1')[0].pause();
        $('#audio1')[0].play();

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

    showRules: =>
        require ['./dialog-main'], (dialog) ->
            dialog.show()

module.exports = Mod

__END__

@@ body.tpl.html
<%
var $ = require('jquery');
var app = require('app');
%>

<!-- include "body.scss" -->

<div class="body-inner">
    &nbsp;
    <div class="upload-btn">
        <input type="file" capture="camera" accept="image/*" />
    </div>
    <button class="img-btn btn-rules">活动规则</button>
</div>

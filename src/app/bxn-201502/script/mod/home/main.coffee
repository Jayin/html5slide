app = require 'app'
Skateboard = require 'skateboard'

class Mod extends Skateboard.BaseMod
    cachable: true

    events:
        'click .btn-next': 'jump'

    _bodyTpl: require './body.tpl.html'

    resize: =>
        wrapper = $('.page-wrapper')
        ww = $(window).width()
        wrapper.height ww * 1208 / 750

    _afterFadeIn: ->
        @resize()

        require ['../chooseImg/main'], (chooseImgMod) =>
            if not chooseImgMod.img
                Skateboard.core.view '/view/home', replaceState: true

    jump: (evt) =>
        Skateboard.core.view '/view/chooseImg'

    render: ->
        super

        @resize()
        
        $audio = $('#audio1')[0]

        if $('#audio-btn').hasClass('on')
            $audio.pause()
            $audio.play()
        else 
            $audio.pause()

module.exports = Mod

__END__

@@ body.tpl.html

<!-- include "body.scss" -->

<div class="body-inner">
    &nbsp;
    <div class="btn-next">
         
    </div>
</div>

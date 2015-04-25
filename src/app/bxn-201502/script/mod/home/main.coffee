app = require 'app'
Skateboard = require 'skateboard'

class Mod extends Skateboard.BaseMod
    cachable: true

    events:
        'click .btn-next': 'jump'

    _bodyTpl: require './body.tpl.html'


    jump: (evt) =>
        Skateboard.core.view '/view/chooseImg'

    render: ->
        super
        $audio = $('#audio1')[0]
        console.log $audio
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

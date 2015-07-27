app = require 'app'
Skateboard = require 'skateboard'

class Mod extends Skateboard.BaseMod
    cachable: true

    events:
        'click .btn-next': 'next'

    _bodyTpl: require './body.tpl.html'

    next: =>
        alert('go next')

    _afterFadeIn: =>
        if !G.state.get('checked')
            Skateboard.core.view 'view/home'

    render: ->
        super


module.exports = Mod

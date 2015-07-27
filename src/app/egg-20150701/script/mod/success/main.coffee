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
        G.state.set({'checked': true})

    render: ->
        super


module.exports = Mod

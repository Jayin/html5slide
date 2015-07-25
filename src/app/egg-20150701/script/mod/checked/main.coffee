app = require 'app'
Skateboard = require 'skateboard'

class Mod extends Skateboard.BaseMod
    cachable: true

    events:
        'click .btn-next': 'next'

    _bodyTpl: require './body.tpl.html'

    next: =>
        alert('go next')

    render: ->
        super

module.exports = Mod

app = require 'app'
Skateboard = require 'skateboard'

class Mod extends Skateboard.BaseMod
    cachable: true

    events:
        'click .btn-next': 'next'

    _bodyTpl: require './body.tpl.html'

    next: =>
        window.location.href = 'http://www.createcdigital.com/egg0728/index.php?a=1'

    _afterFadeIn: =>
        if !G.state.get('wxOpenId')
            Skateboard.core.view '/view/home', replaceState: true
            return
        G.state.set({'checked': true})

    render: ->
        super


module.exports = Mod

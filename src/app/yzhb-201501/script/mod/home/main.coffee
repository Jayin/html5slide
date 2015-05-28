app = require 'app'
Skateboard = require 'skateboard'
$ = require 'jquery'

class Mod extends Skateboard.BaseMod
	cachable: true

	events:
		'click .btn-intro': 'intro'
		'click .btn-s': 'speaker'
		'click .btn-vote': 'vote'

	_bodyTpl: require './body.tpl.html'


	render: ->
		super
		setTimeout ()->
			$('.sb-mod.sb-mod--home').addClass('show-option')
		, 1500

	intro: ->
		Skateboard.core.view '/view/intro'

	speaker: ->
		Skateboard.core.view '/view/speaker'

	vote: ->
		Skateboard.core.view '/view/vote'

module.exports = Mod

__END__

@@ body.tpl.html

<!-- include "body.scss" -->

<div class="body-inner">
	<div class="btn-next btn-intro"></div>
	<div class="btn-next btn-s"></div>
	<div class="btn-next btn-vote"></div>
</div>

app = require 'app'
Skateboard = require 'skateboard'

class Mod extends Skateboard.BaseMod
	cachable: true

	events:
		'click .btn-go': 'showDialog'

	_bodyTpl: require './body.tpl.html'

	render: ->
		super
		require ['./dialog-main'], (dialog) =>
			dialog.on 'confirm', @confirm
		# preload next page
		require ['../avatar/main', '../avatar/default-avatars-main.tpl.html']

	showDialog: =>
		require ['./dialog-main'], (dialog) ->
			dialog.show()

	confirm: (evt, nick) =>
		G.state.set
			nick: nick
		Skateboard.core.view '/view/avatar'

module.exports = Mod

__END__

@@ body.tpl.html
<%
var $ = require('jquery');
var app = require('app');
%>

<!-- include "body.scss" -->

<div class="body-inner">
	<div class="head">
		<img src="../../../image/home/head.png" />
	</div>
	<button class="img-btn btn-go">go</button>
</div>

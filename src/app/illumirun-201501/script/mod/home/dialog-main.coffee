app = require 'app'
Skateboard = require 'skateboard'

dialogTpl = require './dialog.tpl.html'

dialog =
	show: ->
		el = $('.dialog')
		if not el.length
			el = $(dialogTpl.render()).appendTo document.body
			$('.dialog__close', el).on 'click', dialog.hide
		el.fadeIn()

	hide: ->
		$('.dialog').hide()

module.exports = dialog

__END__

@@ dialog.tpl.html
<%
var $ = require('jquery');
var app = require('app');
%>

<!-- include "dialog.scss" -->

<div class="dialog">
	<button class="img-btn dialog__close">close</button>
</div>

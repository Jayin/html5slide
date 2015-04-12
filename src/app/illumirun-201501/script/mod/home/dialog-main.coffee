app = require 'app'
Skateboard = require 'skateboard'

dialogTpl = require './dialog.tpl.html'

dialog =
	show: (content) ->
		el = $('.dialog')
		if not el.length
			el = $(dialogTpl.render()).appendTo document.body
			$('.dialog__close', el).on 'click', dialog.hide
		$('.dialog__content', el).html(content)
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
	<div class="dialog__content">
	</div>
	<a class="dialog__close" href="javascript:void(0);">close</a>
</div>

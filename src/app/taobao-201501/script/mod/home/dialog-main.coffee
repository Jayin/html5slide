$ = require 'jquery'
app = require 'app'

dialogTpl = require './dialog.tpl.html'

dialog = $({})

dialog = $.extend $({}), 
	show: () ->
		el = $('.home-dialog')
		if not el.length
			el = $(dialogTpl.render()).appendTo document.body
			$('.home-dialog__close, .home-dialog__mask', el).on 'click', dialog.hide
			$('.home-dialog__confirm', el).on 'click', ->
				val = $('.home-dialog__input').val()
				if val
					dialog.hide()
					dialog.trigger 'confirm', val
				else
					alert '客官请留下您的大名吧'
		el.fadeIn ->
			$('.home-dialog__input')[0].focus()

	hide: ->
		$('.home-dialog').hide()

module.exports = dialog

__END__

@@ dialog.tpl.html

<!-- include "dialog.scss" -->

<div class="home-dialog">
	<div class="home-dialog__mask"></div>
	<div class="home-dialog__content">
		<input type="text" class="home-dialog__input" maxlength="5" />
		<button class="img-btn home-dialog__confirm">确定</button>
	</div>
	<!-- <button class="img-btn home-dialog__close">关闭</button> -->
</div>

$ = require 'jquery'
hintTpl = require './hint.tpl.html'

shareHint =
	show: ->
		el = $('#follow-hint')
		if not el.length
			el = $(hintTpl.render()).appendTo(document.body)
			$('.dialog-close-btn', el).on 'click', ->
				el.hide()
		el.show()

module.exports = shareHint

__END__

@@ hint.tpl.html

<div id="follow-hint" class="dialog">
	<div class="dialog-content">
		<button class="dialog-close-btn">close</button>
		<img src="<%=G.CDN_BASE%>/app/zegna-201501/image/follow-hint.jpg" style="width: 100%;" />
	</div>
</div>

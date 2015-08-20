$ = require 'jquery'
hintTpl = require './hint.tpl.html'

shareHint =
	show: (img_name)->
		IMG_NAME = img_name || 'follow-hint.jpg'
		el = $('#follow-hint')
		if not el.length
			el = $(hintTpl.render().replace('{IMG_NAME}', IMG_NAME)).appendTo(document.body)
			$('.dialog-close-btn', el).on 'click', ->
				el.hide()
		el.show()

module.exports = shareHint

__END__

@@ hint.tpl.html

<div id="follow-hint" class="dialog">
	<div class="dialog-content" style="top: 50%; margin-top: -137px;">
		<button class="dialog-close-btn">close</button>
		<img src="<%=G.CDN_BASE%>/app/zegna-201501/image/{IMG_NAME}" style="width: 100%;" />
	</div>
</div>

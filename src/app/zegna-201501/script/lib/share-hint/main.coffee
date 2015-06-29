$ = require 'jquery'
hintTpl = require './hint.tpl.html'

shareHint =
	show: ->
		el = $('#share-hint')
		if not el.length
			el = $(hintTpl.render()).appendTo(document.body)
			el.on 'click', ->
				$(document.body).css
					overflow: 'auto'
				el.hide()
		el.show()
		$(document.body).css
			overflow: 'hidden'

module.exports = shareHint

__END__

@@ hint.tpl.html

<div id="share-hint" style="position: fixed; left: 0; right: 0; top: 0; bottom: 0; background-color: rgba(0, 0, 0, .8); z-index: 99; -webkit-transform: translate3d(0, 0, 0);">
	<img src="<%=G.CDN_BASE%>/app/zegna-201501/image/share-hint.png" style="width: 320px; height: 138px; margin-top: -69px; margin-left: -160px; position: absolute; left: 50%; top: 50%;" />
</div>

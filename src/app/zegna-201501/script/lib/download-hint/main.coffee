$ = require 'jquery'
hintTpl = require './hint.tpl.html'

shareHint =
	show: (id) ->
		el = $('#download-hint')
		if not el.length
			el = $(hintTpl.render()).appendTo(document.body)
			$('.dialog-close-btn', el).on 'click', ->
				el.hide()
		$('#download-hint-img')[0].src = 'about:blank'
		$('#download-hint-img')[0].src = "#{G.CDN_BASE}/app/zegna-201501/image/#{id}-download.jpg"
		el.show()

module.exports = shareHint

__END__

@@ hint.tpl.html

<div id="download-hint" class="dialog">
	<div class="dialog-content">
		<button class="dialog-close-btn">close</button>
		<img id="download-hint-img" src="about:blank" style="width: 100%;" />
		<div style="text-align: center; margin-top: 15px; font-size: 0.8rem; color: #888;">
			长按图片即可保存
		</div>
	</div>
</div>

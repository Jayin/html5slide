app = require 'app'
Skateboard = require 'skateboard'

class Mod extends Skateboard.BaseMod
	cachable: true

	_bodyTpl: require './body.tpl.html'

	updateNumber:(number)->
		x = number // 100
		y = number // 10 % 10
		z = number % 10
		numbers = $(".congratulation-number");
		numbers[0].className = 'congratulation-number n n' +  x
		numbers[1].className = 'congratulation-number n n' +  y
		numbers[2].className = 'congratulation-number n n' +  z

	render: ->
		super
		if G.IS_PROTOTYPE
			window.wxOpenId = 'oRhbms-bUW30G_evItTkAlutq_S8'
		app.ajax.get
			url: 'web/strait/participant/' + window.wxOpenId + '.json'
			success: (res) =>
				if res.code is 0
					#显示头像
					$('#congratulation-image-avatar')[0].src = res.data.headimgurl
					@updateNumber(res.data.number || 1)
				else
					app.alerts.alert(res.code + ':' + res.msg)

			error: (err)=>
				console.log(err)
				app.alerts.alert '网络繁忙,请稍后再试'





module.exports = Mod

__END__

@@ body.tpl.html

<!-- include "body.scss" -->

<div class="body-inner">
	<img id="congratulation-image-avatar" src="" class="congratulation-image">
	<div class="congratulation-numbers">
		<div class="congratulation-number n n0"> </div>
		<div class="congratulation-number n n0"> </div>
		<div class="congratulation-number n n0"> </div>
	</div>
</div>

app = require 'app'
Skateboard = require 'skateboard'
$ = require 'jquery'

class Mod extends Skateboard.BaseMod
	cachable: true

	events:
		'click .btn-pre': 'pre'
		'click .btn-next': 'next'
		'click .option': 'choose'
		'click .btn-comfirm': 'comfirm'

	_bodyTpl: require './body.tpl.html'

	_afterFadeIn: ->
		#reset
		$('#option1').attr('data-value',"0");
		$('#option2').attr('data-value',"0");
		$('#option3').attr('data-value',"0");
		$('#option4').attr('data-value',"0");

		$('#option1').removeClass().addClass('option option1-0');
		$('#option2').removeClass().addClass('option option2-0');
		$('#option3').removeClass().addClass('option option3-0');
		$('#option4').removeClass().addClass('option option4-0');


	render: ->
		super

	pre: =>
		Skateboard.core.view '/view/home'

	next: (evt)=>
		Skateboard.core.view '/view/home'

	choose: (evt)=>
		cur_value = parseInt(evt.currentTarget.dataset.value)
		option = parseInt(evt.currentTarget.dataset.option)

		if cur_value + 1 > 3
			cur_value = 0
		else
			cur_value += 1

		evt.currentTarget.dataset.value = cur_value

		evt.currentTarget.className = 'option option{option}-{cur_value}'.replace('{option}',option).replace('{cur_value}', cur_value)

	comfirm: =>
		data = {}
		data.openId = window.wxOpenId
		data.optionOne = parseInt($('#option1').attr('data-value'))
		data.optionTwo = parseInt($('#option2').attr('data-value'))
		data.optionThree = parseInt($('#option3').attr('data-value'))
		data.optionFour = parseInt($('#option4').attr('data-value'))

		sum = data.optionOne + data.optionTwo + data.optionThree + data.optionFour

		if sum != 3
			alert '请投3票'
			return
		app.ajax.post
			url: 'web/forum/vote.json'
			data: data
			success: (res) =>
				if res.code is 0
					alert('投票成功!')
					setTimeout ()->
						Skateboard.core.view '/view/home'
					,1500
				else if res.code is 20
					alert('你已经投票,不能重复投票')
				else
					alert('投票失败,请投3票')

			error: ->
				alert '系统繁忙，请您稍后重试。'

module.exports = Mod

__END__

@@ body.tpl.html

<!-- include "body.scss" -->

<div class="body-inner">
	<div class="option-group">
		<div id="option1" class="option option1-0" data-value="0" data-option="1"></div>
		<div id="option2" class="option option2-0" data-value="0" data-option="2"></div>
		<div id="option3" class="option option3-0" data-value="0" data-option="3"></div>
		<div id="option4" class="option option4-0" data-value="0" data-option="4"></div>
	</div>
	<div class="btn img-btn btn-pre"></div>
	<div class="btn img-btn btn-next"></div>
	<div class="btn img-btn btn-comfirm"></div>
</div>

require ['jquery', 'app'], ($,app)->

	wrapper = $('.page-wrapper');
	wrapper.height(document.documentElement.clientWidth * 604 / 375);

	app.ajax.get
		url: 'web/forum/vote.json'
		success: (res) =>
			console.log res
			if res.code is 0
				$('#optionOne').text res.data.optionOne
				$('#optionTwo').text res.data.optionTwo
				$('#optionThree').text res.data.optionThree
				$('#optionFour').text res.data.optionFour
			else
				alert '获取数据失败'

		error: ->
			alert '系统繁忙，请您稍后重试。'

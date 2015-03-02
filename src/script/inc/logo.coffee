require ['zepto'], ($) ->
	list = ['yao', 'jiu', 'yi', 'qi']

	tween = (remove) ->
		arr = list.concat()
		(() ->
			c = arr.shift()
			if c
				$('.app-logo')[if remove then 'removeClass' else 'addClass'](c)
				if arr.length
					setTimeout arguments.callee, 400
				else
					setTimeout () ->
						tween not remove
					, 5000
		)()

	setTimeout tween, 500
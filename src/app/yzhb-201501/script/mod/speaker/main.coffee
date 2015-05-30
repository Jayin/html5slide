app = require 'app'
Skateboard = require 'skateboard'
$ = require 'jquery'

class Mod extends Skateboard.BaseMod
	cachable: true

	page: 1 # 当前页
	totalPage: 23

	events:
		'click .btn-pre': 'pre'
		'click .btn-next': 'next'

	_bodyTpl: require './body.tpl.html'

	_afterFadeIn: =>
		@page = 1
		@updateScene()

	render: ->
		super
		@page = 1
		@updateScene()

	pre: =>
		@page = @page - 1
		if @page <= 1
			@page = 1
			Skateboard.core.view '/view/home'

		@updateScene()

	next: (evt)=>
		@page = @page + 1
		if @page > @totalPage
			@page = 1
			Skateboard.core.view '/view/home'
		else
			@updateScene()

	updateScene: =>
		if @page == 1
			$('.container-speaker').empty().append('')

		if @page != 1
			require ['../speaker/s-' + @page + '-main.tpl.html'], (tpl)=>
				$('.container-speaker').empty().append tpl.render()
		#preload next page
		nextPage = @page + 1
		if nextPage <= @totalPage
			require ['../speaker/s-' + nextPage + '-main.tpl.html']


module.exports = Mod

__END__

@@ body.tpl.html

<!-- include "body.scss" -->

<div class="body-inner">
	<div class="container container-speaker"></div>
	<div class="btn img-btn btn-pre"></div>
	<div class="btn img-btn btn-next"></div>
</div>

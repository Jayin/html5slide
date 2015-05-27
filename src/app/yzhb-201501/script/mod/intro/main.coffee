app = require 'app'
Skateboard = require 'skateboard'
$ = require 'jquery'

class Mod extends Skateboard.BaseMod
	cachable: true

	page: 1 # 当前页
	totalPage: 7 #总页数

	events:
		'click .btn-pre': 'pre'
		'click .btn-next': 'next'
		'click .shadow': 'nextPage'

	_bodyTpl: require './body.tpl.html'

	_afterFadeIn: =>
		# 还原page的值
		@page = 1
		@updateScene()

	render: ->
		super

		@updateScene()

	pre: =>
		@page = @page - 1
		if @page <= 1
			@page = 1
			Skateboard.core.view '/view/home'

		@updateScene()

	next: (evt)=>
		className = evt.currentTarget.className
		@page = @page + 1
		if @page > @totalPage
			@page = 7
			@nextPage()
		else
		@updateScene()

	nextPage: =>
		if @page == 1
			@page = 2
			@updateScene()
		else if @page == 7
			@page = 1
			Skateboard.core.view '/view/home'

	updateScene: =>
		if @page == 1
			$('#container').html('')

		if @page != 1
			require ['../intro/intro-' + @page + '-main.tpl.html'], (html)->
				$('#container').html html.render()
		#preload next page
		nextPage = @page + 1
		if nextPage <= @totalPage
			require ['../intro/intro-' + nextPage + '-main.tpl.html']


module.exports = Mod

__END__

@@ body.tpl.html

<!-- include "body.scss" -->

<div class="body-inner">
	<div class="shadow" style="height:100%;width:100%;position: absolute;top: 0;bottom: 0;"></div>
	<div id="container"></div>
	<div class="btn img-btn btn-pre"></div>
	<div class="btn img-btn btn-next"></div>
</div>

app = require 'app'
Skateboard = require 'skateboard'
$ = require 'jquery'

class Mod extends Skateboard.BaseMod
	cachable: true

	page: 1 # 当前页
	totalPage: 6 #总页数

	events:
		'click .btn-pre': 'pre'
		'click .shadow-intro': 'next'

	_bodyTpl: require './body.tpl.html'

	_afterFadeIn: =>
		# 还原page的值
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
			$('.container-intro').empty().append('')

		if @page == @totalPage
			$('.intro-container-qrcode').show()
		else
			$('.intro-container-qrcode').hide()

		if @page != 1
			require ['../intro/intro-' + @page + '-main.tpl.html'], (tpl)=>
				$('.container-intro').empty().append tpl.render()
		#preload next page
		nextPage = @page + 1
		if nextPage <= @totalPage
			require ['../intro/intro-' + nextPage + '-main.tpl.html']


module.exports = Mod

__END__

@@ body.tpl.html

<!-- include "body.scss" -->

<div class="body-inner">
	<div class="container container-intro"></div>
	<div class="shadow-intro" style="height:100%;width:100%;position: absolute;top: 20%;bottom: 0;"></div>
	<div class="intro-container-qrcode" style="height: 30%;width: 30%;position: absolute;bottom: 10%;left: 35%;">
		<img src="./image/intro/qrcode.png" style="height: 120px;width: 120px;"></div>
	<div class="btn img-btn btn-pre"></div>
</div>

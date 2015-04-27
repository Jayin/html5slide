app = require 'app'
Skateboard = require 'skateboard'

class Mod extends Skateboard.BaseMod
	cachable: true

	events:
		'click .btn-back': 'back'
		'click .btn-share': 'showShare'
		'click .btn-close': 'closeShare'

	_bodyTpl: require './body.tpl.html'

	render: ->
		super
		designId = app.util.getUrlParam 'designId'
		app.ajax.get
			url: 'web/taobao/design/' + designId
			success: (res) =>
				if res.code is 0
					obj = res.data
					@setAvatar obj.avatar if obj.avatar
					@setScene obj.scene if obj.scene
					$('#good-nick').text obj.nick if obj.nick
					$('.good-price .price').text obj.price if obj.price
				else
					alert res.code + ': ' + res.msg
			error: ->
				alert '系统繁忙，请您稍后重试。'

	setAvatar: (avatar) ->
		if avatar.no is 1
			$('<img id="good-avatar" src="' + avatar.clipData + '" />').appendTo $('#good-wrapper')
		else
			require ['../buy/avatar-0' + avatar.no + '-main.tpl.html'], (tpl) ->
				$(tpl.render()).appendTo $('#good-wrapper')

	setScene: (scene) ->
		$('#good-wrapper')[0].className = 'g' + scene.no
		$('#good-wrapper .good-bg-img').remove()
		require ['../buy/bg-0' + scene.no + '-main.tpl.html'], (tpl) ->
			$(tpl.render()).appendTo $('#good-wrapper')
		if scene.no is 9
			$('#good-customized-good-name').html scene.customized.goodName
			$('#good-customized-good-detail').html scene.customized.goodDetail
			@$('.customize').show()
		else
			@$('.customize').hide()

	showShare: =>
		@$('.share-instruction').removeClass('singlemessage').fadeIn()

	closeShare: =>
		@$('.share-instruction').fadeOut()

	back: =>
		history.back()

module.exports = Mod

__END__

@@ body.tpl.html
<%
var $ = require('jquery');
var app = require('app');
%>

<!-- include "body.scss" -->

<div class="body-inner">
	<div id="good-wrapper">
		<div class="good-price good-price--1">
			<div class="price"></div>
		</div>
		<div id="good-nick"></div>
		<div class="customize">
			<div id="good-customized-good-name"></div>
			<div id="good-customized-good-detail"></div>
		</div>
		<div class="good-actions">
			<img src="../../../image/share/good-action.png" />
			<button class="img-btn btn-back">返回</button>
			<button class="img-btn btn-share">分享</button>
		</div>
		<div class="share-instruction">
			<button class="img-btn btn-close">关闭</button>
		</div>
	</div>
</div>

define(function(require) {
	var $ = require('jquery');
	
	var _modalCallbacks = [];
	var _toRef;
	
	var alerts = {};
	
	alerts.alert = function(content, type, timeout) {
		clearTimeout(_toRef);
		content = content || G.SVR_ERR_MSG;
		type = ({
			info: 'info',
			succ: 'succ',
			error: 'error'
		})[type] || 'error';
		alerts.alert.hide();
		$([
			'<div class="float-alert ' + type + '" style="display: none;">',
				content,
			'</div>'
		].join('')).appendTo(document.body).fadeIn();
		_toRef = setTimeout(function() {
			alerts.alert.hide();
		}, timeout || 5000);
	};

	alerts.alert.hide = function() {
		$('.float-alert').remove();
	};
	
	alerts.modal = function(content, opt) {
		var contentArr = [];
		var container = $('.modal-container');
		if(!container.length) {
			container = $('<div class="modal-container"><div class="modal-mask"></div><div class="modal-dialog"></div></div>').appendTo(document.body);
			$('.modal-mask', container).on('click', function() {
				if($('.modal-btns', container).length) {
					alerts.modal.hide();
				}
			});
		}
		opt = opt || {};
		contentArr.push('<div class="modal-content">' + content + '</div>');
		if(opt.btns) {
			contentArr.push('<div class="modal-btns">');
			$.each(opt.btns, function(i, btn) {
				_modalCallbacks[i] = btn.click;
				contentArr.push('<a data-modal-btn="' + i + '" href="javascript:void(0);">' + btn.text + '</a>');
			});
			contentArr.push('</div>');
		}
		$('.modal-dialog', container).html(contentArr.join(''));
		container.fadeIn(200);
	};

	alerts.modal.hide = function() {
		$('.modal-container').hide();
	};

	$(document.body).on('click', '.alert .icon-close', function(evt) {
		target = evt.target;
		$(target).closest('.alert').remove();
	}).on('click', '.modal-container [data-modal-btn]', function(evt) {
		var i = $(evt.target).data('modal-btn');
		var cb = _modalCallbacks[i];
		alerts.modal.hide();
		if(cb) {
			cb();
		}
	});
	
	return alerts;
});

define(function(require) {
	var $ = require('jquery');

	var toggle = $({});

	function showOne(target, toggleClass) {
		var type;
		target = $(target);
		if(!target.hasClass(toggleClass)) {
			if(toggleClass == 'visible') {
				target.css({display: 'block'});
				target.prop('offsetHeight');
				target.off('webkitTransitionEnd');
			}
			target.addClass(toggleClass);
			type = target.data('type');
			type && toggle.trigger(type + '.on', target);
		}
	};

	function hideOne(target, toggleClass) {
		var type;
		target = $(target);
		if(target.hasClass(toggleClass)) {
			if(toggleClass == 'visible') {
				target.on('webkitTransitionEnd', function() {
					target.css({display: 'none'});
				});
			}
			target.removeClass(toggleClass);
			type = target.data('type');
			type && toggle.trigger(type + '.off', target);
		}
	};

	function hideAll() {
		var types = ['title.menu', 'mini-bar-tab'];
		$.each(types, function(i, type) {
			$('[data-type="' + type + '"]').each(function(i, target) {
				target = $(target);
				var toggleClass = 'visible';
				toggleClass = target.data('toggle-class') || toggleClass;
				if(target.hasClass(toggleClass)) {
					hideOne(target, toggleClass);
				}
			});
		});
	};

	$(document.body).on('click', function(evt) {
		var target = $(evt.target);
		var toggleSelector = target.data('toggle');
		var toggleClass = 'visible';
		if(!toggleSelector) {
			target = target.closest('[data-toggle]');
			toggleSelector = target.data('toggle');
		}
		if(toggleSelector) {
			toggleClass = target.data('toggle-class') || toggleClass;
			target = $(toggleSelector);
			if(target.length) {
				if(target.hasClass(toggleClass)) {
					hideAll();
					hideOne(target, toggleClass);
				} else {
					hideAll();
					showOne(target, toggleClass);
				}
			} else {
				hideAll();
			}
		} else {
			hideAll();
		}
	});
	
	return toggle;
});

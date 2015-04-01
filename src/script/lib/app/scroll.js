define(function(require) {
	var $ = require('jquery');

	function scroll(wrapper, callback, opt) {
		require(['iscroll'], function(iscroll) {
			opt = opt || {};
			wrapper = $(wrapper);
			var topOffset = typeof opt.topOffset != 'undefined' ? opt.topOffset : 40;
			var pullDown = $('.scroll-pull-down', wrapper);
			var pullUp = $('.scroll-pull-up', wrapper);
			var y = NaN;
			var scroller = new iscroll(wrapper[0], {
				click: true,
				hScrollbar: false,
				vScrollbar: false,
				topOffset: topOffset,
				onRefresh: function() {
					pullDown.removeClass('release loading');
					pullUp.removeClass('release loading');
					this.minScrollY = -topOffset;
				},
				onNewPositionStart: opt.onNewPositionStart,
				onScrollMove: function() {
					var x = this.y - y;
					y = this.y;
					opt.onScrollMove && opt.onScrollMove(y);
					if(x > 0) {
						opt.onScrollUp && opt.onScrollUp(y);
					} else if(x < 0) {
						opt.onScrollDown && opt.onScrollDown(y);
					}
					if(pullDown[0]) {
						if(this.y > 5 && !pullDown.hasClass('loading')) {
							pullDown.addClass('release');
							this.minScrollY = 0;
						} else {
							pullDown.removeClass('release');
							if(!pullDown.hasClass('loading')) {
								this.minScrollY = -topOffset;
							}
						}
					}
					if(pullUp[0]) {
						if(this.y + 5 < this.maxScrollY && !pullUp.hasClass('loading') && !pullUp.hasClass('nomore')) {
							pullUp.addClass('release');
						} else {
							pullUp.removeClass('release');
						}
					}
				},
				onScrollEnd: function() {
					opt.onScrollEnd && opt.onScrollEnd(this.y);
					if(pullDown.hasClass('release')) {
						pullDown.addClass('loading');
						opt.pullDownLoad && opt.pullDownLoad();
					}
					if(pullUp.hasClass('release')) {
						pullUp.addClass('loading');
						opt.pullUpLoad && opt.pullUpLoad();
					}
				}
			});
			callback(scroller);
		});
	};
	
	return scroll;
});

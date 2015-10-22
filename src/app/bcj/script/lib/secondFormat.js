define(function() {
	return function(second) {
		second = parseInt(second + '');
		var min = parseInt(second / 60 + '');
		var sec = second % 60;
		var result = min > 10 ? min : '0' + min;
		result += ':' + (sec > 10 ? sec : '0' + sec);
		return result;
	}
});

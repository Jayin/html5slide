module.exports = {
	/**
	 * 判断是否全部都是数字
	 */
	isAllNumber: function(content){
		for(var index in content){
			var x = new Number(content[index]);
			if (x.toString() == 'NaN')
				return false;
		};
		return true;
	},
	/**
	 * 判断是否全部都是英文
	 */
	isAllLetter: function(content){
		return /^[a-zA-Z]+$/.test(content)
	}

}

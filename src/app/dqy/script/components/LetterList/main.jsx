/**
 * 字母列表
 */
var React = require('react');
var $ = require('jquery');
var app = require('app')

module.exports = React.createClass({
	startX: 0,
	startY: 0,
	getInitialState: function(){
		return {
			letters: this.props.letters || [],
			visitable: this.props.visitable || false
		}
	},
	handleItemClick: function(item){
		// console.log('handleItemClick ==>' + item)
		if($('#'+item).length > 0){
			// $(window).scrollTop($('#'+item).offset().top - 30)
			// $('body').animate({scrollTop: $('#'+item).offset().top - 30}, 400)
			$('.page-wrapper').scrollTop(0)
			$('.page-wrapper').scrollTop($('#'+item).offset().top - 30)
		}
	},
	handleTouchStart: function(evt){
		this.startX = evt.nativeEvent.changedTouches[0].clientX;
		this.startY = evt.nativeEvent.changedTouches[0].clientY;
		this.handleItemClick(evt.nativeEvent.target.textContent)
		// console.log('start ==> startX=' + this.startX + '  startY=' + this.startY)
	},
	handleTouchEnd: function(evt){
	},
	handleTouchMove: function(evt){
		evt.preventDefault()
		// console.log(evt)
		var dt = evt.nativeEvent.changedTouches[0].clientY - this.startY;
		var dt_count = Math.round(Math.abs(dt) / evt.target.clientHeight); //位移了多少个字母
		// console.log('Move ==>  clientY=' + evt.nativeEvent.changedTouches[0].clientY + ' dt=' + dt + ' dt_count=' + dt_count)
		if(dt_count<1){
			return
		}
		if (dt > 0){//下滑
			var tmp = evt.target;
			for(var i=0; i<dt_count;i++){
				tmp = tmp.nextElementSibling;
			}
			this.handleItemClick(tmp.textContent)
		}else{//上移
			var tmp = evt.target;
			for(var i=0; i<dt_count;i++){
				tmp = tmp.previousElementSibling;
			}
			this.handleItemClick(tmp.textContent)
		}
	},
	render: function(){
		var createItem = function(item){
			return (
				<div>
					<a className="item-word" href={"#"+item}>{item}</a>
				</div>
			)
		}
		return (
			<div className="side-words" style={{display: this.state.visitable ? "block" : "none"}}>
				{this.state.letters.map(function(item){
					return (
						<div onClick={this.handleItemClick.bind(this, item)} className="item-word"
							onTouchStart={this.handleTouchStart}
							onTouchEnd={this.handleTouchEnd}
							onTouchMove={this.handleTouchMove} >{item}</div>
					)
				}.bind(this))}
			</div>
		)
	},
	componentWillReceiveProps: function(nextProps){
		this.setState({
			letters: nextProps.letters || [],
			visitable: nextProps.visitable || false
		});
	}
});

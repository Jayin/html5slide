/**
 * 字母列表
 */
var React = require('react');
var $ = require('jquery');

module.exports = React.createClass({
	getInitialState: function(){
		return {
			letters: this.props.letters || [],
			visitable: this.props.visitable || false
		}
	},
	handleItemClick: function(item){
		if($('#'+item).length > 0){
			// $(window).scrollTop($('#'+item).offset().top - 30)
			$('body').animate({scrollTop: $('#'+item).offset().top - 30}, 400)
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
						<div onClick={this.handleItemClick.bind(this, item)} className="item-word" >{item}</div>
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

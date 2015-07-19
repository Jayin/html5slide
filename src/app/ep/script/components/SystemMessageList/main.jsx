/**
 * 搜索列表
 */
var React = require('react');


module.exports = React.createClass({
	getInitialState: function(){
		return {
			result: this.props.result
		}
	},
	render: function(){

		return (
			<div className="component-SystemMessageList" style={{padding: '2px'}}>
				{this.props.result.Records.map(function(item, index){
					var color = 'black';
					var square = {
						backgroundColor: 'black',
						height: '10px',
						width: '10px',
						display: 'inline-block',
						padding: '4px'
					};
					if (index % 2 == 0){
						color = 'darkgrey';
						square.backgroundColor = 'darkgrey';
					}
					if (item.ReplyToID != '' && item.ReplyToID != 0 ){
						color = 'red';
						square.backgroundColor = 'red';
					}
					return (
						<div>
							<span style={square}></span>
							<span style={{color: color,
											marginLeft: '4px',
											wordBreak: 'normal',
  											wordWrap: 'break-word'
  										}}>{item.Message}</span>
						</div>
					);
				})}
			</div>
		);
	},

});

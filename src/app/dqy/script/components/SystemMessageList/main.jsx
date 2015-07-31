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
					// var square = {
					// 	backgroundColor: 'black',
					// 	height: '10px',
					// 	width: '10px',
					// 	display: 'inline-block',
					// 	padding: '4px'
					// };
					if (index % 2 == 0){
						color = 'gray';
						// square.backgroundColor = 'gray';
					}
					if (item.ReplyToID != '' && item.ReplyToID != 0 ){
						color = 'red';
						// square.backgroundColor = 'red';
					}
					return (
						<div style={{color: color,
									marginLeft: '4px',
									wordBreak: 'normal',
									wordWrap: 'break-word',
									borderBottom: '1px solid gainsboro',
									paddingTop: '4px' ,
									paddingBottom: '4px'
									}}>
							{item.Floor + '楼：' + item.Message}
						</div>
					);
				})}
			</div>
		);
	},

});

/**
 * 经销商列表
 */
var React = require('react');

module.exports = React.createClass({
	getInitialState: function(){
		return {
			Distributors: this.props.Distributors || []
		}
	},
	render: function(){
		var createItem = function(item){
			return (
				<div>
					<div>经销商：<span>{item.Name}</span></div>
					<div>联系人：<span>{item.Contact}</span></div>
					<div>电 话：<span>{item.Phone}</span></div>
					<div>地 址：<span >{item.Address}</span></div>
					<div>
					  <div className="inline-block" style={{fontSize: '0.85rem'}}>{item.Note}</div>
					</div>
					<div className="driver"></div>
				</div>
			);
		};
		return (
			<div className="component-Distributor" style={{padding: '4px'}}>
				{this.state.Distributors.map(createItem.bind(this))}
			</div>
		);
	}
});

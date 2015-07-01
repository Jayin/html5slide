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
					<div>
					  <div className="inline-block">{item.Name}</div>
					  <div className="inline-block text-margin">
					  	<span>{item.Phone}</span>
					  </div>
					</div>
					<div>
					  <div className="inline-block text-margin">
					  	<span >{item.Address}</span>
					  </div>
					</div>
					<div>
					  <div className="inline-block" style={{fontSize: '0.85rem'}}>{item.Note}</div>
					</div>
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

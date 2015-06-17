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
					  <div className="inline-block text-red text-margin">
					  	$<span className="text-red">2999.00</span>
					  </div>
					</div>
					<div>
					  <div className="inline-block text-gray text-margin">
					  	联系人: <span >{item.Contact}</span><span >{item.Phone}</span>
					  </div>
					</div>
					<div>
					  <div className="inline-block text-gray">本体100% 附体100%</div>
					</div>
				</div>
			);
		};
		return (
			<div className="component-Distributor" style={{padding: '2px'}}>
				{this.state.Distributors.map(createItem.bind(this))}
			</div>
		);
	}
});

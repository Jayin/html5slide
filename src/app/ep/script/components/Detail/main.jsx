/**
 * 产品明细
 */
var React = require('react');

module.exports = React.createClass({
	getInitialState: function(){
		return {
			Accessorys: this.props.Accessorys || [],
			Product: this.props.Product
		}
	},
	render: function(){
		var createItem = function(ele){
			var selectItem = null;
			var itemList = []

			ele.Items.forEach(function(item){
				if(item.IsSelected){
					//根据附体的百分比
					var accessoryPercent =  G.state.get('percent').accessory / 100
					itemList.push(
						<div className="text-left" style={{borderBottom: '1px solid #E0E0E0'}}>
							<div className="inline-block text text-accessory-name" style={{width: '67%'}}>
								{item.Name}
							</div>
							<div className="inline-block text" style={{width: '30%'}}>
								{(Math.round(item.Price * accessoryPercent * 100) / 100).toFixed(2)}
							</div>
						</div>
					);

				}
			});
			return itemList;
		};
		return (
			<div className="component-Detail">
				<div className="table-header text-left">
					<div className="inline-block text" style={{width: '67%'}}>
					  名称
					</div>
					<div className="inline-block text table-header-price" style={{width: '30%'}}>
						单价
					</div>
				</div>

				<div className="text-left" style={{borderBottom: '1px solid #E0E0E0'}}>
					<div className="inline-block text text-accessory-name" style={{width: '67%'}}>
						本体
					</div>
					<div className="inline-block text" style={{width: '30%'}}>
						{(this.props.Product.price).toFixed(2)}
					</div>
				</div>
				{this.state.Accessorys.map(createItem.bind(this))}
			</div>
		);
	}
});

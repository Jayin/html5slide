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
			for (index in ele.Items){
				if (ele.Items[index].IsSelected){
					selectItem = ele.Items[index];
					break;
				}

			}

			if (selectItem){
				//根据附体的百分比
				accessoryPercent =  G.state.get('percent').accessory / 100
				return (
					<div className="text-left" style={{borderBottom: '1px solid #E0E0E0'}}>
						<div className="inline-block text text-accessory-name" style={{width: '67%'}}>
							{selectItem.Name}
						</div>
						<div className="inline-block text" style={{width: '30%'}}>
							{Math.round(selectItem.Price * accessoryPercent * 100) / 100}
						</div>
					</div>
				);
			}
			else
				return ;
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
						{this.props.Product.price}
					</div>
				</div>
				{this.state.Accessorys.map(createItem.bind(this))}
			</div>
		);
	}
});

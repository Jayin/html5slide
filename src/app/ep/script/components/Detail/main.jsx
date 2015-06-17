/**
 * 产品明细
 */
var React = require('react');

module.exports = React.createClass({
	getInitialState: function(){
		return {
			Accessorys: this.props.Accessorys || []
		}
	},
	render: function(){
		var createItem = function(ele){
			var selectItem = null;
			for (index in ele.Items){
				console.log ('deal with->')
				console.log (ele.Items[index])
				if (ele.Items[index].IsSelected){
					selectItem = ele.Items[index];
					break;
				}

			}

			if (selectItem){
				//根据附体的百分比
				accessoryPercent =  G.state.get('percent').accessory / 100
				return (
					<div className="text-center">
						<div className="inline-block text-accessory-name">
							{selectItem.Name}
						</div>
						<div className="float-right inline-block">
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
				<div className="table-header">
					<div className="inline-block">
					  附件名称
					</div>
					<div className="table-header-price float-right">
						￥售价
					</div>
				</div>
				{this.state.Accessorys.map(createItem.bind(this))}
			</div>
		);
	}
});

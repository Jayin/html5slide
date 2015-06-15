/**
 * 附体(产品)属性
 */
var React = require('react');
var app = require('app');
var Skateboard = require('skateboard');
var $ = require('jquery')

var CompanyList = React.createClass({
	getInitialState: function(){
		return {
			Accessorys: this.props.Accessorys || []
		}
	},
	handleItemClick: function(data, evt){
		console.log ('handleItemClick-->')
		console.log (data)
		console.log (evt)
		//处理UI & 更新附件列表
		//全部不选
		$('input[name={value}]'.replace("{value}", data.item.Name)).map(function(index,element){
				element.checked = false;
		});
		//选择点击的
		$('input[data-optionid={id}]'.replace('{id}', data.ele.ID))[0].checked = true;

	},
	render: function(){
		var createItem = function(item){
			return (
				<div>
					<div>{item.Name}</div>
					<ul>
						{item.Items.map(function(ele){
							console.log ('createItem--> Items map-->')
							console.log (item)
							console.log (ele)

							return (
								<li>
									<input onClick={this.handleItemClick.bind(this, {item: item, ele: ele})} type="checkbox" name={item.Name}
									data-price={ele.Price} data-optionid={ele.ID}/>
									<label>{ele.Name}</label>
								</li>
							)
						},this)}
					</ul>
				</div>
			);
		};
		return (
			<div className="component-AccessoryList">
				{this.state.Accessorys.map(createItem.bind(this))}
			</div>
		);
	}
});

module.exports = CompanyList;

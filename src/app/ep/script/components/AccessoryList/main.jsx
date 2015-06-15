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

		//当前选中的是否已经选择了，若是则说明取消该选项
		currentItemIsChecked = data.ele.IsSelected;
		if (currentItemIsChecked){
			$('input[data-optionid={id}]'.replace('{id}', data.ele.ID))[0].checked = false;
		}else{
			//全部不选
			$('input[name={value}]'.replace("{value}", data.item.Name)).map(function(index,element){
					if(element.checked){
						index_pre_selected = index;
					}
					element.checked = false;
			});
			//选择点击的
			$('input[data-optionid={id}]'.replace('{id}', data.ele.ID))[0].checked = true;
		}

		console.log('currentItemIsChecked->'+ currentItemIsChecked)
		//更新当前选择状态
		var Accessorys = this.state.Accessorys;
		var index_item = 0; //附件序列序号
		var index_ele = 0; //选项序列序号
		console.log ('find index-item')
		for (var index in Accessorys){
			console.log(data.item.Name + ' vs ' + Accessorys[index].Name)
			if (data.item.Name == Accessorys[index].Name){
				index_item = index;
				break
			}
		}
		console.log ('find index_ele')
		for (var index in Accessorys[index_item].Items){
			console.log(data.ele.ID + ' vs ' + Accessorys[index_item].Items[index].ID)
			if (data.ele.ID == Accessorys[index_item].Items[index].ID){
				index_ele = index;
				break;
			}
		}
		console.log ('index_item->' + index_item)
		console.log ('index_ele->' + index_ele)

		newItems = Accessorys[index_item].Items.map(function(e){
			e.IsSelected = false;
			return e
		});
		//若是已选择，再次点击就是取消
		if (currentItemIsChecked){
			newItems[index_ele].IsSelected = false;
		}else{
			newItems[index_ele].IsSelected = true;
		}

		Accessorys[index_item].Items = newItems;

		this.setState({Accessorys: Accessorys})
		G.state.set({accessory: Accessorys})

	},
	render: function(){
		var createItem = function(item){
			return (
				<div>
					<div>{item.Name}</div>
					<ul>
						{item.Items.map(function(ele){
							// console.log ('createItem--> Items map-->')
							// console.log (item)
							// console.log (ele)
							var Input;
							if (ele.IsSelected){
								Input = <input onClick={this.handleItemClick.bind(this, {item: item, ele: ele})}
											type="checkbox"
											name={item.Name}
											data-price={ele.Price}
											data-optionid={ele.ID}
											checked="checked"/>
							}else{
								Input = <input onClick={this.handleItemClick.bind(this, {item: item, ele: ele})}
											type="checkbox"
											name={item.Name}
											data-price={ele.Price}
											data-optionid={ele.ID}/>
							}

							return (
								<li>
									{Input}
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

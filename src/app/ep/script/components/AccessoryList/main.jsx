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
	//获得组内有多少个已选项
	_getSelectCount: function(item){
		var count = 0;
		item.Items.forEach(function(ele){
			if(ele.IsSelected){
				count++
			}
		});
		return count;
	},
	//获得组内有多少个必选项
	_getForceCount: function(item){
		var count = 0;
		item.Items.forEach(function(ele){
			if(ele.IsForce){
				count++;
			}
		});
		return count;
	},
	handleItemClick: function(data, evt){
		var ele = data.ele;
		var item = data.item;
		//选项isForce=true，那么不用处理
		if(ele.IsForce){
			return;
		}
		//如果isForce=false
		if(item.IsForce){
			//单选
			if(item.SelectOption == 0){
				//如果该组的必选项 > 1,不用处理
				if(this._getForceCount(item) > 0){
					return;
				}else{// 如果该组的必选项 <= 0 ,其他清空，该项勾选
					item.Items.forEach(function(e, index){
						item.Items[index].IsSelected = false;
					});
					ele.IsSelected = true;
				}

			}else{//多选
				var selectCount = this._getSelectCount(item);
				if(ele.IsSelected){
					selectCount--;
				}
				//如果已选项（不含点击选择项） >= 1，则直接相反
				if(selectCount > 0){
					ele.IsSelected = !ele.IsSelected;
				}else{//如果已选项 =0 （不含点击选择项）则选择
					ele.IsSelected = true;
				}
			}
		}else{
			ele.IsSelected = !ele.IsSelected;
		}
		Accessorys = this.state.Accessorys;

		item.Items[data.eleIndex] = ele;
		Accessorys[data.itemIndex] = item;

		this.setState({Accessorys: Accessorys})
		G.state.set({accessory: Accessorys})

	},
	render: function(){
		var createItem = function(item, itemIndex){
			return (
				<div>
					<div><div className="inline-block name-img"></div>{item.Name}</div>
					<ul>
						{item.Items.map(function(ele, eleIndex){
							var Input;
							if (ele.IsSelected){
								Input = <input
											type="checkbox"
											name={item.Name}
											data-price={ele.Price}
											data-optionid={ele.ID}
											checked="checked"/>
							}else{
								Input = <input
											type="checkbox"
											name={item.Name}
											data-price={ele.Price}
											data-optionid={ele.ID}/>
							}

							return (
								<li onClick={this.handleItemClick.bind(this, {item: item,itemIndex: itemIndex, ele: ele, eleIndex: eleIndex})}>
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
			<div className="component-AccessoryList" style={{padding: '2px'}}>
				{this.state.Accessorys.map(createItem.bind(this))}
			</div>
		);
	}
});

module.exports = CompanyList;

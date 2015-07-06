/**
 * 本体(产品)属性
 * 1. 传入Properties：[],Product[]
 */
var React = require('react');
var app = require('app');
var Skateboard = require('skateboard');

module.exports = React.createClass({
	componentWillReceiveProps: function(nextProps){
		this.setState({
			Properties: nextProps.Properties || [],
			Product: nextProps.Product || {}
		});
	},
	getInitialState: function(){
		return {
			Properties: this.props.Properties || [],
			Product: this.props.Product || {}
		}
	},
	handleItemClick:  function(data,evt){
		evt.preventDefault();
		var product = this.state.Product;
		var index = 0;
		for(; index < product.Items.length; index++){
			if(product.Items[index].Name == data.Name){
				product.Items[index].Text = data.Text
				break;
			}
		}
		index++;
		for(; index < product.Items.length; index++){
			product.Items[index].Text = '';
		}
		this.setState({
			Product : product
		})
		G.state.set({Product: product})
	},
	render: function(){
		var createItem = function(element, index){
			//返回属性列表
			return (
				<div >
					<div><div className="inline-block name-img"></div>{element.Name}</div>
					<ul>
					  {element.Options.map(function(item, i){
					  	var data = {};
						data.Name = element.Name;
						data.Text = item;
						if (item == this.state.Product.Items[index].Text){

						  	return (
						  		<li onClick={this.handleItemClick.bind(this, data)} className="list-item-active">{item}</li>
						  	)
						 } else{
						 	return (
						 		<li onClick={this.handleItemClick.bind(this, data)} >{item}</li>
						 	)
						 }
					  }, this)}
					</ul>
				</div>
			);
		};
		return (
			<div className="component-PropertiesList" style={{padding: '2px'}}>
				{this.state.Properties.map(createItem.bind(this))}
			</div>
		);
	}
});

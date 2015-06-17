/**
 * 本体(产品)属性
 * 1. 传入Properties：[],Product[]
 */
var React = require('react');
var app = require('app');
var Skateboard = require('skateboard');

module.exports = React.createClass({
	getInitialState: function(){
		return {
			Properties: this.props.Properties || [],
			Product: this.props.Product || {}

		}
	},
	handleItemClick:  function(data,evt){
		 evt.preventDefault();
		 G.state.set({companyCode: data.Code})
		 Skateboard.core.view('/view/category')
	},
	render: function(){
		var createItem = function(element, index){
			//返回属性列表
			return (
				<div >
					<div><div className="inline-block name-img"></div>{element.Name}</div>
					<ul>
					  {element.Options.map(function(item, i){
					  	if (item == this.props.Product.Items[index].Text){
						  	return (
						  		<li className="list-item-active">{item}</li>
						  	)
						 } else{
						 	return (
						 		<li>{item}</li>
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

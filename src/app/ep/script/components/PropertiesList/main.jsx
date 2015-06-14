/**
 * 本体(产品)属性
 * 1. 传入Properties：[],Product[]
 */
var React = require('react');
var app = require('app');
var Skateboard = require('skateboard');

var CompanyList = React.createClass({
	getInitialState: function(){
		return {
			Properties: this.props.Properties || [],
			Product: this.props.Product || {}

		}
	},
	handleItemClick:  function(data,evt){
		 evt.preventDefault();
		 console.log(data)
		 G.state.set({companyCode: data.Code})
		 Skateboard.core.view('/view/category')
	},
	render: function(){
		var createItem = function(element, index){

			// var Style_CompanyName = {
			// 	  padding: '8px'
			// };
			console.log ('createItem-->')
			console.log (this.props)
			console.log (this.state)
			//返回属性列表
			return (
				<div >
					<div>{element.Name}</div>
					<ul>
					  {element.Options.map(function(item, i){
					  	console.log('element.Options.map')
					  	console.log('item: '+item+ ' Text: '+this.props.Product.Items[index].Text)
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
			<div className="component-PropertiesList">
				{this.state.Properties.map(createItem.bind(this))}
			</div>
		);
	}
});

module.exports = CompanyList;

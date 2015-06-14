/**
 * 公司列表
 */
var React = require('react');
var app = require('app');
var Skateboard = require('skateboard');

var CompanyList = React.createClass({
	getInitialState: function(){
		return {
			companys: this.props.companys || []
		}
	},
	handleItemClick:  function(data,evt){
		 evt.preventDefault();
		 console.log(data)
		 G.state.set({companyCode: data.Code})
		 Skateboard.core.view('/view/category')
	},
	render: function(){
		var createItem = function(companyObj){

			var Style_CompanyName = {
				  padding: '8px'
			};
			return (
				<div onClick={this.handleItemClick.bind(this, companyObj)}>
					<div style={Style_CompanyName}>
						<span>{companyObj.Name}</span>
					</div>
					<div style={{backgroundColor: 'rgba(128, 128, 128, 0.22)'
								,width: '100%'
								,height: '1px'}}>
					</div>
				</div>
			);
		};
		return (
			<div >
				{this.state.companys.map(createItem.bind(this))}
			</div>
		);
	}
});

module.exports = CompanyList;

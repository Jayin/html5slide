/**
 * 公司列表
 */
var React = require('react');
var app = require('app');
var Skateboard = require('skateboard');

module.exports = React.createClass({
	getInitialState: function(){
		return {
			result: this.props.result || []
		}
	},
	handleItemClick:  function(data,evt){
		 evt.preventDefault();
		 G.state.set({companyCode: data.Code, companyName: data.Name})
		 Skateboard.core.view('/view/category')
	},
	render: function(){
		var createList = function(companyListObject){

			//onClick={this.handleItemClick.bind(this, companyObj)}
			return (
				<div >
					<div className={companyListObject.Name == '' ? "invisitable" : "company-name words"}
						 id={companyListObject.Name}>
						<span>{companyListObject.Name}</span>
					</div>
					<div className="divider-line">
					</div>

					{companyListObject.Children.map(function(companyObj){

						return (
							<div onClick={this.handleItemClick.bind(this, companyObj)}>
								<div className="company-name">
									<span>{companyObj.Name}</span>
								</div>
								<div className="divider-line">
								</div>
							</div>
						)

					}.bind(this))}
				</div>
			);
		};
		return (
			<div className="component-CompanyList">
				{this.props.result.map(createList.bind(this))}
			</div>
		);
	}
});

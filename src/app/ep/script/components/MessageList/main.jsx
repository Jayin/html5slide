/**
 * 产品留言列表
 */
var React = require('react');
var app = require('app');
var $ = require('jquery');

module.exports = React.createClass({
	getInitialState: function(){
		return {
			result: this.props.result || [],
			category: this.props.category
		}
	},
	getMessage: function(pageIndex, pageSize){
		pageIndex = pageIndex || 1;
		pageSize = pageSize || 20;
		var url = '/Data/CategoryNote/{category3ID}'.replace('{category3ID}', this.state.category.id)
			+ '?companyCode={companyCode}'.replace('{companyCode}', this.state.category.companyCode)
			+ '&pageIndex={pageIndex}'.replace('{pageIndex}', pageIndex)
			+ '&pageSize={pageSize}'.replace('{pageSize}', pageSize);
		app.ajax.get(
			{
				url: url,
				success: function(res){
					this.setState({
						result: res
					});
					React.findDOMNode(this.refs.pageIndex).textContent = pageIndex;
				}.bind(this),
				error: function(){
					app.alerts.alert('系统繁忙，请稍后再试')
				}
			}
		);
	},
	handleClickPre: function(){
		var page = parseInt(React.findDOMNode(this.refs.pageIndex).textContent)
		this.getMessage(page-1)
	},
	handleClickNext: function(){
		var page = parseInt(React.findDOMNode(this.refs.pageIndex).textContent)
		this.getMessage(page+1)
	},
	render: function(){

		return (
			<div className="component-MessageList">
				<div >
					{this.state.result.Records && this.state.result.Records.map(function(messageObj){
						return (
							<div className="message-body">
								{messageObj.Message}
							</div>
						)
					}.bind(this))}
				</div>

				<div className="groups">
				    <div onClick={this.handleClickPre} className="inline-block btn">上一页</div>
					<div ref="pageIndex" className="inline-block page">
					    {this.props.result.Index}
					</div>
					<div onClick={this.handleClickNext} className="inline-block  btn">下一页</div>
				</div>
			</div>
		);
	},
	componentWillReceiveProps: function(nextProps){
		this.setState({
			result: this.props.result || [],
			category: this.props.category
		});
		this.getMessage(1);
	},
	componentDidMount: function(){
		this.getMessage(1);
	}
});

/**
 * 产品留言列表
 */
var React = require('react');
var app = require('app');
var $ = require('jquery');
var utils = require('../../utils');

module.exports = React.createClass({
	preMessage: '',
	lastPostTime: 0,
	getInitialState: function(){
		return {
			result: this.props.result || [],
			category: this.props.category
		}
	},
	getMessage: function(pageIndex, pageSize){
		pageIndex = pageIndex || 1;
		pageSize = pageSize || 40;
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
					app.alerts.alert('系统繁忙，请稍后再试', 'info', 1000)
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
	handleClickLeftMessage: function(){
		var $input = $('.component-MessageList input');
		if (Date.now - this.lastPostTime <= 1000){
			app.alerts.alert('留言太快了，请休息一会儿再来', 'info', 1000);
			return;
		}
		if($input.val() == ''){
			app.alerts.alert('留言不能为空', 'info', 1000);
			return;
		}
		if ($input.val() == this.preMessage){
			app.alerts.alert('留言不能与上条相同', 'info', 1000)
			return;
		}
		if (utils.isAllNumber($input.val()) || utils.isAllLetter($input.val())){
			app.alerts.alert('留言不能全为英文、数字', 'info', 1000);
			return;
		}

		app.ajax.post({
			url: "/Data/CategoryNote/{category3ID}".replace('{category3ID}', this.state.category.id),
			data: {
				note: $input.val(),
				companyCode: this.state.category.companyCode
			},
			success: function(res){
				if (res.result){
					this.preMessage = $input.val();
					this.lastPostTime = Date.now;
					$input.val('');
					app.alerts.alert('留言成功', 'info', 1000);
					//刷新到第一页
					this.getMessage(1)
				}else{
					app.alerts.alert(res.message, 'info', 1000)
				}

			}.bind(this),
			error: function(){
				app.alerts.alert('系统繁忙，请稍后再试', 'info', 1000)
			}
		});
	},
	handleRefresh: function(){
		this.getMessage(1)
	},
	render: function(){

		return (
			<div className="component-MessageList">
				<div >
					{this.state.result.Records && this.state.result.Records.map(function(messageObj, index){
						var color = 'black';
						var square = {
							backgroundColor: 'black',
							height: '10px',
							width: '10px',
							display: 'inline-block',
							padding: '4px'
						};
						if (index % 2 == 0){
							color = 'darkgrey';
							square.backgroundColor = 'darkgrey';
						}
						if (messageObj.ReplyToID != '' && messageObj.ReplyToID != 0 ){
							color = 'red';
							square.backgroundColor = 'red';
						}
						return (
							<div className="message-body">
								<span style={square}></span>
								<span style={{color: color,marginLeft: '4px'}}>{messageObj.Message}</span>
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
					<div className="inline-block" style={{marginTop: '4px',width: '100%'}}>
					    <input type="text" placeholder="内容" style={{width: '50%'}} />
					    <button onClick={this.handleClickLeftMessage} className="inline-block">留言</button>
					    <button onClick={this.handleRefresh} className="inline-block">刷新</button>
					</div>
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

var React = require('react');
var app = require('app');
var Skateboard = require('skateboard');
var Style = require('./main.less')
//
var Navigator = React.createClass({
	getInitialState: function(){
		return {
            displayMore: this.props.displayMore || false,
            activeTabNumber: this.props.activeTabNumber || 0
		}
	},
    handleSwitch: function(){
        this.setState({
            displayMore: !this.state.displayMore
        })
    },
    handleTabClick: function(number, evt){
        this.setState({
            activeTabNumber: number
        })
    },
	handleMoreTabClick: function(type, evt){
		console.log('==>'+type);
		this.setState({
			activeTabNumber: -1,
			displayMore: false
		})
	},
	render: function(){
		return (
            <div>
                <style type="text/css" dangerouslySetInnerHTML={{__html: Style.render()}}></style>
                <header className="navigator">
            		<section className="navigator-basic">
            			<nav >
            				<div className="tabs-wrapper">
            					<div className="tabs">
            						<a className={this.state.activeTabNumber === 0?"tab active":"tab"}
                                        onClick={this.handleTabClick.bind(this, 0)}>最新特卖</a>
            						<a className={this.state.activeTabNumber === 1?"tab active":"tab"}
                                        onClick={this.handleTabClick.bind(this, 1)}>人气热销</a>
            						<a className={this.state.activeTabNumber === 2?"tab active":"tab"}
                                        onClick={this.handleTabClick.bind(this, 2)}>女装</a>
            						<a className={this.state.activeTabNumber === 3?"tab active":"tab"}
                                        onClick={this.handleTabClick.bind(this, 3)}>男装</a>
            						<a className={this.state.activeTabNumber === 4?"tab active":"tab"}
                                        onClick={this.handleTabClick.bind(this, 4)}>鞋包</a>
            					</div>
            				</div>
            				<div className="btn-switch" onClick={this.handleSwitch}>
            					<a className={"fa "+(this.state.displayMore?"fa-angle-up":"fa-angle-down")}></a>
            				</div>
            			</nav>
            		</section>
            		<section className={"navigator-more "+ (this.state.displayMore ? "":"undisplay")}>
            			<ul>
            				<li onClick={this.handleMoreTabClick.bind(this, 'quanbu')}>全部</li>
            				<li onClick={this.handleMoreTabClick.bind(this, 'chaoliunvzhuang')}>潮流女装</li>
            				<li onClick={this.handleMoreTabClick.bind(this, 'xingnanfuzhuang')}>型男服装</li>
            				<li onClick={this.handleMoreTabClick.bind(this, 'xiebaoshipin')}>鞋包饰品</li>
            			</ul>
            			<ul>
            				<li onClick={this.handleMoreTabClick.bind(this, 'wentiyule')}>文体娱乐</li>
            				<li onClick={this.handleMoreTabClick.bind(this, 'jujiashenghuo')}>居家生活</li>
            				<li onClick={this.handleMoreTabClick.bind(this, 'kekoumeishi')}>可口美食</li>
            				<li onClick={this.handleMoreTabClick.bind(this, 'meizhuangpeishi')}>美妆配饰</li>
            			</ul>
            		</section>
            	</header>
            </div>
		);
	}
});

module.exports = Navigator;

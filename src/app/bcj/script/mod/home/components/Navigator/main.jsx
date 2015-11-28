var React = require('react');
var app = require('app');
var Style = require('./main.less')
/**
 * 顶部导航
 */
var Navigator = React.createClass({
	getInitialState: function(){
		return {
            displayMore: this.props.displayMore || false,
            activeTab: this.props.activeTab || 'zuixintemai'
		}
	},
    handleSwitch: function(){
        this.setState({
            displayMore: !this.state.displayMore
        })
    },
    handleTabClick: function(activeTab, evt){
        this.setState({
			displayMore: false,
            activeTab: activeTab
        });
		$(window).trigger('navigator-tab-change', activeTab)
    },
	handleMoreTabClick: function(type, evt){
		console.log('==>'+type);
		this.setState({
			activeTab: '',
			displayMore: false
		});

		$(window).trigger('navigator-tab-change', type)
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
            						<a className={this.state.activeTab === 'zuixintemai'?"tab active":"tab"}
                                        onClick={this.handleTabClick.bind(this, 'zuixintemai')}>特卖</a>
									<a className={this.state.activeTab === 'renqirexiao'?"tab active":"tab"}
                                        onClick={this.handleTabClick.bind(this, 'renqirexiao')}>热销</a>
									<a className={this.state.activeTab === 'nvzhuang'?"tab active":"tab"}
                                        onClick={this.handleTabClick.bind(this, 'nvzhuang')}>女装</a>
									<a className={this.state.activeTab === 'nanzhuang'?"tab active":"tab"}
                                        onClick={this.handleTabClick.bind(this, 'nanzhuang')}>男装</a>
									<a className={this.state.activeTab === 'xiebao'?"tab active":"tab"}
                                        onClick={this.handleTabClick.bind(this, 'xiebao')}>鞋包</a>
            					</div>
            				</div>
            				<div className="btn-switch" onClick={this.handleSwitch}>
            					<div className={"icon "+(this.state.displayMore?"icon-arrows-up":"icon-arrows-down")}
									style={{position: 'absolute',top: '44%',left: '6px',right: '0',bottom: '0',width: '32px',height: '17px',zoom: '.6'}}></div>
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

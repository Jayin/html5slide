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
                                        onClick={this.handleTabClick.bind(this, 'zuixintemai')}>最新</a>
									<a className={this.state.activeTab === 'shumawenti'?"tab active":"tab"}
                                        onClick={this.handleTabClick.bind(this, 'shumawenti')}>数码</a>
									<a className={this.state.activeTab === 'chaoliunvzhuang'?"tab active":"tab"}
                                        onClick={this.handleTabClick.bind(this, 'chaoliunvzhuang')}>女装</a>
									<a className={this.state.activeTab === 'xingnanfuzhuang'?"tab active":"tab"}
                                        onClick={this.handleTabClick.bind(this, 'xingnanfuzhuang')}>男装</a>
									<a className={this.state.activeTab === 'xiebaopeishi'?"tab active":"tab"}
                                        onClick={this.handleTabClick.bind(this, 'xiebaopeishi')}>鞋包</a>
            					</div>
            				</div>
            				<div className="btn-switch" onClick={this.handleSwitch}>
            					<div className={"icon "+(this.state.displayMore?"icon-arrows-up":"icon-arrows-down")}
									style={{position: 'absolute',top: '41%',left: '31%',right: '0',bottom: '0',width: '31px',height: '16.5px',zoom: '.6'}}></div>
            				</div>
            			</nav>
            		</section>
            		<section className={"navigator-more "+ (this.state.displayMore ? "":"undisplay")}>
            			<ul>
            				<li onClick={this.handleMoreTabClick.bind(this, 'wentiyule')}>文体娱乐</li>
            				<li onClick={this.handleMoreTabClick.bind(this, 'jujiashenghuo')}>居家生活</li>
            				<li onClick={this.handleMoreTabClick.bind(this, 'kekoumeishi')}>可口美食</li>
            				<li onClick={this.handleMoreTabClick.bind(this, 'hufumeizhuang')}>护肤美妆</li>
            			</ul>
            		</section>
            	</header>
            </div>
		);
	}
});

module.exports = Navigator;

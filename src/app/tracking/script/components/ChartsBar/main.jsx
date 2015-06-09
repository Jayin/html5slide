var React = require('react');
var echarts = require('echarts');
var default_theme = require('./theme-blue')

/**
 * Usage:
 * React.createElement(ChartsBar, {
 * 		id: xxx, 图标唯一id
 * 		option: 跟echarts的option一样,
 * 		theme: 跟echarts的theme一样
 * 		height: 图标高度(px)
 *})
 */

var ChartsBar = React.createClass({
	default_id: 'echarts-bar-container',
	myChart: null,
	updateChart: function(){
		this.myChart = echarts.init(document.getElementById(this.props.id || this.default_id));
		this.myChart.clear()
		this.myChart.setOption(this.props.option);
		this.myChart.setTheme(this.props.theme || default_theme)
	},
	render: function() {
		return (
			<div id={this.props.id || this.default_id} style={{height: (this.props.height || 400) + 'px'}}>
				<p>Loading.....</p>
			</div>
		);
	},
	componentDidUpdate: function(){
		this.updateChart();
	},
	componentDidMount: function(){
		this.updateChart();
	}
});

module.exports = ChartsBar;

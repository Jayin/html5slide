var React = require('react');
var app = require('app');
var Skateboard = require('skateboard');

var ProductList = React.createClass({
	getInitialState: function(){
		return {
		};
	},
	render: function(){
		return (
            <section style={{marginTop: '-30px', background: '#E6E6E6'}}>
        		<div style={{position: 'relative',padding: '5px', borderBottom: '1px solid gainsboro'}}>
        			<div style={{height: '100px', width: '100px'}}>
        				<img src="//gju1.alicdn.com/bao/uploaded/i4/100000130410913683/TB2r4nUgXXXXXczXpXXXXXXXXXX_!!0-0-juitemmedia.jpg_280x410Q50.jpg" style={{width: '100%', height: '100%'}}/>
        			</div>
        			<div style={{top: '0',right: '0', bottom: '0',position: 'absolute', left: '105px', padding: '5px'}}>
        				<div style={{display: 'inline-block', fontSize: '0.9rem'}}>
        					<span style={{display: 'inline-block', background: 'red', color: 'white',padding: '1px'}}>天猫</span>
        					女包2015秋冬潮新款手提时尚毛呢菱格链条包女士单肩包斜挎小包包</div>
                        <div style={{fontSize: '1.2rem', color: 'red'}}>￥89
        					<span style={{border: '1px solid red', fontSize: '1rem'}}>包邮
        					</span>
        				</div>
        				<div style={{color: 'gray', fontSize: '0.9rem'}}>
        					<del>￥189</del>
        					<div style={{float: 'right'}}>1990人在抢</div>
        				</div>
        			</div>
        		</div>
        	</section>
		);
	}
});

module.exports = ProductList;

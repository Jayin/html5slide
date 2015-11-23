var React = require('react');
var app = require('app');
var lazyload = require('lazyload');

/**
 * 产品列表
 */
var ProductList = React.createClass({
	getInitialState: function(){
		return {
			products: this.props.products || []
		};
	},
	componentDidMount: function() {
		this.fetchData('zuixintemai');
		$(window).on('navigator-tab-change', function(event, type){
			this.fetchData(type);
		}.bind(this))
	},
	componentWillUnmount: function() {
		$(window).off('navigator-tab-change')
	},
	fetchData: function(type){
		app.ajax.get({
			url: '/bcj/api/{type}.json'.replace('{type}', type),
			success: function(res){
				this.setState({
					products: res
				});

				$("img.lazy").lazyload({
					effect : "fadeIn"
				});
			}.bind(this),
			error: function(){
				app.alerts.alert('网络繁忙，获取产品列表失败');
			}
		})
	},
	handleItemClick: function(product){
		location.href = product.link;
	},
	render: function(){
		return (
            <section style={{marginTop: '-30px', background: '#E6E6E6'}}>
				{this.state.products.map(function(product){
					return (
						<div style={{position: 'relative',padding: '5px', borderBottom: '1px solid gainsboro'}} onClick={this.handleItemClick.bind(this, product)}>
		        			<div style={{height: '100px', width: '100px'}}>
		        				<img className="lazy" data-original={product.img} style={{width: '100%', height: '100%'}} />
		        			</div>
		        			<div style={{top: '0',right: '0', bottom: '0',position: 'absolute', left: '105px', padding: '10px'}}>
		        				<div style={{display: 'inline-block', fontSize: '0.8rem', minHeight: '40px'}}>
		        					<span style={{display: 'inline-block', marginRight: '4px',background: (product.tag==='天猫'?'red':'#DEB92F'), color: 'white',padding: '1px'}}>{product.tag}</span>
									<span>{product.title}</span>
		        				</div>
								<div style={{fontSize: '1rem', color: 'red'}}>
									￥<span>{product.price}</span>
								{product.ship_price == '0'
							      ? <span style={{border: '1px solid red', fontSize: '0.9rem', marginLeft: '2px'}}>包邮</span>
							  : <span style={{fontSize: '0.8rem',color: 'gray',marginLeft: '4px'}}>邮费: {product.ship_price}</span>
								}
		        				</div>
		        				<div style={{color: 'gray', fontSize: '0.8rem'}}>
		        					<del style={{display: 'none'}}>￥189</del>
		        					<div style={{float: 'right'}}>1990人在抢</div>
		        				</div>
		        			</div>
		        		</div>
					);
				}.bind(this))}
        	</section>
		);
	}
});

module.exports = ProductList;

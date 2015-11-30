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
			<div>
	            <section style={{background: '#FFFFFF'}}>
					{this.state.products.map(function(product){
						return (
							<div style={{position: 'relative',padding: '5px', borderBottom: '1px solid gainsboro'}} onClick={this.handleItemClick.bind(this, product)}>
			        			<div style={{height: '100px', width: '100px'}}>
			        				<img className="lazy" data-original={product.img} style={{width: '100%', height: '100%'}} />
			        			</div>
			        			<div style={{top: '0',right: '0', bottom: '0',position: 'absolute', left: '105px', padding: '10px'}}>
			        				<div style={{display: 'inline-block', fontSize: '0.9rem', minHeight: '40px'}}>
										<div style={{height: '40px',overflow: 'hidden'}}>
											<span className={product.tag==='天猫'?'icon icon-tmall':'icon icon-taobao'} style={{display: 'inline-block', marginRight: '4px',padding: '1px',height: '25px',width: '44px',zoom: '0.6',verticalAlign: 'middle'}}></span>
											{product.title}
										</div>
			        				</div>
									<div style={{fontSize: '1.4rem', color: 'red'}}>
										￥<span>{product.price}</span>
									<span className="icon icon-baoyou" style={{display: 'inline-block',zoom: '0.6',verticalAlign: 'middle',marginLeft: '20px',marginTop: '-0.2rem',height: '32px',width: '63.5px'}}></span>
			        				</div>
			        				<div style={{color: 'gray', fontSize: '0.8rem'}}>
			        					<del>￥{product.raw_price}</del>
			        				</div>
			        			</div>
			        		</div>
						);
					}.bind(this))}
	        	</section>
			</div>
		);
	}
});

module.exports = ProductList;

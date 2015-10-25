var React = require('react');
var app = require('app');
var Skateboard = require('skateboard');
var $ = require('jquery');
var slick = require('slick');

var Carousel = React.createClass({
	getInitialState: function(){
		return {
			advertisements: this.props.advertisements || []
		};
	},
    componentDidMount: function() {
		this.fetchData();
    },
	fetchData: function(){
		app.ajax.get({
			url: '/bcj/api/carousel.json',
			success: function(res){
				// console.log(res)
				this.setState({
					advertisements: res
				})
				$('.your-class').slick({
					arrows: false,
					accessibility: false,
					fade: true,
					speed: 700,
					cssEase: 'linear',
					slidesToShow: 1,
					// dots: true,
					// adaptiveHeight: true,
					centerMode: true,
					centerPadding: '60px',
					autoplay: true,
					autoplaySpeed: 2000
				});
			}.bind(this),
			error: function(){
				app.alerts.alert('网络繁忙，获取轮播广告失败');
			}
		})
	},
	handleImgClick: function(advertisement){
		location.href = advertisement.link;
	},
	render: function(){
        var imgStyle = {
            height: '120px'
        }
		return (
            <div className="your-class">
				{this.state.advertisements.map(function(advertisement){
					return (
						<img style={imgStyle}
							src={advertisement.img}
							onClick={this.handleImgClick.bind(this, advertisement)}
							key={advertisement.link}
							alt={advertisement.title}></img>
					);
				}.bind(this))}
    		</div>
		);
	}
});

module.exports = Carousel;
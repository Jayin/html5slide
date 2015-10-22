var React = require('react');
var app = require('app');
var Skateboard = require('skateboard');
var $ = require('jquery');
var slick = require('slick');

var Carousel = React.createClass({
	getInitialState: function(){
		return {
		};
	},
    componentDidMount: function() {
        $('.your-class').slick({
            arrows: false,
            accessibility: false,
            fade: true,
            speed: 300,
            cssEase: 'linear',
            slidesToShow: 1,
            // dots: true,
            // adaptiveHeight: true,
            centerMode: true,
            centerPadding: '60px',
            autoplay: true,
            autoplaySpeed: 2000
        })
    },
	render: function(){
        var imgStyle = {
            height: '120px'
        }
		return (
            <div className="your-class">
    			<img style={imgStyle} src="https://img.alicdn.com/tps/TB13g8QKXXXXXa7XXXXXXXXXXXX-1280-512.jpg_790x420Q50.jpg"></img>
    			<img style={imgStyle} src="https://img.alicdn.com/tps/TB1LydzKXXXXXcRXpXXXXXXXXXX-1280-512.jpg_790x420Q50.jpg"></img>
    			<img style={imgStyle} src="https://img.alicdn.com/tps/i2/TB1i8XuKXXXXXbGXFXXKLG.WVXX-1280-512.jpg_790x420Q50.jpg"></img>
    			<img style={imgStyle} src="https://img.alicdn.com/tps/TB1gq82KXXXXXbIXXXXXXXXXXXX-1280-512.jpg_790x420Q50.jpg"></img>
    		</div>
		);
	}
});

module.exports = Carousel;

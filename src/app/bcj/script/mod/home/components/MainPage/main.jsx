var React = require('react');
var Carousel = require('../Carousel/main');
var Navigator = require('../Navigator/main');
var ProductList = require('../ProductList/main');

var MainPage = React.createClass({
    getInitialState: function(){
        return {};
    },
    render: function(){
        return (
            <div class="body-inner">
            	<section id="container-navigator" style={{position: 'fixed',top: '0',left: '0',right: '0',zIndex: '9999'}}>
                        <Navigator />
            	</section>


            	<section id="container-carousel" style={{paddingTop: '40px'}}>
                    <Carousel />
            	</section>

            	<section id="container-productlist">
                    <ProductList />
            	</section>
            </div>
        );
    }
});

module.exports = MainPage;

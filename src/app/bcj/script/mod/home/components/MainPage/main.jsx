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

                <section style={{paddingTop: '40px'}}>
                    <section id="container-carousel" >
                        <Carousel />
                    </section>

                    <section >
                        <ProductList />
                    </section>
                </section>
            </div>
        );
    }
});

module.exports = MainPage;

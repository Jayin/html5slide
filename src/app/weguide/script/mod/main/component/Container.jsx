var React = require('react');
var ScenicList = require('./ScenicList');
var ViewList = require('./ViewList');

var Container = React.createClass({
    getInitialState: function() {
        return {
            display: this.props.display || 'ViewList', //or ViewList
            scenic: this.props.scenic,
            currentPosition: this.props.currentPosition
        };
    },

    componentWillReceiveProps: function(nextProps) {
        this.setState({
            display: nextProps.display || 'ViewList', //or ViewList
            scenic: nextProps.scenic,
            currentPosition: nextProps.currentPosition
        })
    },

    handleSearch: function(evt){
        console.log(this.refs.searchInput.getDOMNode().value)
    },
    handleSwitchScenic: function(){
        if(this.state.display === 'ViewList'){
            this.setState({
                display: 'ScenicList'
            });
        }else{
            this.setState({
                display: 'ViewList'
            });
        }
    },
    render: function() {
        var List = <ViewList views={this.state.scenic.views} currentPosition={this.state.currentPosition}/>;
        if (this.state.display === 'ScenicList'){
            List = <ScenicList />
        }

        return (
            <section>
                <nav style={{padding: '4px'}}>
                    <div onClick={this.handleSwitchScenic} style={{display: 'inline-block', marginLeft: '8px', marginTop: '4px', fontSize: '1.3rem'}}>
                        {this.state.scenic.name}
                        {this.state.display === 'ViewList'
                            ?<i className="fa fa-angle-down" style={{margin: '4px'}}></i>
                            :<i className="fa fa-angle-up" style={{margin: '4px'}}></i>}

                    </div>
                    <div style={{display: 'inline-block',margin: '2px',padding: '2px',position: 'absolute',right: '4px',border: '1px solid rgba(0, 0, 0, 0.21)',borderRadius: '10px'}}>
                        <i className="fa fa-search" style={{padding: '4px', fontSize: '1.2rem'}} onClick={this.handleSearch}></i>
                        <input ref="searchInput" type="text" placeholder="搜索景点" style={{border: 'none'}}>

                        </input>
                    </div>
                </nav>
                <hr style={{margin: '0px'}}/>

                {List}
            </section>
        );
    }

});

module.exports = Container;

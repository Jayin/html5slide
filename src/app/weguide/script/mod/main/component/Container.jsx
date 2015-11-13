var React = require('react');
var ScenicSwitch = require('./ScenicSwitch');
var ViewList = require('./ViewList');
var app = require('app');

var Container = React.createClass({
    getInitialState: function() {
        return {
            display: this.props.display || 'ViewList', //or ViewList
            scenic: this.props.scenic,
            viewName: this.props.viewName || '',
            currentPosition: this.props.currentPosition
        };
    },

    componentWillReceiveProps: function(nextProps) {
        this.setState({
            display: nextProps.display || 'ViewList', //or ViewList
            scenic: nextProps.scenic,
            viewName: nextProps.viewName || '',
            currentPosition: nextProps.currentPosition
        })
    },

    handleSearch: function(evt){
        this.setState({
            viewName: this.refs.searchInput.getDOMNode().value
        });
    },
    handleSwitchScenic: function(){
        if(this.state.display === 'ViewList'){
            this.setState({
                display: 'ScenicSwitch'
            });
        }else{
            this.setState({
                display: 'ViewList'
            });
        }
    },
    //景区发声变化
    onScenicChange: function(scenic){
        G.state.set({
            scenic: scenic,
        });
        this.setState({
            display: 'ViewList',
            scenic: scenic,
            viewName: ''
        });
    },
    render: function() {
        var List = <ViewList scenic_id={this.state.scenic.scenic_id} viewName={this.state.viewName} currentPosition={this.state.currentPosition}/>;
        if (this.state.display === 'ScenicSwitch'){
            List = <ScenicSwitch onScenicChange={this.onScenicChange}/>
        }

        return (
            <section>
                <nav style={{padding: '4px', height: '50px'}}>
                    <div onClick={this.handleSwitchScenic} style={{display: 'inline-block', marginLeft: '8px', marginTop: '4px', fontSize: '1.3rem', width: '40%'}}>
                        <span style={{display: 'inline-block',maxWidth: '124px',textOverflow: 'ellipsis', overflow: 'hidden',whiteSpace: 'nowrap'}}>{this.state.scenic.name}</span>
                        <div style={{display: 'inline-block'}}>
                        {this.state.display === 'ViewList'
                            ?<i className="fa fa-angle-down" style={{margin: '4px', fontSize: '1.4rem'}}></i>
                            :<i className="fa fa-angle-up" style={{margin: '4px', fontSize: '1.4rem'}}></i>}
                        </div>
                    </div>
                    <div style={{display: 'inline-block',margin: '2px',padding: '2px',position: 'absolute',right: '4px',border: '1px solid rgba(0, 0, 0, 0.21)',borderRadius: '10px'}}>
                        <i className="fa fa-search" style={{padding: '4px', fontSize: '1.2rem'}} onClick={this.handleSearch}></i>
                        <input ref="searchInput" type="text" placeholder="搜索景点" style={{border: 'none'}}>

                        </input>
                    </div>
                </nav>
                <hr style={{margin: '0px'}}/>
                <div style={{}}>
                    {List}
                </div>
            </section>
        );
    }

});

module.exports = Container;

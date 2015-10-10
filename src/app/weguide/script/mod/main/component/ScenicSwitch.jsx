var React = require('react');
var app = require('app');

var AreaList = React.createClass({
    getInitialState: function() {
        return {
            areas: this.props.areas || []
        };
    },
    componentWillReceiveProps: function(nextProps) {
        this.setState({
            areas: nextProps.areas || []
        });
        this._fetchData();
    },
    componentDidMount: function() {
        this._fetchData();
    },
    _fetchData: function(){
        app.ajax.get({
            url: '/Api/Area/ListsArea'
            ,success: function(res){
                this.setState({
                    areas: res.response
                });
            }.bind(this)
            ,error: function(){
                app.alerts.alert('系统繁忙请稍后再试');
            }
        });
    },

    handleAreaClick: function(area){
        //callback
        if(this.props.onSelectAreaChange){
            this.props.onSelectAreaChange(area);
        }
    },

    render: function() {
        return (
            <div  className="warp-arealist" style={{backgroundColor: '#eeeeee'}}>
                <ul style={{padding: '0px',margin: '0', listStyle: 'none',textAlign: 'center', paddingBottom: '50px'}}>
                    {this.state.areas.map(function(area){
                        return (
                            <li  style={{padding: '4px'}} key={area.area_id} onClick={this.handleAreaClick.bind(this, area)}>{area.name}</li>
                        )
                    }.bind(this))}
                </ul>
            </div>
        );
    }
});

var ScenicList = React.createClass({
    getInitialState: function() {
        return {
            area: this.props.area,
            scenics: this.props.scenics || []
        };
    },
    componentWillReceiveProps: function(nextProps) {
        this.setState({
            area: nextProps.area,
            scenics: nextProps.scenics || []
        });
        if(nextProps.area && nextProps.area.area_id){
            this._fetchData(nextProps.area.area_id);
        }
    },
    componentDidMount: function() {
        if(this.state.area && this.state.area.area_id){
            this._fetchData(this.state.area.area_id);
        }
    },
    _fetchData: function(area_id, page, limit){
        page = page || 1;
        limit = limit || 50; //列出全部?
        app.ajax.get({
            url: '/Api/Scenic/listsScenic?area_id={area_id}&page={page}&limit={limit}'.replace('{area_id}', area_id).replace('{page}', page).replace('{limit}', limit)
            ,success: function(res){
                this.setState({
                    scenics: res.response
                });
            }.bind(this)
            ,error: function(){
                app.alerts.alert('系统繁忙请稍后再试');
            }
        });
    },
    handleScenicClick: function(scenic){
        if(this.props.onScenicChange){
            this.props.onScenicChange(scenic);
        }
    },
    render: function() {
        return (
            <div>
                <ul style={{listStyle: 'none', marigin: '0', padding: '0'}}>
                    {this.state.scenics.map(function(scenic){
                        return (
                            <li key={scenic.name}
                                style={{padding: '8px 8px 8px', borderBottom: '1px solid gainsboro',margin: '2px 4px 4px'}}
                                onClick={this.handleScenicClick.bind(this, scenic)}>
                                {scenic.name}
                            </li>
                        )
                    }.bind(this))}
                </ul>
            </div>
        );
    }
});

var ScenicSwitch = React.createClass({
    getInitialState: function() {
        return {
            selectedArea: this.props.selectedArea
        };
    },
    onSelectAreaChange: function(area){
        this.setState({
            selectedArea: area
        });
    },
    render: function() {
        return (
            <section>
                <div style={{width: '100px', display: 'inline-block', height: '100%', overflow: 'hidden'
                    ,position: 'absolute'
                    ,top: '50px'
                    ,bottom: '10px'
                    ,overflow: 'scroll'}}>
                    <AreaList onSelectAreaChange={this.onSelectAreaChange}></AreaList>
                </div>
                <div style={{width: '70%', display: 'inline-block'
                    ,position: 'absolute'
                    ,top: '50px'
                    ,left: '100px'
                    ,bottom: '10px'
                    ,overflow: 'scroll'}}>
                    <ScenicList area={this.state.selectedArea} onScenicChange={this.props.onScenicChange}></ScenicList>
                </div>
            </section>
        );
    }

});

module.exports = ScenicSwitch;

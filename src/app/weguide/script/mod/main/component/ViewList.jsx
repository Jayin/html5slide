var React = require('react');
var cal = require('../../../lib/cal');
var app = require('app');

var ViewList = React.createClass({
    getInitialState: function() {
        return {
            scenic_id: this.props.scenic_id,
            views: this._sortByDistance(this.props.views, this.props.currentPosition) || [],
            currentPosition: this.props.currentPosition
        };
    },
    componentWillReceiveProps: function(nextProps) {
        if(nextProps.views){
            this.setState({
                scenic_id: this.props.scenic_id,
                views: this._sortByDistance(nextProps.views, nextProps.currentPosition || this.state.currentPosition) || [],
                currentPosition: nextProps.currentPosition || this.state.currentPosition
            });
        }
        if(nextProps.scenic && nextProps.scenic.id){
            this._fetchData(nextProps.scenic.id)
        }
    },
    componentDidMount: function() {
        if(this.state.scenic_id){
            this._fetchData(this.state.scenic_id)
        }
    },
    _fetchData: function(scenic_id, page, limit){
        page = page || 1;
        limit = limit || 50; //列出全部?
        app.ajax.get({
            url: '/Api/View/listsView?scenic_id={scenic_id}&page={page}&limit={limit}'.replace('{scenic_id}', scenic_id).replace('{page}', page).replace('{limit}', limit)
            ,success: function(res){
                this.setState({
                    views: res.response
                });
            }.bind(this)
            ,error: function(){
                app.alerts.alert('系统繁忙请稍后再试');
            }
        });
    },
    _sortByDistance: function(views, currentPosition){
        if(!views){
            return [];
        }
        return views.sort(function(viewA, viewB){
            var distanceA = cal(viewA.longitude, viewA.latitude,
                currentPosition.longitude, currentPosition.latitude);
            var distanceB = cal(viewB.longitude, viewB.latitude,
                currentPosition.longitude, currentPosition.latitude);
            if (distanceA < distanceB){
                return -1;
            }else if(distanceA === distanceB){
                return 0;
            }else{
                return 1;
            }
        }.bind(this))

    },
    _makeDistance: function(longitude, latitude, currentPosition){
        var dis = Math.ceil(cal(longitude, latitude, currentPosition.longitude, currentPosition.latitude));
        if (dis > 1000){
            return dis/1000 + 'km';
        }
        return dis + 'm';
    },
    playVoice: function(voice_url){
        console.log('play==>'+ voice_url);
    },
    render: function() {
        return (
            <section>
                {this.state.views.map(function(view){
                    return (
                        <div key={view.name} style={{padding: '8px', fontSize: '1.1rem', margin: '0 6px 0 6px', borderBottom: '1px solid gainsboro'}}>
                            <div style={{display: 'inline-block'}} onClick={this.playVoice.bind(this, view.voice_url)}>
                                {view.name}
                                <i className="fa fa-volume-down" style={{marginLeft: '6px'}}></i>
                            </div>
                            <div style={{display: 'inline-block',float: 'right', color: 'grey', marginRight: '9px'}}>
                                {this._makeDistance(view.longitude, view.latitude, this.state.currentPosition)}
                            </div>
                        </div>
                    )
                }.bind(this))}

            </section>
        );
    }

});

module.exports = ViewList;

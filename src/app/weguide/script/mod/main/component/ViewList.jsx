var React = require('react');
var cal = require('../../../lib/cal');
var secondFormat = require('../../../lib/secondFormat');
var app = require('app');
var howler = require('howler');

var ViewList = React.createClass({
    musicPlayer: null,
    getInitialState: function() {
        return {
            scenic_id: this.props.scenic_id,
            views: this._sortByDistance(this._transformView(this.props.views), this.props.currentPosition) || [],
            currentPosition: this.props.currentPosition
        };
    },
    componentWillReceiveProps: function(nextProps) {
        if(nextProps.views){
            this.setState({
                scenic_id: this.props.scenic_id,
                views: this._sortByDistance(this._transformView(nextProps.views), nextProps.currentPosition || this.state.currentPosition) || [],
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
    _transformView: function(views, index, state, pos, duration){
        if(!views){
            return [];
        }
        var result = views.map(function(view){
            view.state = 'stop';
            view.pos = 0; //播放到pos秒
            view.duration = 0; //语音长度,duration秒
            return view;
        });
        if(index || index === 0){
            result[index].state = state;
            result[index].pos = pos;
            result[index].duration = duration;
        }
        return result;
    },
    _fetchData: function(scenic_id, page, limit){
        page = page || 1;
        limit = limit || 50; //列出全部?
        app.ajax.get({
            url: '/Api/View/listsView?scenic_id={scenic_id}&page={page}&limit={limit}'.replace('{scenic_id}', scenic_id).replace('{page}', page).replace('{limit}', limit)
            ,success: function(res){
                this.setState({
                    views: this._transformView(res.response)
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
    _notifyPlaying: function(index){
        var tmp_views = this.state.views;
        if(tmp_views[index].state === 'playing'){
            tmp_views[index].pos += 1;
            this.setState({
                views: tmp_views
            });
            setTimeout(this._notifyPlaying.bind(this, index), 1000);
        }
    },
    playVoice: function(voice_url, index){
        var self = this;
        if(voice_url){
            if(this.musicPlayer){
                this.musicPlayer.stop();
                var new_views = self._transformView(self.state.views, index, 'common', 0, self.musicPlayer.duration());
                console.log(new_views)
                self.setState({
                    views: new_views
                });
            }
            this.musicPlayer = new Howl({
                src: [voice_url]
                ,onload: function(){
                    //加载完
                }
                ,onplay: function(id){
                    var new_views = self._transformView(self.state.views, index, 'playing', 0, self.musicPlayer.duration());
                    self.setState({
                        views: new_views
                    });
                    setTimeout(self._notifyPlaying.bind(self, index), 1000);
                }
                ,onloaderror: function(err){
                    if(err){
                        app.alerts.alert('网络繁忙，请稍后再试');
                    }
                }
                ,onend: function(){
                    var new_views = self._transformView(self.state.views, index, 'common', 0, self.musicPlayer.duration());
                    self.setState({
                        views: new_views
                    });
                }
            });
            this.musicPlayer.play();
        }else{
            app.alerts.alert('语音不存在');
        }

    },
    componentWillUnmount: function() {
        if(this.musicPlayer){
            this.musicPlayer.stop();
        }
    },
    render: function() {
        return (
            <section>
                {this.state.views.map(function(view, index){
                    return (
                        <div key={view.name} style={{padding: '8px', fontSize: '1.1rem', margin: '0 6px 0 6px', borderBottom: '1px solid gainsboro'}}>
                            <div style={{display: 'inline-block'}} onClick={this.playVoice.bind(this, view.voice_url, index)}>
                                {view.name}
                                <i className="fa fa-volume-up" style={{marginLeft: '6px'}}></i>
                            </div>
                            {view.state === 'playing'?
                                <div style={{display: 'inline-block',float: 'right', marginRight: '9px'}}>
                                    {secondFormat(view.pos) + '/' + secondFormat(view.duration)}
                                </div>
                            :<div style={{display: 'inline-block',float: 'right', color: 'grey', marginRight: '9px'}}>
                                {this._makeDistance(view.longitude, view.latitude, this.state.currentPosition)}
                            </div>
                            }
                        </div>
                    )
                }.bind(this))}

            </section>
        );
    }

});

module.exports = ViewList;

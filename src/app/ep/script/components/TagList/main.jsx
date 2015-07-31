/**
 * 分离产品列表
 */
var React = require('react');
var app = require('app');
var Skateboard = require('skateboard');
var $ = require('jquery');
require('jstree');

module.exports = React.createClass({
	getInitialState: function(){
		return {
			jstreeContainerId: this.props.jstreeContainerId || 'jstreeContainerId1',
			result: this.props.result || [],
			close: this.props.close //二级目录默认打开
		}
	},
	objectAttrLowercase: function(obj, parentId){
		parentId = parentId || ''
		var res = {}
		res.text = obj.Text || obj.CompanyName
		res.id = parentId + '-' + (obj.ID || obj.CompanyCode) // 公司节点没有id
		res.name = obj.Name || obj.CompanyName // 公司节点没有name
		res.alias = obj.Alias
		res.hierarchy = obj.Hierarchy // may be undefine
		res.companyName = obj.CompanyName
		res.companyCode = obj.CompanyCode
		res.Groups = obj.Groups
		res.Categories = obj.Categories
		res.Children = obj.Children

		// console.log(res.name + '-->' + obj.HasRecommend)
		res.a_attr = {
			"style":"color:#000;"
		}
		if (obj.HasRecommend){
			res.a_attr = {
				"style":"color:red;"
			}
		}

		//默认二级目录
		if (res.hierarchy == 1 && !this.state.close)
			res.state = {opened: true}
		else
			res.state = {opened: false}


		if (obj.Children){
			res.children = []
			obj.Children.forEach(function(element){
				res.children.push(this.objectAttrLowercase(element, res.id))
			}, this)
		}

		if (obj.Groups){
			res.children = []
			obj.Groups.forEach(function(element){
				res.children.push(this.objectAttrLowercase(element, res.id))
			}, this)
		}

		if (obj.Categories){
			res.children = []
			obj.Categories.forEach(function(element){
				res.children.push(this.objectAttrLowercase(element, res.id))
			}, this)
		}

		return res
	},
	transform: function(data){
		var result = [];
		data.forEach(function(element){
			result.push(this.objectAttrLowercase(element))
		}, this);
		return result;
	},
	render: function(){

		return (
			<div className="component-TagList">
				<div id={this.props.jstreeContainerId}></div>
			</div>
		);
	},
	_updateJsTree: function(){
		var jstree_config = {
		  core: {
		    themes: {
		      dots: false
		    },
		    data: []
		  },
		  types: {
		    "default": {
		      icon: "icon-null"
		    }
		  },
		  plugins: ["types"]
		};
		//转换
		jstree_config.core.data = this.transform(this.props.result)

		$('#' + this.props.jstreeContainerId).jstree(jstree_config)

		$('#' + this.props.jstreeContainerId).jstree(true).settings.core.data = jstree_config.core.data;
		$('#' + this.props.jstreeContainerId).jstree(true).refresh(true);
	},
	componentDidMount: function(){
		$('#' + this.props.jstreeContainerId).on('select_node.jstree', function(event, data){
			event.preventDefault();
			$(this).jstree(true).deselect_node(data.node.id)

			if (data.node.original.hierarchy == 3){
				// 设置该原件的的所有给出的属性
				category = data.node.original
				//remove all parent id
				ids =  category.id.split('-')
				category.id = ids[ids.length - 1]

				G.state.set({category: category, categoryName: data.node.original.text})
				Skateboard.core.view('/view/info')
			}else{
				if($(this).jstree(true).is_open(data.node.id)){
					$(this).jstree(true).close_node(data.node.id)
				}else{
					$(this).jstree(true).open_node(data.node.id)
				}
			}
		});

		this._updateJsTree();
	},
	componentWillReceiveProps: function(nextProps){
		this._updateJsTree();
	}
});

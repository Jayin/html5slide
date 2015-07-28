/**
 * 搜索列表
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
			result: this.props.result || []
		}
	},
	objectAttrLowercase: function(obj, parentId){
		parentId = parentId || ''
		var res = {}
		res.text = obj.Text || obj.Name || obj.CompanyName
		res.id = parentId + '-' + (obj.ID || obj.CompanyCode) // 公司节点没有id
		res.name = obj.Name || obj.CompanyName // 公司节点没有name
		res.code = obj.Code //公司代码
		res.alias = obj.Alias
		res.hierarchy = obj.Hierarchy // may be undefine
		res.companyName = obj.CompanyName
		res.companyCode = obj.CompanyCode
		res.Groups = obj.Groups
		res.Categories = obj.Categories
		res.Children = obj.Children


		//默认二级目录
		// if (res.hierarchy == 1)
		// 	res.state = {opened: true}
		// else
		// 	res.state = {opened: false}


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

		var Companies = {};
		Companies.text = '公司'
		Companies.id = 'Companies';
		Companies.state = {opened: true};
		Companies.children = [];
		data.Companies.forEach(function(element){
			Companies.children.push(this.objectAttrLowercase(element))
		}, this);
		if (Companies.children.length == 0){
			Companies.children.push({});
			//占位一行
			Companies.state = {opened: true};
		}
		result.push(Companies);

		data.Groups.forEach(function(element){
			result.push(this.objectAttrLowercase(element))
		}, this);
		return result;
	},
	render: function(){
		return (
			<div className="component-SearchList">
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

		$('#' + this.props.jstreeContainerId).on('select_node.jstree', function(event, data){
			if (data.node.original.hierarchy == 3){
				// 设置该原件的的所有给出的属性
				category = data.node.original
				//remove all parent id
				ids =  category.id.split('-')
				category.id = ids[ids.length - 1]

				G.state.set({category: category, categoryName: data.node.original.text})
				Skateboard.core.view('/view/info')
			}else if (data.node.parent == 'Companies'){
				G.state.set({companyCode: data.node.original.code, companyName: data.node.original.text})
				Skateboard.core.view('/view/category')
			}else{
				$(this).jstree(true).open_node(data.node.id)
			}
		});

		$('#' + this.props.jstreeContainerId).jstree(jstree_config)
	},
	componentDidMount: function(){
		this._updateJsTree();
	},
	componentWillReceiveProps: function(nextProps){
		this._updateJsTree();
	}
});

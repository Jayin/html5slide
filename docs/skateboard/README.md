# skateboard
> 轻量级SPA框架


### 入口
```
skateboard.core.init(opt)
```

- `opt.defaultModName ?= 'home'` 默认模块名
- `opt.modBase ?= ''` 模块的搜索路径
- `opt.modPrefix ?= 'view'` 模块的前缀
- `opt.container` 页面的container(div)
- `opt.isSupportHistoryState` 是否支持历史状态
- `opt.animate` 动画
	```
		animate: {
				type: 'fade',
				timingFunction: 'linear',
				duration: 300
		}
	```


### Method

* load: (mark, opt, onLoad)
	* mark: 路由
	* opt: 可选参数
	* 加载完的回调

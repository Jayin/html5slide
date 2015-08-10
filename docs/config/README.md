html5slide 测试环境搭建
------

### nginx config

添加一台处理`make prototype`的服务器

```
    server {
            listen       80;
            server_name  prototype.html5slide.me;
            #access_log   /var/log/nginx/prototype.html5slide.me.access.log;
            gzip         on;
            gzip_types   text/plain text/css application/json application/x-javascript text/xml application/xml text/javascript;
            root         /Users/jayin/Desktop/html5slide/dist/prototype; # 修改成你的html5slide的prototype目录

    }
```

然后
```shell
$ nginx -s reload
```

#### 修改hosts

```
$ sudo vim /etc/hosts
```

输入
```
127.0.0.1 prototype.html5slide.me
127.0.0.1 cdn.prototype.html5slide.me
```

访问: `http://prototype.html5slide.me`

[若出现403，请看下面](#nginx403)


### 编写测试

在`src/mockup-data`中按照路由的路径编写测试数据

例如:

`main.coffee`

```CoffeeScript  
designId = 1
# .....
app.ajax.get
    url: "web/design/#{designId}" # 注意这里
    success: (result)->
            #.....

```

mockup-data/web/design/1.json

```json
{
 "code" : 0,
 "message" : "",
 "data" : {
   "id" : "1",
   "likeNum" : 50,
   "relativePath" : "image/test_user_img.png"
 },
 "debugInfo" : null
}
```

所以在`mockup-data`中建立目录`mockup-data/web/design/1.json`
在prototype的环境下，访问`web/design/#{designId}` 会自动请求到本地数据

注意  
1. 约定是返回的数据都是json,前后端分离
2. 文件名后缀为`*.json`
3. `mockup-data/`不会打包到production里面，只会在`prototype`中



### nginx出现403

参考:http://www.nginx.cn/511.html

1.网站禁止特定的用户访问所有内容，例：网站屏蔽某个ip访问。
2.访问禁止目录浏览的目录，例：设置autoindex off后访问目录。
3.用户访问只能被内网访问的文件。

以上几种常见的需要返回 403 Forbidden 的场景。

由于服务器端的错误配置导致在不希望nginx返回403时返回403 Forbidden。


#### 1.权限配置不正确

这个是nginx出现403 forbidden最常见的原因。

为了保证文件能正确执行，nginx既需要文件的读权限,又需要文件所有父目录的可执行权限。

例如，当访问/usr/local/nginx/html/image.jpg时，nginx既需要image.jpg文件的可读权限，也需要/,/usr,/usr/local,/usr/local/nginx,/usr/local/nginx/html的可以执行权限。

解决办法:设置所有父目录为755权限，设置文件为644权限可以避免权限不正确。



#### 2.目录索引设置错误（index指令配置）

网站根目录不包含index指令设置的文件。

例如，运行PHP的网站，通常像这样配置index

index  index.html index.htm index.php;

当访问该网站的时，nginx 会按照 index.html，index.htm ，index.php 的先后顺序在根目录中查找文件。如果这三个文件都不存在，那么nginx就会返回403 Forbidden。

如果index中不定义 index.php ，nginx直接返回403 Forbidden而不会去检查index.php是否存在。

同样对于如果运行jsp, py时也需要添加index.jsp,index.py到目录索引指令index中。

解决办法:添加首页文件到index指令，常见的是index.php，index.jsp，index.jsp或者自定义首页文件。

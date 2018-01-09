# 光谷社区

[光谷社区](http://www.guanggoo.com) 第三方客户端。

## 光谷社区 iOS下载地址
[App Store下载地址](https://itunes.apple.com/us/app/%E5%85%89%E8%B0%B7%E7%A4%BE%E5%8C%BA/id1330088850?l=zh&ls=1&mt=8)

截图

* 主题列表
![image](https://wx1.sinaimg.cn/mw690/a9a6744agy1fmvh56dddhj20ku112jwv.jpg)
* 节点列表
![image](https://wx2.sinaimg.cn/mw690/a9a6744agy1fmvh5615abj20ku112gp9.jpg)
* 侧边栏
![image](https://wx2.sinaimg.cn/mw690/a9a6744agy1fmvh56fet5j20ku112af8.jpg)
* 主题详情页
![image](https://wx1.sinaimg.cn/mw690/a9a6744agy1fmvh56a2f9j20ku112jwd.jpg)
* 作者操作（长按作者显示区域弹出操作对话框，如作者是登录本人支持编辑主题，如不是则支持屏蔽该作者）
![image](https://wx2.sinaimg.cn/mw690/a9a6744agy1fna2c1efzwj20hr0vkwig.jpg)
* 回复操作（长按回复显示区域弹出对话框，如回复是本人支持编辑回复，如不是则支持屏蔽回复者）
![image](https://wx4.sinaimg.cn/mw690/a9a6744agy1fna2c2o64oj20hr0vktbw.jpg)
![image](https://wx1.sinaimg.cn/mw690/a9a6744agy1fna2c2ngwfj20hr0vkgon.jpg)
* 回复详情页(支持@某一个人，讯飞语音输入，插入拍照或者相片图片)
![image](https://wx2.sinaimg.cn/mw690/a9a6744agy1fna2c1lshxj20hr0vkgmf.jpg)

| 功能 |   是否支持 |
| ------| ------ |
| 登录与切换账号 | 是 |
| 注册 | 暂不支持，请去浏览器内完成注册 |
| 创建编辑主题 | 是 |
| 创建编辑回复 | 是 |
| 收藏与取消收藏 | 是 |
| 查看我的消息、主题、回复、收藏 | 是 |
| 黑名单 | 支持本地屏蔽，重新安装后会丢失 |
| 社区表情 | 不支持，暂无支持计划 |
| @某人 | 支持 |
| 语音输入 | 支持 |
| 图片 | 支持，使用sm.ms图床，自动插入图片 |

### 安装方式

首先确保安装了cocoapods,然后将工程用git clone下来后，在Podfile目录执行命令pod install。等待命令完成后，会生成一个guanggoo-iOS.xcworkspace的文件，打开这个文件进行编译即可。
## 光谷社区 android下载地址

| Google Play                                                                                                                                                                                | 小米应用商店                                                                                                                                                    | 酷安                                                                                                                                             | GitHub                                                           |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------|
| <a href="https://play.google.com/store/apps/details?id=org.mazhuang.guanggoo" target="_blank"><img alt="Google Play" width="183px" height="39px" src="./assets/image/play-store.png"/></a> | <a href="http://app.mi.com/details?id=org.mazhuang.guanggoo" target="_blank"><img alt="小米应用商店" height="39px" src="./assets/image/xiaomi-market.png"/></a> | <a href="https://www.coolapk.com/apk/org.mazhuang.guanggoo" target="_blank"><img alt="酷安" height="39px" src="./assets/image/coolapk.png"/></a> | [Releases](https://github.com/mzlogin/guanggoo-android/releases) |


# 光谷社区 API 列表

<!-- vim-markdown-toc GFM -->

* [登录](#登录)
* [获取主题列表](#获取主题列表)
* [主题详情](#主题详情)
* [获取节点列表](#获取节点列表)
* [创建或编辑回复](#创建或编辑回复)
* [创建或编辑主题](#创建或编辑主题)
* [个人信息页](#个人信息页)
    * [发表过的主题列表](#发表过的主题列表)
    * [回复列表](#回复列表)
    * [收藏列表](#收藏列表)
* [收藏](#收藏)
    * [收藏主题](#收藏主题)
    * [取消收藏](#取消收藏)

<!-- vim-markdown-toc -->

## 登录
| 功能 | 登录请求 |
| ------| ------ |
| HTTP 请求方式 | POST |
| URL | http://www.guanggoo.com/ |

请求参数

| 参数名称 | 类型 | 是否必须 | 描述 |
| ------| ------ | ------ | ------ |
| email | String | 是 | 邮箱 |
| password | String | 是 | 密码 |
| _xsrf | String | 是 | 唯一标识符，可用uuid |


## 获取主题列表

默认排序：<http://www.guanggoo.com/>

最新话题：<http://www.guanggoo.com/?tab=latest>

精华主题：<http://www.guanggoo.com/?tab=elite>

节点主题列表：<http://www.guanggoo.com/node/xxxxx>

## 主题详情

URL: <http://www.guanggoo.com/t/25804>

## 获取节点列表

使用 GET 方法访问 <http://www.guanggoo.com/nodes>。

```html
<div class="nodes-cloud ...">
...
    <ul>
        <li>
            <label for>生活百科</label>
            <span class="nodes">
                <a href="/node/house">楼市房产</a>
                ...
            </span>
        </li>
        ...
    </ul>
...
</div>
```

## 创建或编辑回复

| 功能 | 登录请求 |
| ------| ------ |
| HTTP 请求方式 | POST |
| URL | 回复url或者编辑url |

请求参数

| 参数名称 | 类型 | 是否必须 | 描述 |
| ------| ------ | ------ | ------ |
| tid | String | 是 | 主题id，如若是编辑，则是编辑内容id |
| content | String | 是 | 回复内容 |
| _xsrf | String | 是 | 唯一标识符，登录时记下 |

##  创建或编辑主题

| 功能 | 登录请求 |
| ------| ------ |
| HTTP 请求方式 | POST |
| URL | 创建或编辑主题url |

请求参数

| 参数名称 | 类型 | 是否必须 | 描述 |
| ------| ------ | ------ | ------ |
| title | String | 是 | 主题内容 |
| content | String | 是 | 主题内容 |
| _xsrf | String | 是 | 唯一标识符，登录时记下 |

## 个人信息页

URL: <http://www.guanggoo.com/u/mzlogin>

可以从其它页面获取到。

获取用户基本信息：

```html
<div class="user-page">
    <div class="profile container-box">
        <div class="ui-header">
            <a href="/u/mzlogin">
                <img src="http://cdn.guanggoo.com/static/avatar/54/m_2fad3826-a776-11e6-a0b7-00163e020f08.png" alt="" class="avatar">
            </a>
            <div class="username">mzlogin</div>
            <div class="website"><a href="http://mazhuang.org">http://mazhuang.org</a></div>
            <div class="user-number">
                <div class="number">光谷社区第11554号成员</div>
                <div class="since">入住于2016-11-11</div>
            </div>
        </div>
        <div class="ui-content">
            <dl>
                <dt>ID</dt>
                <dd>mzlogin</dd>
            </dl>
            <dl>
                <dt>昵称</dt>
                <dd>mzlogin</dd>
            </dl>
            <dl>
                <dt>Email</dt>
                <dd>mzlo***@qq.com</dd>
            </dl>
            <dl>
                <dt>Blog</dt>
                <dd><a href="http://mazhuang.org">http://mazhuang.org</a></dd>
            </dl>
        </div>
    </div>
</div>
```

获取用户活动统计：

```html
<div class="usercard container-box">
    <div class="ui-content">
        <div class="status status-topic">
            <strong><a href="/u/mzlogin/topics">0</a></strong> 主题
        </div>
        <div class="status status-reply">
            <strong><a href="/u/mzlogin/replies">15</a></strong> 回复
        </div>
        <div class="status status-favorite">
            <strong><a href="/u/mzlogin/favorites">1</a></strong> 收藏
        </div>
        <div class="status status-reputation">
            <strong>0</strong> 信用
        </div>
    </div>
</div>
```

展示在用户个人信息页的基本信息这些就够了，发表过的主题列表和回复列表只显示数量，另外用页面单独列出，参考 <https://github.com/shitoudev/v2ex>。

### 发表过的主题列表

URL: <http://www.guanggoo.com/u/mzlogin/topics>

### 回复列表

URL: <http://www.guanggoo.com/u/mzlogin/replies>

```html
<div class="replies-lists ...">
    ...
    <div class="ui-content">
        <div class="reply-item">
            <div class="main">
                <span class="title">
                    回复了 dc2012ms 创建的主题
                    <a href="/t/25910">光谷是真心好！！！</a>
                </span>
                <div class="content">
                    <p>这几天不知道怎么样了</p>
                </div>
            </div>
        </div>
        <div class="reply-item">
            ...
        </div>
        ...
    </div>

    <div class="ui-footer">
        ...
        <ul class="pagination">
            <li class="disabled">
                <a href="/u/mzlogin/replies?p=1">上一页</a>
            </li>
            <li class="active">
                <a href="javascript:;">1</a>
            </li>
            ...
        </ul>
        ...
    </div>
</div>
```

### 收藏列表

URL: <http://www.guanggoo.com/u/mzlogin/favorites>

## 收藏

### 收藏主题

**Request**

```
GET http://www.guanggoo.com/favorite?topic_id=25869 HTTP/1.1
Accept: application/json, text/javascript, */*; q=0.01
X-Requested-With: XMLHttpRequest
Referer: http://www.guanggoo.com/t/25869
Accept-Language: zh-Hans-CN,zh-Hans;q=0.5
Accept-Encoding: gzip, deflate
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; Trident/7.0; LCTE; rv:11.0) like Gecko
Host: www.guanggoo.com
Connection: Keep-Alive
Cookie: Hm_lvt_fc1abeddfec5c3ea88cf6cdae32cdde7=1506732697; Hm_lpvt_fc1abeddfec5c3ea88cf6cdae32cdde7=1506732725; _ga=GA1.2.427913396.1506732727; _gid=GA1.2.1767756529.1506732727; _gat=1; _xsrf=7deabf7bde3b45149513f4bb58e77c63; verification="NDhhMDQ2OWQ4YTkzZDk2YzBiNjg0NjA5NzQzYjY0YWFiNDRiYzQ2YTQxYmZkZDE5Y2MxZTdmMWIxMTJkNWY2MQ==|1506732718|f218f25cb28c6332fc89c0c881566733d75da0ec"; session_id="YmQ4ZmRhYzEwZjI0OTA5ZjZhMGI2ZTI0NzIxYWU4MGI5MjNmNDJiMWUwM2VkM2E0OWM2OTk0YjJkMmNlZTE5Yg==|1506732718|1be79cbef19d9f452faa5914288b97b47319562b"; user="MTE1NTQ=|1506732718|a881d8d2377805df8bd0e7917f7442de47416f02"


```

**Response**

```
HTTP/1.1 200 OK
Date: Sat, 30 Sep 2017 00:52:15 GMT
Content-Type: text/html; charset=UTF-8
Content-Length: 45
Connection: keep-alive
Etag: "f071a3a1e35db1fc03c43ec254ea523dc9017b4c"
Server: TornadoServer/3.2

{"message": "favorite_success", "success": 1}
```

### 取消收藏

**Request**

```
GET /unfavorite?topic_id=25884 HTTP/1.1
Host: www.guanggoo.com
Connection: keep-alive
Accept: application/json, text/javascript, */*; q=0.01
X-Requested-With: XMLHttpRequest
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.100 Safari/537.36
Referer: http://www.guanggoo.com/t/25884
Accept-Encoding: gzip, deflate
Accept-Language: zh-CN,zh;q=0.8,en;q=0.6
Cookie: verification="MWZkMTQ4YWMyZWI5OTViZDEyNzM0NTQ2MWI5MzY5MDJmOTQ2NTVmMmI5MzlhZWQzMTc4YmY3ZjFjOWYwNmUwNQ==|1505449242|cd6806b985b1659d0e1e813e5edb92aa2f05de4b"; session_id="ZTExYWY4NDAzZTA1NDg0NWViYzhhMTM2ZDUyNDQ2MjI0OGQwYWM1MjU5NWRlZDBjMGQwMjdjNjdkZWQ3NWMxYw==|1505449242|898c284efed1c85cb6a80211ff7b88d963456e8a"; user="MTE1NTQ=|1505449242|8338edc07e6b8ef60f11a6cf627b8e7ed96b26a5"; _xsrf=8958ec90a24b43328d83341349212956; _gat=1; _ga=GA1.2.606805923.1500596270; _gid=GA1.2.2032501243.1506493190; Hm_lvt_fc1abeddfec5c3ea88cf6cdae32cdde7=1506730927,1506732617,1506732674,1506734767; Hm_lpvt_fc1abeddfec5c3ea88cf6cdae32cdde7=1506734780
```

**Response**

```
HTTP/1.1 500 Internal Server Error
Date: Sat, 30 Sep 2017 01:26:38 GMT
Content-Type: text/html; charset=UTF-8
Content-Length: 93
Connection: keep-alive
Server: TornadoServer/3.2

<html><title>500: Internal Server Error</title><body>500: Internal Server Error</body></html>
```

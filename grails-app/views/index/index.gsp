<%--
  Created by IntelliJ IDEA.
  User: 勇
  Date: 2016/8/23 0023
  Time: 20:00
--%>

<%@ page import="grails.util.Metadata" contentType="text/html;charset=UTF-8" %>
<!DOCTYPE HTML>
<html ng-app="main">
<head>
    <title ng-bind="title">zuoTV - 聚合全网直播</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <%String version = Metadata.getCurrent()[Metadata.APPLICATION_VERSION]%>
    <meta name="description" content="zuoTV,一站聚合七个直播平台百万主播,现已收录斗鱼,熊猫,虎牙,全民,龙珠,战旗,火猫平台,支持分屏观看,查看观众波动图表..." />
    <meta name="keywords" content="zuoTV,聚合直播,美女直播,游戏直播,分屏观看,观众变化图表,直播人数统计,直播导航,直播推荐"/>

    %{--<link Rel="SHORTCUT ICON" href="${resource(file: 'favicon32.ico')}">--}%
    <!--[if lt IE 10]>
        <script type="text/javascript">window.location.href = "${resource(file: 'no-ie.gsp')}";</script>
    <![endif]-->
    %{--<link href="${resource(file: '/css/font-awesome/css/font-awesome.min.css')}" rel="stylesheet" />--}%
    <link href="http://cdn.bootcss.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">
    %{--<link href="${resource(file: '/css/normalize.css')}" rel="stylesheet" />--}%
    <link href="http://cdn.bootcss.com/normalize/5.0.0/normalize.css" rel="stylesheet">
    <link href="${resource(file: '/css/base.css')}?v=${version}" rel="stylesheet" />
    <script type="text/javascript">window.ctx = "${createLink(uri:'/')}";</script>
    %{--<script type="text/javascript" src="${resource(file: '/js/jquery-3.1.0.min.js')}"></script>--}%
    <script type="text/javascript" src="http://cdn.bootcss.com/jquery/3.1.1/jquery.min.js"></script>
    <script src="http://cdn.bootcss.com/jquery-cookie/1.4.1/jquery.cookie.min.js"></script>
    <script src="http://cdn.bootcss.com/zclip/1.1.2/jquery.zclip.min.js"></script>
    <script src="http://cdn.bootcss.com/jquery-mousewheel/3.1.13/jquery.mousewheel.min.js"></script>
    <script src="http://cdn.bootcss.com/angular.js/1.5.6/angular.min.js"></script>
    %{--<script type="text/javascript" src="${resource(file: '/js/angular/angular.min.js')}"></script>--}%
    %{--<script type="text/javascript" src="${resource(file: '/js/angular/angular-ui-router.min.js')}"></script>--}%
    <script src="http://cdn.bootcss.com/angular-ui-router/0.4.2/angular-ui-router.min.js"></script>
    <script src="http://cdn.bootcss.com/d3/4.5.0/d3.min.js"></script>

    <script src="http://cdn.bootcss.com/trianglify/1.0.1/trianglify.min.js"></script>
    <script src="http://cdn.bootcss.com/sockjs-client/1.1.4/sockjs.min.js"></script>
    <script src="http://cdn.bootcss.com/stomp.js/2.3.3/stomp.js"></script>

    <script type="text/javascript" src="${resource(file: '/js/self/tools.js')}?v=${version}"></script>
    <script type="text/javascript" src="${resource(file: '/js/self/main.js')}?v=${version}"></script>
    %{-- 所有分类页面 --}%
    <script type="text/ng-template" id="type-tem">
    <div class="types" ng-show="$root.topData.platforms">
        <div>
            <h2 class="show-params"><span><i class="fa fa-ship"></i>平台</span>
                <a class="btn" ui-sref="room({page:1, tag: '', platformName: '', kw: ''})"
                   ui-sref-opts="{reload:true}" title="其实点击logo位置也可以回&#13;也可以直接使用浏览器的前进后退&#13;如果你的鼠标有侧键也是可以前进后退的&#13;介个按钮随时会删掉">回首页</a>
                <p>* 观众数小于10的房间不计入统计</p>
            </h2>
            <div class="t">
                <a ng-repeat="pla in $root.topData.platforms"
                   ui-sref="room({page:1, platformName: pla.name})"
                   ui-sref-opts="{reload: true, inherit: true}"
                   ng-class="{selected: pla.name == $stateParams.platformName}">
                    <span class="ellipsis">{{pla.name}}</span>
                    <span class="min ellipsis"><i class="fa fa-user"></i>{{pla.onLineAd | wanNum}}</span>
                    <span class="min ellipsis"><i class="fa fa-home"></i>{{pla.onLineRoom | wanNum}}</span>
                </a>
            </div>
        </div>

        <div>
            <h2 class="show-params"><span><i class="fa fa-anchor"></i>分类</span></h2>
            <div class="t">
                <a ng-repeat="t in $root.topData.types"
                   ui-sref="room({page:1, tag: t.name})"
                   ui-sref-opts="{reload: true, inherit: true}"
                   ng-class="{selected: t.name == $stateParams.tag}">
                    <span class="ellipsis">{{t.name}}</span>
                    <span class="min ellipsis"><i class="fa fa-user"></i>{{t.adSum | wanNum}}</span>
                    <span class="min ellipsis"><i class="fa fa-home"></i>{{t.roomCount | wanNum}}</span>
                </a>
            </div>
        </div>
    </div>
    </script>

    %{-- 分页控件 --}%
    <script type="text/ng-template" id="paginate-tem">
    <div class="t-pagination" ng-if="config.pageCount" ng-init="tempCount = config.showCount; pCount = tempCount / 2">
        <a href="{{createHref(config.current - 1)}}" class="pre page" ng-class="{disable: config.current == 1}">上一页</a>
        <a href="{{createHref(1)}}" class="page" ng-class="{current: config.current == 1}">1</a>

        <a class="sh" ng-if="config.current - config.leftCount > 2">...</a>
        <a href="{{createHref(i)}}" class="page" ng-repeat="i in (config.current - config.leftCount | arr: config.leftCount)">{{i}}</a>
        <a href="{{createHref(i)}}" class="page current" ng-if="config.leftCount || config.current == 2">{{config.current}}</a>

        <a href="{{createHref(i)}}" class="page" ng-repeat="i in (config.current + 1 | arr: config.rightCount)" ng-if="i <= config.pageCount">{{i}}</a>
        <a class="sh" ng-if="config.pageCount - config.rightCount != config.current">...</a>
        <!--最后一页-->
        <a href="{{createHref(config.pageCount)}}" class="page" ng-if="config.current + config.rightCount < config.pageCount">{{config.pageCount}}</a>
        <a href="{{createHref(config.current + 1)}}" class="next page" ng-class="{disable: config.current == config.pageCount}">下一页</a>
    </div>
    </script>

    %{-- 弹出窗口 模板--}%
    <script type="text/ng-template" id="m-window-tem">
    <div class="t-window">
        <div class="show-window"
             ng-repeat="curWindow in config.windows"
             ng-show="!curWindow.hide"
             index="{{curWindow.index}}">
            <i class="fa fa-close close" ng-show="curWindow.closeBtn!==false" ng-class="{insert: room.quoteUrl}" ng-click="config.close(curWindow)"></i>
            <div ng-include="curWindow.url" onload="config.resize(curWindow)">
            </div>
        </div>
    </div>
    </script>

    %{-- 房间显示模板 --}%
    <script type="text/ng-template" id="room-show-tem">
    <a class="room"
       ng-click="$root.openRoom(room, $event)"
       ng-href="{{$state.href('room.insetDetail', {roomId: room.id}, {inherit: true})}}"
       ng-class="{'off-line': !room.isOnLine}"
       ng-style="roomSize">
        <table cellspacing="0" cellpadding="0">
            <tr style="height: 0">
                <td style="width:70%;"></td>
                <td></td>
            </tr>
            <tr>
                <td colspan="2" class="photo"  ng-style="{height: $root.roomSize.height - 48}">
                    <img ng-src="{{room.img}}"/>
                    <span class="pla-name">{{room.platform.name}}</span>
                    <i class="fa fa-play play trans2" ng-class="{insert: $root.isInsert(room.platform.flag)}"></i>
                    <span class="add-ss trans2">
                        <i class="fa fa-desktop" title="加入分屏" ng-click="$root.splitScreen.add(room, $event);" ng-if="$root.isInsert(room.platform.flag)"></i>
                        <i class="fa fa-bar-chart" title="观众变化图表" ng-click="$root.showChart(room, $event);"></i>
                    </span>
                </td>
            </tr>
            <tr class="top">
                <td class="ellipsis title">{{room.name}}</td>
                <td class="t-r ellipsis tag"><a ui-sref="room({page:1, tag: room.tag})"
                                                ui-sref-opts="{reload: true, inherit: true}">{{room.tag}}</a></td>
            </tr>
            <tr class="bottom">
                <td class="ellipsis anchor">
                    <i title="关注" roomId="{{room.id}}"
                       ng-click="$root.changeCollect($event, room);$event.stopPropagation();"
                       ng-class="{'fa-heart': $root.collectMap[room.id], 'fa-heart-o': !$root.collectMap[room.id]}"
                       class="fa heart"></i>{{room.anchor}}
                </td>
                <td class="t-r ellipsis num"><i class="fa fa-user"></i>{{room.adNum | wanNum}}</td>
            </tr>
        </table>
    </a>
    </script>

    %{--我的关注页面--}%
    <script type="text/ng-template" id="collect-tem">
    <div class="collect">
        <h2 class="show-params">
            <span><i class="fa fa-heart"></i>我的关注</span>
            <a class="btn" ui-sref="room({page:1, tag: '', platformName: '', kw: ''})"
               ui-sref-opts="{reload:true}" title="其实点击logo位置也可以回&#13;也可以直接使用浏览器的前进后退&#13;如果你的鼠标有侧键也是可以前进后退的&#13;介个按钮随时会删掉">回首页</a>
            <a class="btn" ng-if="$root.collects.length >= 4" ng-click="$root.splitScreen.coverAll($root.collects);" title="分屏暂不支持熊猫">分屏查看前四个房间</a>

        </h2>
        <a ng-repeat="room in allCollect" repeat-finish room-show></a>
    </div>
    </script>

    %{--推荐页面--}%
    <script type="text/ng-template" id="recommend-tem">
    <div class="collect">
        <h2 class="show-params">
            <span><i class="fa fa-rocket"></i>精彩推荐</span>
            <a class="btn" ui-sref="room({page:1, tag: '', platformName: '', kw: ''})"
               ui-sref-opts="{reload:true}" title="其实点击logo位置也可以回&#13;也可以直接使用浏览器的前进后退&#13;如果你的鼠标有侧键也是可以前进后退的&#13;介个按钮随时会删掉">回首页</a>
            <a class="btn" ng-if="recommends.length >= 4" ng-click="$root.splitScreen.coverAll(recommends);" title="分屏暂不支持熊猫">分屏查看前四个房间</a>

        </h2>
        <a ng-repeat="room in recommends" repeat-finish room-show></a>
        <div ng-if="rPaginate" t-paginate="rPaginate"></div>
    </div>
    </script>

    %{--修改密码页面--}%
    <script type="text/ng-template" id="update-pwd-tem">
    <div class="login" ng-controller="updatePwd">
        <h2>修改密码</h2>
        <div>
            <form ng-submit="submit($event)">
                <input type="text" ng-model="sData.oldPwd" placeholder="请输入当前密码"/><br/>
                <input type="password" ng-model="sData.password" placeholder="请输入密码"/><br/>
                <input type="password" ng-model="sData.rePassword" placeholder="再输一次密码"/><br/>
                <button type="submit">确认</button>
            </form>
        </div>
    </div>
    </script>

    %{--注册页面--}%
    <script type="text/ng-template" id="register-tem">
    <div class="login" ng-controller="register">
        <h2>注册</h2>
        <div>
            <form ng-submit="registerSubmit($event)">
                <input type="text" ng-model="register.name" placeholder="请输入账户名称"/><br/>
                <input type="password" ng-model="register.password" placeholder="请输入密码"/><br/>
                <input type="password" ng-model="register.rePassword" placeholder="再输一次密码"/><br/>
                <button type="submit">注册</button>
            </form>
        </div>
        <div style="text-align: right; margin-top:10px;"><a href="javascript:;" ng-click="$root.windows.close(curWindow);$root.login()">已有账号,点击登录</a></div>
    </div>
    </script>

    %{--登录页面--}%
    <script type="text/ng-template" id="login-tem">
    <!-- 登录页面 -->
    <div class="login" ng-controller="login">
        <h2>登录</h2>
        <div>
            <form ng-submit="loginSubmit($event)">
                <input type="text" ng-model="login.name" placeholder="请输入账户名称"/><br/>
                <input type="password" ng-model="login.password" placeholder="请输入密码"/><br/>
                <label ng-init="login={keep: true}"><input type="checkbox" ng-model="login.keep"/>记住登录状态</label>
                <button type="submit">登录</button>
            </form>
        </div>
        <div style="text-align: right; margin-top:10px;"><a href="javascript:;" ng-click="$root.windows.close(curWindow);$root.register()">还没有账号,点击注册</a></div>
    </div>
    </script>




    %{--房间首页列表--}%
    <script type="text/ng-template" id="index-tem">
    <div class="body">
        <div ng-if="recommends.length">
            <h2 class="show-params">
                <span><i class="fa fa-hand-o-right"></i>推荐</span>
                <a class="btn" ui-sref="room({page:1, tag: '', platformName: '', kw: ''})"
                   ui-sref-opts="{reload:true}" title="其实点击logo位置也可以&#13;返回上一页点击浏览器后退就可以了&#13;介个按钮随时会删掉">刷新首页</a>
                <a class="btn" ng-if="recommends.length >= 4" ng-click="$root.splitScreen.coverAll(recommends);" title="分屏暂不支持熊猫">分屏查看前四个房间</a>
                <a ui-sref="room.recommend({rPage:1})"
                   ui-sref-opts="{inherit: true}" class="more">更多></a>
            </h2>
            <div style="overflow: hidden; width: 100%;">
                <div style="width: 1920px;">
                    <a ng-repeat="room in recommends" repeat-finish room-show></a>
                </div>
            </div>
        </div>
        <h2 class="show-params">
            <span><i class="fa fa-youtube-play"></i>全部直播</span>
            <span ng-if="$stateParams.platformName">{{$stateParams.platformName}}</span>
            <span ng-if="$stateParams.tag">{{$stateParams.tag}}</span>
            <span ng-if="$stateParams.kw">包含'{{$stateParams.kw}}'</span>
            <a class="btn" ng-if="rooms.length >= 4" ng-click="$root.splitScreen.coverAll(rooms);" title="分屏暂不支持熊猫">分屏查看前四个房间</a>
            <a class="btn" ng-if="$stateParams.order" ui-sref="room({page:1, order: ''})">默认排序</a>
            <a class="btn" ng-if="!$stateParams.order" ui-sref="room({page:1, order: 1})">按观看数排序</a>
        </h2>
        <h3 ng-if="rooms" class="show-tit" ng-show="!rooms.length">米有找到相应的房间...</h3>
        <a ng-repeat="room in rooms" repeat-finish room-show></a>
        <div ng-if="paginate" t-paginate="paginate"></div>
        <div class="icp" ng-show="rooms"><a target="_blank" href="http://www.miitbeian.gov.cn/">皖ICP备16023346号-1</a></div>
    </div>
    <div ui-view class="detail-view"></div>

    </script>

    %{--房间详情页--}%
    <script type="text/ng-template" id="inset-detail-tem">
    <div class="r-detail">
        <!-- 背景 -->
        <img ng-src="{{curRoom.img}}" class="back-img filter-blur" />
        <!-- 内容 -->
        <div class="d-content" ng-show="curRoom.quoteUrl || curRoom.iframeUrl">
            <div class="top">
                <i class="fa fa-close" title="关闭" ng-click="close()"></i>
            </div>
            <div class="cen">

                <h3 class="ellipsis">{{curRoom.name}}
                    <a>{{curRoom.anchor}}
                        <i
                                roomId="{{room.id}}"
                                ng-click="$root.changeCollect($event, curRoom);$event.stopPropagation();"
                                ng-class="{'fa-heart': $root.collectMap[curRoom.id], 'fa-heart-o': !$root.collectMap[curRoom.id]}"
                                class="fa heart">{{$root.collectMap[curRoom.id] ? "取消关注" : "关注"}}</i>
                        <i class="fa fa-desktop" ng-click="$root.splitScreen.add(curRoom, $event)" title="加入分屏"></i>
                        <i class="fa fa-bar-chart" title="观众变化图表" ng-click="$root.showChart(curRoom, $event);"></i>
                    </a>

                </h3>

                <div class="embed-div">

                </div>

            </div>

        </div>

        <div class="d-content-i" ng-show="!curRoom.quoteUrl && !curRoom.iframeUrl">
            <div class="btns trans2">
                <i title="{{$root.collectMap[curRoom.id] ? '取消关注' : '关注'}}" roomId="{{room.id}}"
                   ng-click="$root.changeCollect($event, curRoom);$event.stopPropagation();"
                   ng-class="{'fa-heart': $root.collectMap[curRoom.id], 'fa-heart-o': !$root.collectMap[curRoom.id]}"
                   class="fa heart"></i>
                <i class="fa fa-desktop" title="加入分屏" ng-click="$root.splitScreen.add(curRoom, $event)"></i>
                <i class="fa fa-bar-chart" title="观众变化图表" ng-click="$root.showChart(curRoom, $event);"></i>
                <a class="fa fa-level-up" target="_blank" title="新窗口打开{{curRoom.platform.name}}观看" href="{{curRoom.url}}"></a>
            </div>
            <i class="fa fa-close" title="关闭" ng-click="close()" style="position: absolute;right: 0;top: 0;font-size: 20px;color: #fff;padding: 5px;margin: 5px 21px 0 0;"></i>
            <iframe style="width:100%; height:100%; border:none;"></iframe>
        </div>
    </div>

    </script>

    %{--分屏观看模板--}%
    <script type="text/ng-template" id="split-tem">
    <div class="room-split">
        <div class="detail trans s-pos-{{room.splitSort}}" ng-class="{'no-local': noLocal}" ng-repeat="room in (noLocal ? splitRooms : $root.splitScreen.data)" ng-init="room.iframeUrl = $root.getIframeUrl(room)">
            <iframe ng-if="room.iframeUrl" style="width:100%; height:100%; border:none;" src="{{trustSrc(room.iframeUrl)}}"></iframe>
            <embed ng-if="room.quoteUrl" src="{{trustSrc(room.quoteUrl)}}" style="width: 100%; height: 100%" allownetworking="all" allowscriptaccess="always" quality="high" bgcolor="#000" wmode="window" allowfullscreen="true" allowFullScreenInteractive="true" type="application/x-shockwave-flash">
                <iframe ng-if="!room.iframeUrl && !room.quoteUrl" src="{{trustSrc(room.url)}}" style="width:100%; height:100%; border:none;"></iframe>
                <div class="split-tools">
                    <i title="关注" roomId="{{room.id}}"
                       ng-click="$root.changeCollect($event, room);"
                       ng-class="{'fa-heart': $root.collectMap[room.id], 'fa-heart-o': !$root.collectMap[room.id]}"
                       class="fa heart"></i>
                    <i class="fa fa-bar-chart" title="观众变化图表" ng-click="$root.showChart(room, $event);"></i>
                    <span ng-if="!noLocal">
                        <a class="fa fa-arrow-left" title="向前移动" ng-click="$root.splitScreen.move(room, -1)"></a>
                        <a class="fa fa-arrow-right" title="向后移动" ng-click="$root.splitScreen.move(room, 1)"></a>
                        <a class="fa fa-remove" title="从分屏列表移除" ng-click="$root.splitScreen.remove(room.id)"></a>

                    </span>
                    <span ng-if="noLocal">
                        <a class="fa fa-desktop" title="添加到我的分屏" ng-click="$root.splitScreen.add(room)"></a>
                    </span>

                    <a class="fa fa-level-up" target="_blank" title="新窗口打开{{room.platform.name}}观看" href="{{room.url}}"></a>
                </div>

        </div>
    </div>
    </script>

    %{--用户观众变化图表--}%
    <script type="text/ng-template" id="log-tem">
    <div class="room-log">
        <div ng-repeat="roomLog in roomLogs" log-chart="roomLog">

        </div>
    </div>
    </script>

    <!-- 波动图表 -->
    <script type="text/ng-template" id="one-chart-tem">
        <div class="one-chart" ng-controller="oneLog">
            <div ng-if="roomLog" log-chart="roomLog"></div>
        </div>
    </script>

    %{--单个观众变化图表指令--}%
    <script type="text/ng-template" id="log-chart-tem">
    <div class="log-chart">
        %{--<div>--}%
            %{--<span class="chart-range">得分：{{roomLog.mark}}</span>--}%
            %{--<span class="chart-range">样本总数：{{contentData.length}}</span>--}%
            %{--<span class="chart-range" ng-repeat="range in rangeStatistics">波动{{range.title}}数量：{{range.count}}</span>--}%
            %{--<span class="chart-range">{{roomLog.dateCreated}}</span>--}%
        %{--</div>--}%
        <div class="chart">

        </div>

    </div>


    </script>
</head>

<body style="overflow: hidden">
<div class="main" ng-cloak>
    <div class="danmu">

    </div>

    %{-- 用户信息--}%
    <div class="f-user trans2">
        <div class="no-login" ng-if="curUser">
            <i style="cursor: default"><span class="fa fa-user"></span>&nbsp;{{curUser.name}}<span ng-if="curUser.isVip" class="vip" title="传说中尊贵的SVIP" ng-style="{color: curUser.color}">贵</span></i>
            <i class="fa fa-comments chat-icon" ng-click="$root.chat.showHide()" title="网站闲聊"></i>
            <i class="fa fa-key" ng-click="windows.add({url: 'update-pwd-tem'})" title="修改密码"></i>
            <i class="fa fa-power-off" ng-click="$root.logout()" title="退出"></i>
        </div>
        <div class="login-in" ng-if="!curUser">
            <a class="login-btn" ng-click="$root.login()">登录</a>|<a class="register-btn" ng-click="$root.register()">注册</a>
        </div>
        <a href="mailto:ty_bt@live.cn" style="color:#797979; line-height: 20px; margin-top:6px;">站务与建议:ty_bt@live.cn</a>
    </div>
    <div class="content">
        <div class="left-bg"></div>
        <div class="left">
            <a ui-sref="room({page:1, tag: '', platformName: '', kw: ''})"
               ui-sref-opts="{reload:true}" title="首页">
                <h1 class="trans"><span>zuo</span> TV</h1>
            </a>
            <div class="condition search-input">
                <input type="text" placeholder="输入房间名或主播名搜索" ng-keyup="search.submit($event)" ng-model="search.kw" />
                <i class="fa fa-search" ng-click="$state.go('room', {page:1, kw: search.kw}, {inherit: true})"></i>
            </div>

            <div class="m-search trans2">

                <div class="condition" ng-show="topData.platforms">
                    <h2>平台<a ui-sref="room.recommend({rPage:1})"
                             ui-sref-opts="{inherit: true, reload:true}">精彩推荐></a></h2>
                    <div class="checkeds">
                        <a href="#" ng-class="{selected: !$stateParams.platformName}"
                           ui-sref="room({page:1, platformName: ''})"
                           ui-sref-opts="{inherit: true, reload:true}">全部</a>
                        <a ng-repeat="pla in topData.platforms"
                           ui-sref="room({page:1, platformName: pla.name})"
                           ui-sref-opts="{inherit: true, reload:true}"
                           ng-class="{selected: pla.name == $stateParams.platformName}">{{pla.name}}</a>

                    </div>
                </div>
                <div class="condition" ng-show="topData.types">
                    <h2>分类<a ui-sref="room.type"
                             ui-sref-opts="{inherit: true, reload:true}"
                             ng-show="topData.types.length > 20">全部排名></a>
                    </h2>
                    <div class="checkeds">
                        <a ui-sref="room({page:1, tag: ''})"
                           ui-sref-opts="{inherit: true, reload:true}"
                           ng-class="{selected: !$stateParams.tag}">全部</a>
                        <a ng-repeat="t in topData.types"
                           ui-sref="room({page:1, tag: t.name})"
                           ui-sref-opts="{inherit: true, reload:true}"
                           ng-if="$index < 20 || t.name == $stateParams.tag"
                           ng-class="{selected: t.name == $stateParams.tag}">{{t.name}}</a>

                    </div>
                </div>
                <div class="condition" ng-show="$root.splitScreen.data.length">
                    <h2>分屏&nbsp;<span style="font-size: 13px;" ng-show="$root.splitScreen.data.length">{{$root.splitScreen.data.length}}</span>
                        <span id="copy-split" class="fa fa-share-alt" title="复制分享链接"></span>
                        <span class="fa fa-question-circle-o" title="点击开始进入分屏界面&#13;在分屏界面依然可以在左侧列表移除房间&#13;在分屏界面依然可以从左侧关注列表添加房间&#13;斗鱼和战旗体验比较好，暂不支持熊猫&#13;其他的平台在页面中点击网页全屏体验会好点"></span>
                        <span class="fa fa-remove" title="清空分屏列表" ng-click="$root.splitScreen.clear()"></span>
                        <a ui-sref="room.split({ids: ''})"
                           ui-sref-opts="{inherit: true, reload:true}" ng-show="$root.splitScreen.data.length">开始></a>
                    </h2>

                    <div>
                        <a ng-repeat="room in $root.splitScreen.data | orderBy : '-splitSort'"
                        %{--<a ng-repeat="coll in $root.collects"--}%
                           repeat-finish
                           ng-click="openRoom(room, $event)"
                           class="room2 trans2"
                           ng-href="{{$state.href('room.insetDetail', {roomId: room.id}, {inherit: true})}}">
                            <img ng-src="{{room.img}}"/>
                            <span class="ellipsis top pla-name">{{room.platform.name}}</span>
                            <span class="ellipsis top anchor">
                                <i title="{{$root.collectMap[room.id] ? '取消关注' : '关注'}}" roomId="{{room.id}}"
                                   ng-click="$root.changeCollect($event, room);$event.stopPropagation();"
                                   ng-class="{'fa-heart': $root.collectMap[room.id], 'fa-heart-o': !$root.collectMap[room.id]}"
                                   class="fa heart"></i>{{room.anchor}}
                            </span>
                            <span class="ellipsis bottom room-name">{{room.name}}</span>
                            <span class="ellipsis bottom num">{{room.adNum | wanNum}}</span>
                            <span class="r-btn" >
                                <i class="fa fa-bar-chart" title="观众变化图表" ng-click="$root.showChart(room, $event);"></i>
                                <i class="fa fa-remove" title="移除" ng-click="$root.splitScreen.remove(room.id, $event)"></i>
                            </span>
                        </a>
                    </div>
                </div>
                <div class="condition">
                    <h2>我的关注&nbsp;<span style="font-size: 13px;" ng-show="$root.collects.length">{{$root.onLineCollects.length}}/{{$root.collectsTotal}}</span>
                        <a ui-sref="room.collect"
                           ui-sref-opts="{inherit: true, reload:true}" ng-show="$root.curUser && $root.collects.length">全部></a>
                    </h2>
                    %{-- 未登录 --}%
                    <div ng-if="!$root.curUser" class="collect-login">
                        <a ng-click="$root.login()">登录</a>
                        |
                        <a ng-click="$root.register()">注册</a>
                    </div>
                    %{-- 已登录 --}%
                    <div ng-if="$root.curUser">
                        <h3 class="show-tit" ng-show="!$root.onLineCollects.length">你关注的房间都没上线,哈哈...</h3>
                        <h3 class="show-tit" ng-show="!$root.collects.length">额,原来你一个房间都没关注 -.-</h3>
                        <a ng-repeat="room in $root.onLineCollects"
                        %{--<a ng-repeat="coll in $root.collects"--}%
                           repeat-finish
                           ng-click="openRoom(room, $event)"
                           class="room2 trans2"
                           ng-href="{{$state.href('room.insetDetail', {roomId: room.id}, {inherit: true})}}">
                            <img ng-src="{{room.img}}"/>
                            <span class="ellipsis top pla-name">{{room.platform.name}}</span>
                            <span class="ellipsis top anchor">
                                <i title="取消关注" roomId="{{room.id}}"
                                   ng-click="$root.changeCollect($event, room);$event.stopPropagation();"
                                   ng-class="{'fa-heart': $root.collectMap[room.id], 'fa-heart-o': !$root.collectMap[room.id]}"
                                   class="fa heart"></i>{{room.anchor}}
                            </span>
                            <span class="ellipsis bottom room-name">{{room.name}}</span>
                            <span class="ellipsis bottom num">{{room.adNum | wanNum}}</span>
                            <span class="r-btn" >
                                <i class="fa fa-bar-chart" title="观众变化图表" ng-click="$root.showChart(room, $event);"></i>
                                <i class="fa fa-desktop" title="加入分屏" ng-if="$root.isInsert(room.platform.flag)" ng-click="$root.splitScreen.add(room, $event)"></i>
                            </span>
                            %{--<span class="r-btn" ng-if="$root.isInsert(room.platform.flag)" ng-click="$root.splitScreen.add(room, $event)">加入分屏</span>--}%
                            %{--<i class="fa fa-play-circle play" ng-class="{insert: room.quoteUrl}"></i>--}%
                        </a>
                    </div>
                </div>
                <div ng-style="{height: $root.chat.show ? 355 : 60}"></div>
            </div>
        </div>
        <div class="right">
            <div class="head trans2">
                <div class="top-menu">
                    <a ui-sref="room({page:1, tag: '', platformName: '', kw: ''})"
                       ui-sref-opts="{reload:true}">首页</a>
                    <a ui-sref="room.type"
                       ui-sref-opts="{inherit: true, reload:true}">分类</a>
                    <a ui-sref="room.recommend({rPage:1})"
                       ui-sref-opts="{inherit: true, reload:true}">推荐</a>
                    <a ui-sref="room.collect"
                       ui-sref-opts="{inherit: true, reload:true}"
                       ng-show="$root.curUser">我的关注</a>
                </div>
                %{--<div style="float: right; height: 45px; overflow: hidden; text-align: right">--}%
                <div class="right-o">

                    <div class="cur-user" ng-class="{'login-user': curUser}">

                        <div class="user-o">
                            <i style="cursor: default"><span class="fa fa-user"></span>&nbsp;{{curUser.name}}<span ng-if="curUser.isVip" class="vip" title="传说中尊贵的SVIP" ng-style="{color: curUser.color}">贵</span></i>
                            <i class="fa fa-key" ng-click="windows.add({url: 'update-pwd-tem'})" title="修改密码"></i>
                            <i class="fa fa-power-off" ng-click="$root.logout()" title="退出"></i>
                        </div>
                        <div>
                            <a class="login-btn" ng-click="$root.login()">登录</a>
                            <a class="register-btn" ng-click="$root.register()">注册</a>
                        </div>
                        <div class="clear"></div>
                    </div>
                </div>
            </div>
            <div ui-view class="m-view">

            </div>
        </div>
    </div>


    %{-- 弹出窗口管理 --}%
    <div m-window="windows">

    </div>

</div>

%{-- 聊天 --}%
<div class="chat" ng-show="$root.chat.show" ng-cloak>
    <div class="chat-head">闲聊<a class="fa fa-close" ng-click="$root.chat.showHide()"></a></div>
    <div class="chat-logs">
        <div class="chat-logs-height">
            <div ng-repeat-start="log in chat.logs" ng-if="log.longTime" class="date">{{log.d | date: 'MM-dd HH:mm'}}</div>
            <div ng-repeat-end class="log" ng-class="{self: curUser && log.u.n === curUser.name}">
                <div class="name" ng-style="{color: log.u.c}" title="{{log.u.n}}">{{log.u.n.substr(-1, 1)}}</div>
                <div class="msg"><pre>{{log.msg}}</pre></div>
                <div class="clear"></div>
            </div>
        </div>
    </div>
    <div class="chat-send trans" ng-if="curUser">
        <textarea ng-model="chat._sendMsg" spellcheck="false" maxlength="500" ng-keyup="chat.keyupSend($event)"></textarea>
        <a class="fa fa-send-o" ng-click="chat.keyupSend()"></a>
    </div>
    <div class="chat-login" ng-if="!curUser">
        <a class="login-btn" ng-click="$root.login()">登录</a>
        <a class="register-btn" ng-click="$root.register()">注册</a>
    </div>
</div>
<script type="text/javascript">
    // google跟踪代码
    (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
                (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
            m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
    })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

    ga('create', 'UA-88253768-1', 'auto');
    ga('send', 'pageview');

    // baidu跟踪代码
    var _hmt = _hmt || [];
    // 关闭自动记录
    _hmt.push(['_setAutoPageview', false]);
    (function() {
        var hm = document.createElement("script");
        hm.src = "https://hm.baidu.com/hm.js?ef1feae8cc0e92928cabf9ef9c690893";
        var s = document.getElementsByTagName("script")[0];
        s.parentNode.insertBefore(hm, s);
    })();
</script>
</body>

</html>
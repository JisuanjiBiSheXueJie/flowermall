<!DOCTYPE html>
<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="import.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>系统首页</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/e/css/index.css" type="text/css"></link>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/web2table.css" type="text/css"></link>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/e/css/box.all.css" type="text/css"></link>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/e/css/leaveword.css" type="text/css"></link>
    <script src="${pageContext.request.contextPath}/webui/jquery/jquery-1.12.4.min.js" type="text/javascript"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/e/css/owl.carousel.min.css">
    <script src="${pageContext.request.contextPath}/e/js/owl.carousel.min.js"></script>
    <script src="${pageContext.request.contextPath}/e/js/SmartStorage.js"></script>
    <script type='text/javascript' src='${pageContext.request.contextPath}/webui/vue/vue.js'></script>
    <script type='text/javascript' src='${pageContext.request.contextPath}/webui/vue/vue-resource-1.3.4.js'></script>
    <link href="${pageContext.request.contextPath}/webui/vue/elementui/theme-chalk/index.css" rel="stylesheet"/>
    <script src="${pageContext.request.contextPath}/webui/vue/elementui/index.js"></script>
</head>
<body>

<div id="app">
    <page-header headid="${param.headid}"></page-header>
    <div class="wrap round-block">

        <div class="line-title">
            当前位置：<a href="${pageContext.request.contextPath}/e/index.jsp">首页</a> >> 商品信息>>{{shangpin.name }}
        </div>

        <div class="fn-clear"></div>
        <div class="shangpin-info clearfix">
            <div class="pic-area">
                <div class="big-img">
                    <img :src="'${pageContext.request.contextPath}'+bigPic"/>
                </div>
                <div class="small-imgs owl-carousel">
                    <div @click="select(item,index)" v-for="(item,index) in shangpin.images "
                         :class="index==selectedIndex?'active item':'item'">
                        <img :src="'${pageContext.request.contextPath}'+item"/>
                    </div>
                </div>
            </div>


            <div class="props">
                <div class="title">

                    {{shangpin.name}}
                </div>
                <div class="subtitle">
                    {{shangpin.subtitle}}
                </div>
                <div class="price-block clearfix">
                    <div class="bq">
                        <span class="tip">爆款</span>
                    </div>

                    <div class="mall-price clearfix">
                        <div class="label">价格</div>
                        <div class="price"> ¥ {{shangpin.hyjia}}</div>

                    </div>
                </div>
                <div style="margin-top:20px " class="prop">
                    <dl class="clearfix">
                        <dt>库存</dt>
                        <dd>{{shangpin.kucun}}{{shangpin.danwei}}</dd>
                    </dl>
                </div>

                <div style="margin-top:20px " class="prop">
                    <dl class="clearfix">
                        <dt>产地</dt>
                        <dd>{{shangpin.chandi}}</dd>
                    </dl>
                </div>


                <div class="prop">
                    <dl class="clearfix">
                        <dt>数量</dt>
                        <dd>
                            <el-input-number v-model="count" :min="1" :max="10" label="描述文字"></el-input-number>
                        </dd>
                    </dl>


                </div>


                <div class="prop">


                    <el-button-group>
                    <el-button type="primary" @click="shoucangHandler" ><i class="fa fa-star"></i>收藏</el-button>


                    <el-button v-if="shangpin.kucun>0" @click="toCartHandler" type="danger">
	                    <i class="fa fa-plus"></i>加入购物车
	                 </el-button>

                    </el-button-group>

                </div>


            </div>
        </div>

        <div v-if="listRecomment!=null&&listRecomment.length>0" class="video-list">
            <div class="hd">
                猜你喜欢商品
            </div>
            <div class="bd">

                <div v-for="item in listRecomment" class="item">
                    <div class="card">
                        <a :href="hostHead+'/e/shangpininfo.jsp?id='+item.id">
                            <div class="pic">
                                <img class="image" :src="hostHead+item.images[0]"/>

                            </div>
                            <div class="name">
                                {{item.name}}--({{item.tagname}})
                            </div>
                            <div class="discount"></div>
                            <div class="price">¥{{item.hyjia}}</div>
                        </a>
                    </div>
                </div>

            </div>
        </div>

        <el-tabs value="first">
            <el-tab-pane label="商品介绍" name="first">
                <div class="brief-content" v-html="shangpin.jieshao"></div>
            </el-tab-pane>
            <el-tab-pane label="商品评价" name="second">
                <div class="spcomment-list">

                    <div v-for="comment in listComment" class="item clearfix">
                        <div class="lfar">
                            <img :src="'${pageContext.request.contextPath}'+comment.touxiang" class="photo"/>
                        </div>
                        <div class="rgar">
                            <div class="trow">
                                {{comment.accountname}}({{comment.name}})
                            </div>
                            <div class="trow">
                                <el-rate :value="comment.cresult"></el-rate>
                                {{comment.des}}
                            </div>
                        </div>


                    </div>
                    <div v-if="listComment.length==0" class="no-record-tip">
                        <div class="content">
                            <i class="fa fa-warning"></i>暂无相关评论
                        </div>
                    </div>
                </div>
            </el-tab-pane>
        </el-tabs>


        <login-dlg :show.sync="openLogin"></login-dlg>


    </div>


</div>


<div class="fn-clear"></div>


<jsp:include page="bottom.jsp"></jsp:include>


</body>
</html>
<script type="text/javascript">


    Vue.http.options.root = '${pageContext.request.contextPath}';

    Vue.http.options.emulateJSON = true;
    Vue.http.options.xhr = {withCredentials: true};

    let vm = new Vue({
        el: "#app",
        data: {
            listComment: [],
            bigPic: "",
            count: 1,
            hostHead: "${pageContext.request.contextPath}",
            listRecomment: [],
            selectedIndex: 0,
            shangpin: {},
            openLogin: false,
            hyid: "${sessionScope.huiyuan.id}"

        },
        async created() {

            let id = "${param.id}";
            await this.getShangpin(id);
            await this.getComment(id);
            await this.getRecomment();

        },
        methods: {
            getComment(id) {
                let url = "admin/spcomment/list";

                this.$http.post(url, {
                    id: id
                }).then(res => {
                    this.listComment = res.data.data;
                    console.log(res.data);
                });

            },


            getRecomment() {
                if (this.hyid == "") {
                    return;
                }
                let url = "admin/shangpin/recomment";
                this.$http.post(url, {id: this.shangpin.id}).then(res => {
                    console.log(res.data);
                    if (res.data != null && res.data.data != null)
                        this.listRecomment = res.data.data;
                });

            },
            select(item, index) {
                this.bigPic = item;
                this.selectedIndex = index;
            },
            async getShangpin(id) {
                let url = "admin/shangpin/info";
                let p1 = {id: id};

                if (this.hyid != "")
                    p1.hyid = this.hyid;
                let {data: res} = await this.$http.post(url, p1);
                this.shangpin = res.data;
                this.bigPic = this.shangpin.images[0];
                this.$nextTick(() => {
                    $('.small-imgs').owlCarousel({navigation: true});
                });

            },

            toCartHandler() {
                if (this.hyid == "") {
                    this.openLogin = true;
                    return;
                }
                let cart = new SmartStorage();
                let cartitem = {
                    id: this.shangpin.id,
                    name: this.shangpin.name,
                    tupian: this.shangpin.images[0],
                    count: this.count,
                    selected: true,
                    price: this.shangpin.jiage,
                    typename: this.shangpin.typename
                };
                cart.add(this.shangpin.id, cartitem);
                window.location = "shopcart.jsp";

            },
            async shoucangHandler() {
                if (this.hyid == "") {
                    this.openLogin = true;
                    return;
                }
                let url = "admin/shoucang/save";
                console.log("shanppin.id=", this.shangpin.id);

                let {data: res} = await this.$http.post(url, {
                    targetid: this.shangpin.id,
                    targetname: this.shangpin.name,
                    tupian: this.shangpin.images[0],
                    hyid: this.hyid == null ? 0 : this.hyid,
                    xtype: "shangpin",
                    href: "/e/shangpininfo.jsp?id=" + this.shangpin.id
                });
                if (res != null && res.stateCode < 0) {
                    this.$message.error(res.des);
                    return;
                }
                this.$message.success("收藏成功");
            }


        }

    });

</script>
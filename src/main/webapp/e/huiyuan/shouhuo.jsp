<%@ page language="java" import="java.util.*" pageEncoding="UTF-8" %>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="law.jsp" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>订单信息查看</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/e/css/index.css" type="text/css"></link>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/e/css/box.all.css" type="text/css"></link>
    <link href="${pageContext.request.contextPath}/admin/css/web2table.css" rel="stylesheet" type="text/css"/>
    <script type="text/javascript" src="${pageContext.request.contextPath}/webui/jquery/jquery-1.12.4.min.js"></script>
    <script type='text/javascript' src='${pageContext.request.contextPath}/webui/vue/vue.js'></script>
    <script type='text/javascript' src='${pageContext.request.contextPath}/webui/vue/vue-resource-1.3.4.js'></script>
    <link href="${pageContext.request.contextPath}/webui/vue/elementui/theme-chalk/index.css" rel="stylesheet"/>
    <script src="${pageContext.request.contextPath}/webui/vue/elementui/index.js"></script>


</head>
<body>
<div id="app">
    <page-header></page-header>
    <div class="wrap round-block">
        <div class="line-title">
            当前位置：<a href="${pageContext.request.contextPath}/e/index.jsp">首页</a> &gt;&gt; 收货评价
        </div>

        <div class="pcontent">
            <div>

                <div class="shaddr-wrap">
                    <div class="logo"><i class="fa fa-location-arrow"></i></div>
                    <div v-if="huiyuan!=null" class="bd">

                        <div class="contact">
                            {{huiyuan.receaddresses[0].mobile}}
                            {{huiyuan.name}}
                        </div>
                        <div class="addinfo">{{huiyuan.receaddresses[0].addinfo}}
                            <span>{{huiyuan.receaddresses[0].postcode}}</span>
                        </div>

                    </div>

                </div>

                <table v-for="od in order.orderDetail" class="smart-table" border="1">
                    <tr>
                        <td class="tlabel">订单编号</td>
                        <td>{{order.ddno}}</td>
                        <td class="tlabel">下单时间:</td>
                        <td>
                            {{order.createtime}}

                        </td>
                    </tr>
                    <tr>
                        <td class="tlabel">商品</td>
                        <td colspan="3">
                            <img width="80" height="80" :src="hostHead+od.images[0]"/>
                            {{od.spname}}
                            {{od.price}}¥X{{od.count}}
                        </td>
                    </tr>
                    <tr>
                        <td class="tlabel">评价:</td>
                        <td colspan="3">
                            <el-rate v-model="star"></el-rate>
                        </td>
                    </tr>
                    <tr>
                        <td class="tlabel">描述</td>
                        <td colspan="3">
                            <div v-if="od.state==3" style="width: 300px;" v-if="od.state==3">
                                <el-input
                                        type="textarea"
                                        :rows="2"
                                        placeholder="请输入内容"
                                        v-model="des"
                                        clearable>
                                </el-input>
                            </div>
                            <div v-if="od.state==4">
                                {{od.comment.des}}
                            </div>
                        </td>
                    </tr>
                    <tr v-if="od.state==3">

                        <td colspan="4">
                            <span @click="pingjiaHandler" class="btn btn-danger">收货评价</span>
                        </td>
                    </tr>

                </table>


            </div>

        </div>
    </div>
</div>
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
            id: "${param.id}",
            oiid: '${param.oiid}',
            star: 0,
            des: '',
            hostHead: '${pageContext.request.contextPath}',
            order: {},
            huiyuan: null
        },
        methods: {

            async getOrderInfo() {
                let {data: res} = await this.$http.post("admin/shorder/info", {id: this.id});
                if (res.stateCode < 0) {
                    this.$message.error(res.des);
                    return;
                }

                res.data.orderDetail = res.data.orderDetail.filter(c => {
                    return c.id == this.oiid;
                });

                this.order = res.data;
                if (this.order.orderDetail[0].comment != null)
                    this.star = this.order.orderDetail[0].comment.cresult;
                console.log("this.order", this.order);

            },
            async getHuiyuanInfo() {

                let {data: res} = await this.$http.post("admin/huiyuan/info", {id: this.order.purchaser});

                if (res.stateCode < 0) {
                    this.$message.error(res.des);
                    return;
                }
                this.huiyuan = res.data;
                console.log("huiyuan", this.huiyuan);
            },
            async pingjiaHandler() {
                if (this.star == 0) {
                    this.$message.error("请选择评价等级");
                    return;
                }
                if (this.des == "") {
                    this.$message.error("请填写评论");
                    return;
                }
                let {data: res} = await this.$http.post("admin/shorder/shouhuo", {
                    oiid: this.oiid,
                    star: this.star,
                    des: this.des,
                    appraiserid: this.huiyuan.id
                });

                if (res.stateCode < 0) {
                    this.$message.error(res.des);
                    return;
                }
                this.$message.success("评论完成");
                this.getOrderInfo();

            }
        },
        async created() {
            await this.getOrderInfo();
            await this.getHuiyuanInfo();
        }

    });

</script>

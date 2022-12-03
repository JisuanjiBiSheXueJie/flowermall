<%@ page language="java" import="java.util.*" pageEncoding="UTF-8" %>

<%@ include file="law.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="daowen" uri="/daowenpager" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
    <title>订单信息</title>
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
            当前位置：<a href="${pageContext.request.contextPath}/e/index.jsp">首页</a> &gt;&gt; 订单管理
        </div>


        <div class="pcontent">

            <!-- 搜索控件开始 -->
            <div class="search-options">

                <table  cellspacing="1" width="100%">
                    <tbody>
                    <tr>
                        <td>订单号 <input name="ddno" @keyup.enter="search" v-model="ddno" class="input-txt" type="text"/>

                            <el-button @click="search"  type="primary" icon="el-icon-search">搜索</el-button>
                        </td>
                    </tr>
                    </tbody>
                </table>

            </div>
            <!-- 搜索控件结束 -->
            <div class="clear"></div>


            <div class="cst-list">

                <div v-for="order in listOrder" :key="order.id" class="item">
                    <div class="title">
                        {{order.ddno}}
                    </div>
                    <div class="subtitle">
                        <div class="it">{{order.createtime}}</div>
                        <div class="it">订单编号:{{order.ddno}}</div>

                        <div class="it">状态:
                            <span v-if="order.state==1">待付款</span>
                            <span v-if="order.state==2">待发货</span>
                            <span v-if="order.state==3">待评价</span>
                            <span v-if="order.state==4">已评价</span>
                            <span v-if="order.state==5">已取消</span>

                        </div>
                        <div class="it">

                            <div v-if="order.state==1">
                                <a :href="hostHead+'/e/huiyuan/payment.jsp?seedid=301&id='+order.id" class="action-btn">付款</a>
                                <a :href="hostHead+'/e/huiyuan/cancelorder.jsp?id='+order.id" class="action-btn">取消</a>
                            </div>

                        </div>
                    </div>

                    <div v-for="od in order.orderDetail" :key="od.id" class="bd clearfix">
                        <div class="img-area fn-left">
                            <img v-if="od.images!=null" :src="hostHead+od.images[0]"/>
                        </div>
                        <div class="des-area fn-left">
                            <div>{{od.spname}}</div>
                            <div>{{od.price}}X{{od.count}}</div>
                            <div>商户:{{od.shaccount}}{{od.shname}}</div>
                        </div>

                        <div class="des-area fright">

										<span v-if="od.state==3">
											<a :href="hostHead+'/e/huiyuan/shouhuo.jsp?id='+order.id+'&oiid='+od.id"
                                               class="action-btn">收货评价</a>
										</span>


                            <a :href="hostHead+'/e/huiyuan/shorderdetails.jsp?id='+order.id" class="action-btn">订单详情</a>
                        </div>
                    </div>

                </div>

            </div>

            <div v-if="listOrder!=null&&listOrder.length==0" class="no-data">
                <div class="bd">
                    <img class="img" src="${pageContext.request.contextPath}/admin/images/nodata.png"/>
                    <div class="text">暂无订单数据</div>
                </div>

            </div>


            <div class="clear"></div>
            <el-pagination
                    @size-change="pagesizeChange"
                    @current-change="pageindexChange"
                    :current-page="pageindex"
                    :page-sizes="[pagesize]"
                    :page-size="pagesize"
                    layout="total, sizes, prev, pager, next, jumper"
                    :total="total">
            </el-pagination>
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
            ddno: "",
            hostHead: '${pageContext.request.contextPath}',
            selectedAll: false,
            listOrder: [],
            pageindex: 1, //初始页
            pagesize: 10,
            total: 10
        },
        methods: {
            pagesizeChange: function (pagesize) {
                this.pagesize = pagesize;
            },
            pageindexChange: function (pageindex) {
                this.pageindex = pageindex;
                console.log(this.pageindex);
                this.search();
            },
            async search() {
                let url = "admin/shorder/list";
                let param = {
                    currentpageindex: this.pageindex,
                    pagesize: this.pagesize,
                    ddno: this.ddno,
                    purchaser: '${sessionScope.huiyuan.id}'
                };
                console.log("this.pageindex=" + this.pageindex);
                let {data: res} = await this.$http.post(url, param);
                if (res != null) {
                    let pageInfo = res.data;
                    this.total = pageInfo.total;
                    this.listOrder = pageInfo.list;

                    console.log(pageInfo);
                }
            },
            async deleteRec() {
                let url = "admin/shorder/delete";
                let hasChecked = this.listOrder.some(c => {
                    return c.rowSelected == true;
                });
                if (!hasChecked) {
                    this.$alert('请选择需要删除的记录', '系统提示', {
                        confirmButtonText: '确定'
                    });
                    return;
                }

                let ids = this.listOrder.filter(c => c.rowSelected).map(c => c.id);
                console.log("ids", ids);
                let res = this.$confirm('是否要删除订单信息?', '系统提示', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning',
                }).then(() => {
                    this.$http.post(url, {ids}).then(res => {
                        if (res.data != null && res.data.stateCode > 0) {
                            this.search();
                        }
                    });
                }).catch(() => {
                });
            },
            selectedAllHandler() {
                console.log(this.selectedAll);
                if (this.listOrder != null) {
                    this.listOrder.forEach(c => {
                        c.rowSelected = !this.selectedAll;
                    });
                }
            }
        },
        created() {
            this.search();
        }
    });

</script>


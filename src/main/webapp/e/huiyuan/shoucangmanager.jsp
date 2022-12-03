<%@ page language="java" import="java.util.*" pageEncoding="UTF-8" %>

<%@ include file="law.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ taglib prefix="daowen" uri="/daowenpager" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>

    <title>收藏信息</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/e/css/index.css" type="text/css"></link>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/e/css/box.all.css" type="text/css"></link>

    <script src="${pageContext.request.contextPath}/webui/jquery/jquery-1.12.4.min.js" type="text/javascript"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/webui/vue/vue.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/webui/vue/vue-resource-1.3.4.js"></script>
    <link href="${pageContext.request.contextPath}/webui/vue/elementui/theme-chalk/index.css" rel="stylesheet"/>
    <script src="${pageContext.request.contextPath}/webui/vue/elementui/index.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/webui/vue/vueutil.js"></script>
    <link href="${pageContext.request.contextPath}/admin/css/web2table.css" rel="stylesheet" type="text/css"/>

</head>


<body>
<div id="app">
    <page-header></page-header>
    <div class="wrap round-block">
        <div class="line-title">
            当前位置：<a href="${pageContext.request.contextPath}/e/index.jsp">首页</a> &gt;&gt; 收藏
        </div>

        <div class="pcontent">

            <div>


                <!-- 搜索控件开始 -->
                <div class="search-options">


                    <table cellspacing="0" width="100%">
                        <tbody>

                        <tr>
                            <td>


                                <input name="targetname" @keyup.enter="search" v-model="targetname" class="input-txt"
                                       type="text"/>


                                    <el-button @click="search"  type="primary" icon="el-icon-search">搜索</el-button>
                            </td>
                        </tr>
                        </tbody>
                    </table>


                </div>
                <!-- 搜索控件结束 -->

                <div class="clear">
                </div>


                <div class="action-details">
                    <div class="btn-group">

                        <!--{{export
                    -view}}-->
                        <span class="btn btn-success" @click="deleteRec">删除</span>
                    </div>
                </div>

                <table id="shoucang" width="100%" border="0" cellspacing="0" cellpadding="0" class="ui-record-table">
                    <thead>
                    <tr>
                        <th>
                            <input type="checkbox" @click="selectedAllHandler" v-model="selectedAll"/>
                        </th>


                        <th><b>名称</b></th>


                        <th><b>图片</b></th>


                        <th><b>收藏时间</b></th>


                        <th>
                            操作
                        </th>

                    </tr>

                    </thead>
                    <tbody>


                    <tr v-for="(shoucang,index) in  listShoucang" :key="shoucang.id">
                        <td>
                            <input class="check" name="ids" type="checkbox" v-model="shoucang.rowSelected"/>


                        </td>


                        <td>
                            {{shoucang.targetname}}
                        </td>


                        <td>
                            <img width="80" height="80" :src="hostHead+shoucang.tupian"/>
                        </td>


                        <td>
                            {{shoucang.sctime}}
                        </td>


                        <td>
                            <div class="btn-group">

                                <a class="btn btn-success"
                                   :href="hostHead+shoucang.href"><i class="fa fa-book"></i>查看</a>
                            </div>
                        </td>
                    </tr>

                    <tr v-if="listShoucang.length==0">
                        <td colspan="20">
                            没有相关收藏信息
                        </td>
                    </tr>


                    </tbody>
                </table>
                <el-pagination
                        @size-change="pagesizeChange"
                        @current-change="pageindexChange"
                        :current-page="pageindex"
                        :page-sizes="[pagesize]"
                        :page-size="pagesize"
                        layout="total, sizes, prev, pager, next, jumper"
                        :total="total">
                </el-pagination>
                <div class="clear"></div>
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
        data() {
            return {


                "targetname": "",


                hostHead: "${pageContext.request.contextPath}",
                selectedAll: false,
                listShoucang: [],
                pageindex: 1, //初始页
                pagesize: 10,
                total: 10
            }

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
                let url = "admin/shoucang/list";
                let param = {
                    currentpageindex: this.pageindex,
                    pagesize: this.pagesize,
                    hyid: '${sessionScope.huiyuan.id}',
                    "targetname": this.targetname,


                };
                let util = new VueUtil(this);
                console.log("this.pageindex=" + this.pageindex);
                let res = await util.http.post(url, param);
                if (res.data != null) {
                    let pageInfo = res.data.data;
                    this.total = pageInfo.total;
                    this.listShoucang = pageInfo.list;
                    console.log(pageInfo);
                }
            },
            async deleteRec() {
                let url = "admin/shoucang/delete";
                let util = new VueUtil(this);
                let hasChecked = this.listShoucang.some(c => {
                    return c.rowSelected == true;
                });
                if (!hasChecked) {
                    util.alert('请选择需要删除的记录', '系统提示', {
                        confirmButtonText: '确定'
                    });
                    return;
                }

                let ids = this.listShoucang.filter(c => c.rowSelected).map(c => c.id);
                let res = util.confirm('是否要删除数据?', '系统提示', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning',
                }).then(() => {
                    util.http.post(url, {ids}, {emulateJSON: false}).then(res => {
                        if (res.data != null && res.data.stateCode > 0) {
                            this.search();
                        }
                    });
                }).catch(() => {
                });
            },
            selectedAllHandler() {
                console.log(this.selectedAll);
                if (this.listShoucang != null) {
                    this.listShoucang.forEach(c => {
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

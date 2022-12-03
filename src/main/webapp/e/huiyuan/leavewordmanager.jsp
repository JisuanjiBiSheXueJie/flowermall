<%@ page language="java" import="java.util.*" pageEncoding="UTF-8" %>

<%@ include file="law.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="daowen" uri="/daowenpager" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
    <title>留言信息</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/e/css/index.css" type="text/css"></link>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/e/css/box.all.css" type="text/css"></link>
    <link href="${pageContext.request.contextPath}/admin/css/web2table.css" rel="stylesheet" type="text/css"/>
    <script src="${pageContext.request.contextPath}/webui/jquery/jquery-1.12.4.min.js" type="text/javascript"></script>
    <link href="${pageContext.request.contextPath}/e/css/leaveword.css" rel="stylesheet" type="text/css"/>
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
            当前位置：<a href="${pageContext.request.contextPath}/e/index.jsp">首页</a>
            &gt;&gt; 我的留言
        </div>


        <div class="pcontent">
            <div>
                <div class="clear"></div>
                <div class="action-details">
                    <span @click="selectedAllHandler" class="btn btn-success"><i class="fa fa-check"></i>选择</span>
                    <span @click="deleteRc" class="btn btn-danger"><i class="fa fa-trash"></i>删除</span>
                </div>
                <div class="lw-ct-wrap">
                    <div class="hd">
                        <div class="title">全部留言</div>
                        <div class="subtitle">{{listLeaveword.length}}条</div>
                    </div>
                    <div class="bd">
                        <div v-for="lw in listLeaveword" class="lw-item">
                            <div class="img-area">
                                <img :src="'${pageContext.request.contextPath}'+lw.pbrphoto" class="image"/>
                                <span><input type="checkbox" name="id" :value="lw.id" v-model="lw.rowSelected"/> </span>
                            </div>
                            <div class="txt-area">
                                <div class="title">
                                    <div class="prop">{{lw.pbrname}}</div>
                                    <div class="prop">{{lw.pubtime}}</div>
                                </div>
                                <div class="data">
                                    {{lw.dcontent}}
                                </div>


                            </div>
                            <div v-if="lw.state==2" class="reply-area">
                                <div class="hd">
                                    <div class="prop">
                                        {{lw.rpname}}
                                    </div>
                                    <div class="prop">
                                        {{lw.replytime}}
                                    </div>
                                </div>
                                <div class="bd">

                                    <div class="img-area">
                                        <img :src="'${pageContext.request.contextPath}'+lw.rpphoto" class="image"/>
                                    </div>
                                    <div class="txt-area">
                                        {{lw.replycontent}}
                                    </div>

                                </div>
                            </div>
                        </div>
                    </div>
                    <div v-if="listLeaveword.length==0" class="no-record-tip">
                        <div class="content">没有留言记录</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<jsp:include page="bottom.jsp"></jsp:include>
</body>
</html>

<script type="text/javascript">
    Vue.http.options.root = "${pageContext.request.contextPath}";
    Vue.http.options.emulateJSON = true;
    let vm = new Vue({
        el: "#app",
        data: {
            listLeaveword: [],
            selectedAll: false,
            checkedIds: []
        },
        created() {
            this.getLeaveword()
        },
        methods: {
            async getLeaveword() {
                let url = "admin/leaveword/list";
                let {data: res} = await this.$http.post(url, {
                    hyid: '${sessionScope.huiyuan.id}'
                });
                if (res.stateCode < 0) {
                    this.$message.error(res.des);
                    return;
                }
                console.log(res.data);
                res.data.forEach(c => {
                    c.rowSelected = false;
                })
                this.listLeaveword = res.data;
            },

            async deleteRc() {
                let url = "admin/leaveword/delete";
                if (this.listLeaveword.length == 0) {
                    alert("删毛线,没有记录");
                    return;
                }
                let ids = this.listLeaveword.filter(c => c.rowSelected).map(c => c.id);
                if (ids.length <= 0) {
                    this.$message.error("删除毛线,先选择再删除");
                    return;
                }

                let {data: res} = await this.$http.post(url, {
                    ids
                });

                if (res != null && res.stateCode < 0) {
                    this.$message.error(res.des);
                    return;
                }
                this.getLeaveword();

            },
            selectedAllHandler() {
                this.selectedAll = !this.selectedAll;
                if (this.listLeaveword != null) {
                    this.listLeaveword.forEach(c => {
                        c.rowSelected = this.selectedAll;
                    });
                }
            },

        }
    });


</script>


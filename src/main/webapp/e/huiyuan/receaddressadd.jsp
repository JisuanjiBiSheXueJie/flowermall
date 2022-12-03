<%@ page language="java" import="java.util.*" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="web" uri="/WEB-INF/webcontrol.tld" %>
<%@ include file="law.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
    <title>收货地址</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/e/css/index.css" type="text/css"></link>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/e/css/box.all.css" type="text/css"></link>
    <script type="text/javascript" src="${pageContext.request.contextPath}/webui/jquery/jquery-1.12.4.min.js"></script>
    <script type="text/javascript"
            src="${pageContext.request.contextPath}/webui/jquery/jquery.validate.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/webui/jquery/jquery.validateex.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/webui/jquery/jquery.metadata.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/webui/jquery/messages_cn.js"></script>
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
            当前位置：<a href="${pageContext.request.contextPath}/e/index.jsp">首页</a> &gt;&gt; 收货地址
        </div>

        <div class="pcontent">

            <div class="title-section">
                <div class="strong"><i class="fa fa-plus"></i>新建收货地址</div>
                <div class="des">
                    <i class="fa fa-list"></i>
                    <a href="${pageContext.request.contextPath}/e/huiyuan/receaddressmanager.jsp">我的地址</a>
                </div>
            </div>

            <table class="grid" cellspacing="1" width="100%">



                <tr>
                    <td align="right">收货人:</td>
                    <td><input name="shr" v-model="receaddress.shr" placeholder="收货人"
                               validate="{required:true,messages:{required:'请输入收货人'}}"
                               class="input-txt"
                               type="text"/></td>

                    <td align="right">电话:</td>
                    <td><input name="mobile" v-model="receaddress.mobile" placeholder="电话"
                               class="input-txt" type="text"/></td>
                </tr>
                <tr>
                    <td align="right">邮编:</td>
                    <td><input name="postcode" placeholder="邮编"
                               validate="{required:true,zipCode:true,messages:{required:'请输入邮编',zipCode:'请输入正确的邮政编码'}}"
                               v-model="receaddress.postcode" class="input-txt" type="text"/></td>

                    <td align="right">地址:</td>
                    <td><input name="addinfo" placeholder="地址" v-model="receaddress.addinfo" class="input-txt"
                               type="text"/></td>
                </tr>

                <tr>
                    <td align="right">标题:</td>
                    <td colspan="3">
                        <input name="title" placeholder="标题" v-model="receaddress.title" class="input-txt" type="text"/>
                    </td>
                </tr>

                <tr>
                    <td colspan="4">

                        <button @click="submitHandler" class="btn btn-danger">
                            <i class="fa fa-check"></i>提交
                        </button>

                    </td>
                </tr>
            </table>

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
                actiontype: 'save',
                hostHead: '${pageContext.request.contextPath}',
                receaddress: {
                    shr: "",
                    mobile: "",
                    hyid:"${sessionScope.huiyuan.id}",
                    postcode: "",
                    addinfo: "",
                    title: ""
                },
            }
        },
        methods: {
            async load() {

                let id = "${param.id}"
                if (id != null) {
                    this.actiontype = "update";
                    this.pageTitle = "编辑收货地址";
                    let url = "admin/receaddress/load";
                    let {data: res} = await this.$http.post(url, {id: id});
                    console.log("res", res);
                    if (res != null && res.data != null)
                        this.receaddress = res.data;
                }
            },
            async submitHandler() {

                let defaultOptions = {
                    url: "admin/receaddress/save",
                    actionTip: "地址新增成功"
                };
                if (this.actiontype == "update") {
                    defaultOptions.url = "admin/receaddress/update";
                    defaultOptions.actionTip = "地址成功更新";
                }

                let params = {...this.receaddress};
                let {data: res} = await this.$http.post(defaultOptions.url, params);
                if (res.stateCode <= 0) {
                    this.$alert('提交异常', '系统提示', {
                        confirmButtonText: '确定'
                    });
                    return;
                }
                this.$message({
                    message: defaultOptions.actionTip,
                    type: 'success',
                    duration: 2000
                });
                window.location.href = this.hostHead + "/e/huiyuan/receaddressmanager.jsp";
            }
        },
        created() {
            this.load();
        }


    });
</script>
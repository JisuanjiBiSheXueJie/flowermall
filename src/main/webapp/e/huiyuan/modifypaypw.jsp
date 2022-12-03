<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>
    <%@ include file="law.jsp" %>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>密码修改</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/e/css/index.css" type="text/css"></link>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/e/css/box.all.css" type="text/css"></link>

    <script src="${pageContext.request.contextPath}/webui/jquery/jquery-1.12.4.min.js" type="text/javascript"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/webui/vue/vue.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/webui/vue/vue-resource-1.3.4.js"></script>
    <link href="${pageContext.request.contextPath}/webui/vue/elementui/theme-chalk/index.css" rel="stylesheet"/>
    <script src="${pageContext.request.contextPath}/webui/vue/elementui/index.js"></script>
    <link href="${pageContext.request.contextPath}/webui/vuecontrol/dwvuecontrol.css" rel="stylesheet"/>
    <script src="${pageContext.request.contextPath}/webui/vuecontrol/dwvuecontrol.umd.js"></script>
    <script src="${pageContext.request.contextPath}/webui/quill/quill.min.js"></script>
    <script src="${pageContext.request.contextPath}/webui/quill/vue-quill-editor.js"></script>
    <link href="${pageContext.request.contextPath}/webui/quill/quill.core.css" rel="stylesheet"/>
    <link href="${pageContext.request.contextPath}/webui/quill/quill.snow.css" rel="stylesheet"/>
    <link href="${pageContext.request.contextPath}/webui/quill/quill.bubble.css" rel="stylesheet"/>
    <script type="text/javascript" src="${pageContext.request.contextPath}/webui/vue/vueutil.js"></script>

    <link href="${pageContext.request.contextPath}/admin/css/web2table.css" rel="stylesheet" type="text/css"/>


</head>
<body>

<div id="app">
    <page-header></page-header>
    <div class="wrap round-block">

        <div class="line-title">
            当前位置：<a href="${pageContext.request.contextPath}/e/index.jsp">首页</a> &gt;&gt; 支付密码修改
        </div>


        <div class="pcontent">


            <table border="1" cellspacing="1" class="smart-table" cellpadding="0"
                   width="100%">
                <tr>
                    <td class="tlabel" align="right">原始密码 :</td>
                    <td align="left">
                        <input name="password" v-model="password" type="password"
                               v-validate="{required:true,messages:{required:'请输入原始支付密码'}}"
                               class="input-txt"/></td>

                </tr>
                <tr>
                    <td class="tlabel" align="right">修改密码 :</td>
                    <td align="left">
                        <input name="repassword1" v-model="repassword1" type="password"
                               v-validate="{required:true,messages:{required:'请输入新的密码'}}"
                               class="input-txt"/></td>

                </tr>
                <tr>
                    <td class="tlabel" align="right">确认密码 :</td>
                    <td align="left"><input name="repassword2" v-model="repassword2"
                                            v-validate="{required:true,messages:{required:'请再次输入密码'}}" type="password"
                                            class="input-txt"/></td>

                </tr>
                <tr>
                    <td colspan="2">
                        <el-button @click="submitHandler" type="primary" icon="el-icon-check">修改密码</el-button>

                    </td>
                </tr>

            </table>


        </div>
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
        data() {
            return {
                hostHead: "${pageContext.request.contextPath}",
                id: "${sessionScope.huiyuan.id}",
                password: "",
                repassword1: "",
                repassword2: ""
            }
        },
        methods: {
            async submitHandler() {
                let url = "admin/huiyuan/modifypaypw";
                if (this.password == "") {
                    this.$message.error("请输入原始密码");
                    return;
                }
                if (this.repassword1 == "") {
                    this.$message.error("请输入修改密码");
                    return;
                }
                if (this.repassword2 == "") {
                    this.$message.error("请输入确认密码");
                    return;
                }
                if (this.repassword1 != this.repassword2) {
                    this.$message.error("两次密码不一致");
                    return;
                }

                let {data: res} = await this.$http.post(url, {
                    id: this.id,
                    paypwd: this.password,
                    repassword1: this.repassword1
                });
                if (res != null && res.stateCode < 0) {
                    this.$message.error(res.des);
                    return;
                }
                this.$message.success("修改成功");
                window.location.href = this.hostHead + "/e/huiyuan/modifypwres.jsp";


            }
        }

    })

</script>

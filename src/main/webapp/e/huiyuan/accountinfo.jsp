<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>
    <%@ include file="law.jsp" %>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>会员登录</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/e/css/index.css" type="text/css"></link>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/e/css/box.all.css" type="text/css"></link>

    <script type="text/javascript" src="${pageContext.request.contextPath}/webui/vue/vue.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/webui/vue/vue-resource-1.3.4.js"></script>
    <link href="${pageContext.request.contextPath}/webui/vue/elementui/theme-chalk/index.css" rel="stylesheet"/>
    <script src="${pageContext.request.contextPath}/webui/vue/elementui/index.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/webui/vue/vueutil.js"></script>
    <link href="${pageContext.request.contextPath}/admin/css/web2table.css" rel="stylesheet" type="text/css"/>
</head>
<body>

<div id="app">
    <page-header ></page-header>

    <div class="wrap round-block">
        <div class="line-title">
            当前位置：<a href="${pageContext.request.contextPath}/e/index.jsp">首页</a> &gt;&gt; 会员中心
        </div>

        <div class="pcontent">

            <table cellpadding="0" cellspacing="1" border="1" class="smart-table" width="100%">
                <tr>
                    <td width="15%" align="right" class="tlabel">账号:</td>
                    <td width="35%">{{huiyuan.accountname}}({{huiyuan.nickname}})</td>
                    <td width="*" colspan="2" rowspan="5">

                        <img :src="hostHead+huiyuan.touxiang" width="200" height="200"/>

                    </td>
                </tr>
                <tr>
                    <td align="right" class="tlabel">身份证号:</td>
                    <td>{{huiyuan.idcardno}}</td>
                </tr>
                <tr>
                    <td align="right" class="tlabel">姓名:</td>
                    <td>{{huiyuan.name}}</td>
                </tr>

                <tr>
                    <td align="right" class="tlabel">性别:</td>
                    <td>{{huiyuan.sex}}</td>
                </tr>

                <tr>
                    <td align="right" class="tlabel">注册时间:</td>
                    <td>
                        {{huiyuan.regdate}}
                    </td>
                </tr>

                <tr>
                    <td align="right" class="tlabel">手机:</td>
                    <td>{{huiyuan.mobile}}</td>

                    <td width="15%" align="right" class="tlabel">邮箱:</td>
                    <td width="35%">{{huiyuan.email}}</td>
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
                "huiyuan": {},
            }
        },
        methods: {
            //begin load
            async load() {
                let id = "${sessionScope.huiyuan.id}"
                let util = new VueUtil(this);
                if (id != "") {
                    let url = "admin/huiyuan/load";
                    let {data: res} = await util.http.post(url, {id: id});
                    console.log("res", res);
                    if (res != null && res.data != null)
                        this.huiyuan = res.data;
                }
            },//end load

        },
        created() {
            this.load();
        }

    });

</script>


<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/e/css/index.css" type="text/css"></link>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/e/css/box.all.css" type="text/css"></link>
    <script type='text/javascript' src='${pageContext.request.contextPath}/webui/vue/vue.js'></script>
    <script type='text/javascript' src='${pageContext.request.contextPath}/webui/vue/vue-resource-1.3.4.js'></script>
    <link href="${pageContext.request.contextPath}/webui/vue/elementui/theme-chalk/index.css" rel="stylesheet"/>
    <script src="${pageContext.request.contextPath}/webui/vue/elementui/index.js"></script>
</head>
<body>


<div class="wrap round-block">
    <div class="line-title">
        当前位置：<a href="${pageContext.request.contextPath}/e/index.jsp">首页</a> &gt;&gt; 系统提示
    </div>

    <div class="no-record-tip">
        <div class="content">
            <i class="fa fa-check"></i> 充值成功  <a href="${pageContext.request.contextPath}/e/huiyuan/yue.jsp">我的余额</a>
        </div>
    </div>

</div>


<div class="fn-clear"></div>

</body>
</html>

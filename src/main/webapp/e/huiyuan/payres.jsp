<%@page import="com.daowen.util.*" %>
<%@page import="com.daowen.entity.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>系统注册</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/e/css/index.css" type="text/css"></link>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/e/css/box.all.css" type="text/css"></link>


    <script
            src="${pageContext.request.contextPath}/webui/jquery/jquery-1.12.4.min.js"
            type="text/javascript"></script>


</head>
<body>

<div class="wrap round-block">
    <div class="line-title">
        当前位置：<a href="${pageContext.request.contextPath}/e/index.jsp">首页</a> &gt;&gt; 支付结果
    </div>
    <div class="main">
        <jsp:include page="menu.jsp"></jsp:include>
        <div class="main-content">
            <div class="result-guide-box">
                <div class="content clearfix">
                    <div class="icon-area">
                        <i class="fa fa-check-circle"></i>
                    </div>
                    <div class="text-area">
                        <strong>支付成功！</strong>

                    </div>
                </div>
            </div>

        </div>
    </div>
</div>


</body>
</html>
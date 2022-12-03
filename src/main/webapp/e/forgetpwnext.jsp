<%@ page import="com.daowen.service.HuiyuanService" %>
<%@ page import="com.daowen.entity.Huiyuan" %>
<%@ page import="com.daowen.util.BeansUtil" %>
<%@ taglib prefix="web" uri="/WEB-INF/webcontrol.tld"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ include file="import.jsp" %>
<%
	String id=request.getParameter("id");
	if(id!=null){
		HuiyuanService huiyuanSrv= BeansUtil.getBean("huiyuanService",HuiyuanService.class);
		Huiyuan huiyuan=huiyuanSrv.load("where id="+id);
		if(huiyuan!=null)
			request.setAttribute("fhuiyuan",huiyuan);
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>忘记密码</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/e/css/index.css" type="text/css"></link>

<link rel="stylesheet" href="${pageContext.request.contextPath}/e/css/forgetpw.css" type="text/css"></link>

<link rel="stylesheet" href="${pageContext.request.contextPath}/e/css/box.all.css" type="text/css"></link>

<script src="${pageContext.request.contextPath}/webui/jquery/jquery-1.12.4.min.js" type="text/javascript"></script>

<script  type="text/javascript" src="${pageContext.request.contextPath}/webui/jquery/jquery.validate.min.js"></script>
 <script type="text/javascript"  src="${pageContext.request.contextPath}/webui/jquery/jquery.metadata.js" ></script>
 <script type="text/javascript"  src="${pageContext.request.contextPath}/webui/jquery/messages_cn.js" ></script>
 <link href="${pageContext.request.contextPath}/webui/easydropdown/themes/easydropdown.css" rel="stylesheet" type="text/css" />
 <script src="${pageContext.request.contextPath}/webui/easydropdown/jquery.easydropdown.js" type="text/javascript"></script>    
<script type="text/javascript">
		 $(function (){
			 $("#btnOK").click(function () {

				 $(this).prop("disabled","disabled");
				 $.ajax({
					 url:'${pageContext.request.contextPath}/admin/huiyuan/sendpwemail',
					 method:'post',
					 data:{
						 "id":"${requestScope.fhuiyuan.id}"
					 },
					 success:function(data){
						 if(data.stateCode<0){
							 alert(data.des);
							 return;
						 }
						 alert("已发送充值密码邮件,请注意查收");
					 },
					 error:function(xmhttprequest,status,excetpion){
						 alert("系统错误，错误编码"+status);
					 }
				 });

			 });

		 });  
 </script>
</head>

<body>


	<div class="wrap round-block">
		<div class="line-title">
			当前位置：<a href="${pageContext.request.contextPath}/e/index.jsp">首页</a> &gt;&gt; 忘记密码
		</div>
		
		<c:if test="${requestScope.fhuiyuan.email==null}">
		   
		       <div class="reg-box">
                <div class="reg-title">
                 
                </div>
                <div style="min-height:600px;" class="msg-tip">
                    <div class="ico error">
                    </div>
                    <div class="text">
                        <strong>你没有设置密码邮箱！</strong>

                    </div>
                </div>
                <div class="clear">
                </div>
            </div>
		    
		   
		</c:if>
		
	  <c:if test="${requestScope.fhuiyuan.email!=null}">
		
		<div class="whitebox">

			<h1>忘记密码</h1>

			<div class="reg-box">
               

				<div class="reg-content">
					
					<dl>
					   <dt>账号:</dt>
					   <dd>${requestScope.fhuiyuan.accountname}
					       <input type="hidden" name="accountname" value="${requestScope.fhuiyuan.accountname}"/>
					   </dd>
					</dl>
					<dl>
					<dt>邮箱:</dt>
					<dd>
                          ${requestScope.fhuiyuan.email}
					</dd>

				</dl>


				
					<dl>
						<dt></dt>
						<dd>
							<button id="btnOK" class="dw-btn" >
								<i class="icon-ok icon-white"></i>发送重置密码邮件
							</button>
						</dd>

					</dl>

                
				</div>


			</div>


		</div>
		</c:if>

	</div>

	<div class="fn-clear"></div>


	<jsp:include page="bottom.jsp"></jsp:include>



</body>
</html>
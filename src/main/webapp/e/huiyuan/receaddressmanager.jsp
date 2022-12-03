<%@page import="com.daowen.entity.*"%>
 <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>
<%@ include file="law.jsp"%>


<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>收货地址管理</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/e/css/index.css" type="text/css"></link>
<link rel="stylesheet" href="${pageContext.request.contextPath}/e/css/box.all.css" type="text/css"></link>
<script src="${pageContext.request.contextPath}/webui/jquery/jquery-1.12.4.min.js" type="text/javascript"></script>
	<script type='text/javascript' src='${pageContext.request.contextPath}/webui/vue/vue.js'></script>
	<script type='text/javascript' src='${pageContext.request.contextPath}/webui/vue/vue-resource-1.3.4.js'></script>
	<link href="${pageContext.request.contextPath}/webui/vue/elementui/theme-chalk/index.css" rel="stylesheet"/>
	<script src="${pageContext.request.contextPath}/webui/vue/elementui/index.js"></script>
</head>
<body>

<div id="app">
	<page-header></page-header>
	<div  class="wrap round-block">
		<div class="line-title">
			当前位置：<a href="${pageContext.request.contextPath}/e/index.jsp">首页</a> &gt;&gt; 收货地址
		</div>
	
		

		       <div  class="pcontent">
				   <div class="title-section">
					   <div class="strong">收货地址</div>
					   <div class="des">
						   <i class="fa fa-plus"></i>
						   <a href="${pageContext.request.contextPath}/e/huiyuan/receaddressadd.jsp?seedid=104">添加地址</a>
					   </div>
				   </div>
				   <div class="address-list clearfix">

					   <ul v-for="address in listReceaddress" :key="address.id" class="address-info">
						   <div class="add-title">
							   <a  :href="hostHead+'/e/huiyuan/receaddressadd.jsp?seedid=104&id='+address.id" class="edit">
								   <i class="fa fa-edit"></i>
							   </a>
							   {{address.title }}
							   <span @click="deleteOne(address.id)"  class="remove">
				           <i class="fa fa-close"></i>
                      </span>
						   </div><!-- end title -->

						   <li>{{address.shr}}</li>
						   <li>{{address.addinfo }}</li>
						   <li>{{address.mobile }}</li>
						   <li>{{address.postcode}}</li>
					   </ul>


					   <div v-if="listReceaddress!=null&&listReceaddress.length==0" class="no-record-tip">
						   <div class="content">

							   <i class="fa fa-warning"></i>暂无收货地址
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
	Vue.http.options.root = '${pageContext.request.contextPath}';

	Vue.http.options.emulateJSON = true;
	Vue.http.options.xhr = {withCredentials: true};
	let vm=new Vue({
		el:'#app',
		name: 'receaddressmanager',
		data(){
			return {
				listReceaddress:[],
				hostHead:'${pageContext.request.contextPath}',
				hyid:'${sessionScope.huiyuan.id}'
			}
		},
		methods:{
			async list(){
				let url="admin/receaddress/list";
				let {data:res}=await this.$http.post(url,{hyid:this.hyid,paged:-1});
				if(res!=null&&res.stateCode<0){
					this.$message.error(res.des);
					return;
				}

				this.listReceaddress=res.data;
				this.addrid=this.listReceaddress[0].id;
			},
			async deleteOne(id){
				let ids=[];
				ids.push(id);
				let url="admin/receaddress/delete";
				let confirm= await this.$confirm('是否要删除信息?', '系统提示', {
					confirmButtonText: '确定',
					cancelButtonText: '取消',
					type: 'warning',
				});

				let {data:res}=await this.$http.post(url, {ids});
				if (res.stateCode > 0) {
					this.$message({
						message:"删除成功",
						type:'success',
						duration:3000
					});
					this.list();
				}
			}
		},
		created () {
			this.list();

		}
	})


</script>
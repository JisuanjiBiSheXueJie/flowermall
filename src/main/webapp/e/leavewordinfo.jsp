

<%@  include file="import.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>


<head>
	<title>系统首页</title>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/e/css/index.css" type="text/css"></link>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/e/css/box.all.css" type="text/css"></link>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/e/css/leaveword.css" type="text/css"></link>
	<script type="text/javascript"  src="${pageContext.request.contextPath}/webui/vue/vue.js" ></script>
	<script type="text/javascript"  src="${pageContext.request.contextPath}/webui/vue/vue-resource-1.3.4.js" ></script>
	<link href="${pageContext.request.contextPath}/webui/vue/elementui/theme-chalk/index.css" rel="stylesheet"/>
	<script src="${pageContext.request.contextPath}/webui/vue/elementui/index.js"></script>
</head>
<body>

<div id="app">
	<page-header  headid="${param.headid}"></page-header>

	<div class="wrap com-panel" >
		<div class="stdrow">
			<img style="width: 1200px;" src="${pageContext.request.contextPath}/e/images/liuyan.jpg"/>
		</div>
         <div v-if="hyid!=''">
			<div class="stdrow">
					<textarea  name="dcontent"  maxlength="500" class="lwta" v-model="dcontent"   placeholder="在线留言" ></textarea>
			</div>
            <div class="stdrow">
				<span @click="submitLw" class="lw-btn">在线留言</span>
			</div>
		 </div>


			<div v-else style="font-size:18px;padding:20px 120px;">
				登录后才能进行留言  ,<a style="color:#e9ab32;" href="${pageContext.request.contextPath}/e/login.jsp">登录</a>
			</div>

	</div>
	<div class="wrap com-panel" style="min-height: 600px;background-color:#fff;">
         <div class="lw-ct-wrap">
			 <div class="hd">
				 <div class="title">全部留言</div>
				 <div class="subtitle">{{listLeaveword.length}}条</div>
			 </div>
			 <div class="bd">
				 <div v-for="lw in listLeaveword" class="lw-item">
                     <div class="img-area">
						 <img  :src="'${pageContext.request.contextPath}'+lw.pbrphoto" class="image"/>
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
		 </div>
	</div>

</div>
<div class="fn-clear"></div>


<jsp:include page="bottom.jsp"></jsp:include>



</body>
</html>

<script type="text/javascript">
	Vue.http.options.root = "${pageContext.request.contextPath}";
	Vue.http.options.emulateJSON = true;
	let vm=new Vue({
         el:"#app",
		 data:{
			 listLeaveword:[],
			 dcontent:"",
			 hyid:"${sessionScope.huiyuan.id}"
		 },
		 created(){
         	this.getLeaveword()
		 },
		 methods:{
			 async getLeaveword(){
				 let url = "admin/leaveword/list";
				 let res=await this.$http.post(url);
				 console.log(res.data);
				 this.listLeaveword=res.data.data;
			 },
			 async submitLw(){
			 	if(this.hyid=="") {
					alert("登录后在留言");
			 		window.location.href="${pageContext.request.contextPath}/e/login.jsp";
					return;
				}
			 	let url="admin/leaveword/save";
                let res=await  this.$http.post(url,{
                	dcontent:this.dcontent,
					hyid:this.hyid
				});
                if(res.data.stateCode>0){
                	this.dcontent="";
                	this.getLeaveword();
				}

			 }
		 }
	});



</script>
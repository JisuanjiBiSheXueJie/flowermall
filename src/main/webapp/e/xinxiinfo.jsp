
<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>
<%@ include file="import.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>系统首页</title>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/e/css/index.css" type="text/css"></link>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/e/css/leaveword.css" type="text/css"></link>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/e/css/box.all.css" type="text/css"></link>
	<script src="${pageContext.request.contextPath}/webui/jquery/jquery-1.12.4.min.js" type="text/javascript"></script>
	<script type='text/javascript' src='${pageContext.request.contextPath}/webui/vue/vue.js'></script>
	<script type='text/javascript' src='${pageContext.request.contextPath}/webui/vue/vue-resource-1.3.4.js'></script>
	<link href="${pageContext.request.contextPath}/webui/vue/elementui/theme-chalk/index.css" rel="stylesheet"/>
	<script src="${pageContext.request.contextPath}/webui/vue/elementui/index.js"></script>
	<script src="${pageContext.request.contextPath}/webui/quill/quill.min.js"></script>
	<script src="${pageContext.request.contextPath}/webui/quill/vue-quill-editor.js"></script>
	<link href="${pageContext.request.contextPath}/webui/quill/quill.core.css" rel="stylesheet"/>
	<link href="${pageContext.request.contextPath}/webui/quill/quill.snow.css" rel="stylesheet"/>
	<link href="${pageContext.request.contextPath}/webui/quill/quill.bubble.css" rel="stylesheet"/>


</head>
<body>

<div id="app">
	<page-header  headid="${param.headid}"></page-header>

     <div  class="wrap  round-block">

	<div class="two-split">
		<div style="overflow: hidden" class="split-left white-paper">
			<div class="show-details">
				<div class="picture-box">
					<img v-if="xinxi.images!=null" :src="hostHead+xinxi.images[0]" />
					<div class="operation">
						<span  @click="shoucangHandler"  class="btn btn-default "><i class="fa fa-plus"></i>关注</span>
					</div>
				</div>
				<div class="text-box">
					<div class="title">{{xinxi.title}}</div>
					<div class="sub-title"></div>
					<div>
						<ul>


							<li><strong>发布时间:</strong>{{xinxi.pubtime}}</li>
							<li><strong>点击次数:</strong> {{xinxi.clickcount}}
							</li>
							<li><strong>所属分类:</strong> {{xinxi.lmname}}</li>



							<li>
							       <span @click="agreeHandler"   class="btn btn-default "><i  class="fa fa-thumbs-up"></i><span name="count">{{xinxi.agreecount}}</span></span>

								 <span @click="againstHandler" class="btn btn-default "><i class="fa fa-thumbs-down"></i><span name="count">{{xinxi.againstcount}}</span></span>
							</li>
						</ul>
					</div>

				</div>
			</div>


			<div >

				<div v-if="listXinxi.length>0" class="video-list">
					<div class="hd">
						猜你喜欢
					</div>
					<div class="bd">

						<div v-for="item in listXinxi" class="item">
							<div class="card">
								<a :href="hostHead+'/e/xinxiinfo.jsp?id='+item.id">
									<div class="pic">
										<img class="image" :src="hostHead+item.images[0]"/>

									</div>
									<div class="name">
										{{item.title}}
									</div>
									<div class="price">{{item.lmname}}</div>
								</a>
							</div>
						</div>

					</div>
				</div>


			</div>



			<div v-html="xinxi.dcontent" class="brief-content">

			</div>



			<!--评论区域-->
			<comment :belongid="this.id" xtype="xinxi"></comment>
			<login-dlg :show.sync="openLogin"></login-dlg>




		</div>
		<div style="width:260px;" class="split-right">
			<div class="vm-sidebar">
				<div class="hd">热门信息</div>
				<div class="bd">

					<div v-for="xinxi in listHotXinxi" :key="xinxi.id" class="item">
						<a :href="'/e/xinxiinfo?id='+xinxi.id">
							<div class="image-wrap">
								<img :src="hostHead+xinxi.images[0]"/>
							</div>
							<div class="tag">{{xinxi.lmname}}</div>
							<div class="text-wrap">
								<div class="name">{{xinxi.title}}</div>
								<div class="muted">{{xinxi.pubtime}}</div>
								<div class="bm-wrap">{{xinxi.clickcount}}人点击</div>
							</div>
						</a>
					</div>
				</div>
			</div>
		</div>
	</div>

</div>

</div>
<jsp:include page="bottom.jsp"></jsp:include>

<jsp:include page="commentvue.jsp"></jsp:include>



</body>
</html>
<script type="text/javascript">


	Vue.http.options.root = '${pageContext.request.contextPath}';
	Vue.http.options.emulateJSON = true;
	Vue.http.options.xhr = {withCredentials: true};
	Vue.use(window.VueQuillEditor);
	  let vm=new Vue({
		  el:"#app",
		  name: 'xinxiinfo',
		  data(){
			  return {
				  hostHead:'${pageContext.request.contextPath}',
				  listHotXinxi:[],
				  listXinxi:[],
				  id:0,
				  openLogin:false,
				  hyid:"${sessionScope.huiyuan.id}",
				  xinxi:{},
				  swiperOptions: {
					  pagination: {
						  el: '.swiper-pagination',    //与slot="pagination"处 class 一致
						  clickable: true            //轮播按钮支持点击
					  },
					  navigation: { // 左右箭头
						  nextEl:'.swiper-button-next',
						  prevEl:'.swiper-button-prev'
					  },
					  loop: true,		// 循环回路
					  slidesPerView: "auto",	// 设置slider容器能够同时显示的slides数量; 设置为auto则自动根据slides的宽度来设定数量
					  centeredSlides: true,	// 设定为true时，active slide会居中，而不是默认状态下的居左
					  spaceBetween: 30

				  },

			  }
		  },
		  methods:{
			  async getHotXinxis(){
				  let { data:res }=await this.$http.post("admin/xinxi/hot");
				  if(res!=null&&res.stateCode>0) {
					  this.listHotXinxi = res.data;
					  console.log(this.listHotXinxi);
				  }
			  },
			  async getInfo(){
				  this.id=${param.id};
				  let {data:res}=await this.$http.post("admin/xinxi/info",{id:this.id});
				  if(res!=null&&res.stateCode>0) {
					  this.xinxi = res.data;
					  console.log(this.xinxi);

				  }
			  },
			  async shoucangHandler(){
				  if(this.hyid=="") {
					  this.openLogin = true;
					  return;
				  }
				  let url="admin/shoucang/save";


				  let {data:res}=await this.$http.post(url,{
					  targetid:this.xinxi.id,
					  targetname:this.xinxi.title,
					  tupian:this.xinxi.images[0],
					  hyid:this.id==null?0:this.hyid,
					  xtype:"xinxi",
					  href:"/e/xinxiinfo.jsp?id="+this.xinxi.id
				  });
				  if(res!=null&&res.stateCode<0){
					  this.$message.error(res.des);
					  return;
				  }
				  this.$message.success("收藏成功");
			  },
			  async downloadHandler(url){
				  if(this.hyid=="") {
					  this.openLogin = true;
					  return;
				  }
				  window.location.href=this.hostHead+"/admin/download?url="+this.xinxi.fileurl;
			  },
			  async agreeHandler(){
				  if(this.hyid=="") {
					  this.openLogin = true;
					  return;
				  }
				  let url="admin/xinxi/agree";
				  let commentator="${sessionScope.huiyuan.accountname}";
				  let {data:res}=await this.$http.post(url,{
					  "targetid":this.xinxi.id,
					  commentator
				  });
				  if (res!=null&&res.stateCode<0){
					  this.$message.error(res.des);
					  return ;
				  }
				  this.getInfo();
				  this.$message.success("成功");
			  },
			  async againstHandler() {


				  if(this.hyid=="") {
					  this.openLogin = true;
					  return;
				  }
				  let url="admin/xinxi/against";
				  let commentator="${sessionScope.huiyuan.accountname}";
				  let {data:res}=await this.$http.post(url,{
					  "targetid":this.xinxi.id,
					  commentator
				  });
				  if (res!=null&&res.stateCode<0){
					  this.$message.error(res.des);
					  return ;
				  }
				  this.getInfo();
				  this.$message.success("成功");



			  },
			  getRecomment(){
				  let url="admin/xinxi/recomment";
				  this.$http.post(url).then(res=>{
					  console.log(res.data);
					  if(res.data!=null&&res.data.data!=null)
						  this.listXinxi=res.data.data;
				  });

			  }


		  },
		  created () {
              this.id="${param.id}";
			  this.getHotXinxis();
			  this.getInfo();
			  this.getRecomment();
		  },

	  });
</script>
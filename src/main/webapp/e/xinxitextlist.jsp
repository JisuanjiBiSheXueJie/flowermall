
<%@  include file="import.jsp"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>信息列表</title>
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
	<page-header  headid="${param.headid}"></page-header>
    <div  class="wrap" style="min-height: 600px;" >

    <div class="grid-list">
		<div class="gl-left">
			<dl>
				<dt>{{lanmu.name}}</dt>
				<dd v-if="lanmu.subtypes!=null" @click="getXinxi(lanmuid,subtype.id)" v-for="subtype in lanmu.subtypes">{{subtype.name}}</dd>

			</dl>
		</div>
		 <div class="gl-right">

			 <ul v-if="listXinxi.length>0">
				 <li v-for="xinxi in listXinxi">
					 <div class="tit"><a :href="hostHead+'/e/xinxiinfo.jsp?id='+xinxi.id">{{xinxi.title}}</a></div>
					 <div class="time">{{xinxi.pubtime}}</div>
				 </li>
			 </ul>
			 <div v-else class="no-record-tip">
				 <div class="content">
					 <i class="fa fa-warning"></i>暂无相关信息
				 </div>
			 </div>
		 </div>

	</div>
	<div class="clear"></div>
	<el-pagination
			@size-change="pagesizeChange"
			@current-change="pageindexChange"
			:current-page="pageindex"
			:page-sizes="[pagesize]"
			:page-size="pagesize"
			layout="total, sizes, prev, pager, next, jumper"
			:total="total">
	</el-pagination>

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
		data: {

			hostHead: '${pageContext.request.contextPath}',
			listXinxi:[],
			pageindex:1,
			lanmuid:"${param.lanmuid}",
			lanmu:{},
			pagesize:10,
			total:10,
			name:""

		},
		async created() {
			console.log("created");

			this.getXinxi(this.lanmuid);
			this.getLanmu();

		},
		async mounted() {


		},
		methods: {
			pagesizeChange: function (pagesize) {
				this.pagesize = pagesize;
			},
			pageindexChange: function(pageindex){
				this.pageindex = pageindex;
				console.log(this.pageindex);
				this.getXinxi();
			},
			getXinxi(lmid,subtypeid) {
				let param={
					currentpageindex:this.pageindex,
					pagesize:this.pagesize
				};
				if(lmid!="")
					param.lmid=lmid;
				if(subtypeid!=null)
					param.subtypeid=subtypeid;

				let url = "admin/xinxi/pagelist";
				this.$http.post(url,param).then(res => {
					console.log(res.data);
					if(res.data!=null&&res.data.data!=null) {
						let pageInfo=res.data.data;
						this.total=pageInfo.total;
						this.listXinxi = pageInfo.list;
					}
				});
			},

			getLanmu(){
				let url = "admin/lanmu/info";
				this.$http.post(url,{
					id:this.lanmuid
				}).then(res => {
					console.log(res.data);
					if(res.data!=null&&res.data.data!=null) {
						this.lanmu =res.data.data;
					}
				});
			}

		}

	});

</script>
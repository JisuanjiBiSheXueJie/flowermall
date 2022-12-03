
<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8" %>

<html>

<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>在线搜索</title>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/e/css/box.all.css" type="text/css"></link>
	<script type='text/javascript' src='${pageContext.request.contextPath}/webui/vue/vue.js'></script>
	<script type='text/javascript' src='${pageContext.request.contextPath}/webui/vue/vue-resource-1.3.4.js'></script>
	<link href="${pageContext.request.contextPath}/webui/vue/elementui/theme-chalk/index.css" rel="stylesheet"/>
	<script src="${pageContext.request.contextPath}/webui/vue/elementui/index.js"></script>

	<style>

		.search-panel {
			width: 670px;
			margin: 100px auto 0;

		}

		.search-panel .bd {

			background-color: #eeeeee;
			padding: 50px 30px;
			margin: 80px 0;
			position: relative;
			-moz-border-radius: 16px;
			-webkit-border-radius: 16px;
			border-radius: 16px;
			display: flex;
		}
		.search-panel .bd .item{
			width: 52px;
			height: 40px;
			line-height: 40px;
			padding-left: 10px;

		}

		.red {
			color: red;
		}

	</style>

</head>
<body>

<div id="app">
	<div class="search-panel">
		<div class="bd">

			<el-input style="width:320px;" placeholder="请输入内容" @keyup.enter.native="searchHandler" v-model="title"  class="input-with-select">
				<el-button slot="append" type="primary" @click="searchHandler" icon="el-icon-search"></el-button>
			</el-input>

			<div class="item">
				<a href="${pageContext.request.contextPath}/e/index.jsp">首页</a>

			</div>


		</div>

	</div>


	<div v-if="listSearch!=null&&listSearch.length>0" class="wrap round-block">

		<div class="video-list">

			<div class="bd">

				<div v-for="si in listSearch" class="item">
					<div class="card">
						<a :href="hostHead+si.href">
							<div class="pic">
								<img class="image" :src="hostHead+si.tupian"/>

								<span v-if="si.xtype==3" class="play-trigger"></span>


							</div>
							<div class="name">
								{{si.name}}
							</div>

						</a>
					</div>
				</div>

			</div>
		</div>

	</div>


	<div v-if="search&&listSearch!=null&&listSearch.length<=0" class="no-record-tip">
		<div class="content"><i class="fa fa-warning"></i>暂无相关<span class="red">{{title}}</span>信息</div>
	</div>
</div>

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
				listSearch: [],
				title: "",
				search:false
			}
		},
		methods: {

			async searchHandler(){
				if (this.title==""){
					this.$message.error("请输入关键词");
					return ;
				}
				this.search =true;

				let {data:res}=await this.$http.post("admin/search",{title:this.title});
				if (this.stateCode<0){
					this.$message.error("失败");
					return ;
				}
				this.listSearch=res.data;

			}

		},
		created() {

		}


	});


</script>
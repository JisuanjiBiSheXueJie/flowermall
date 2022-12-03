<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<%@ include file="law.jsp"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<title>订单信息查看</title>
	<link rel="stylesheet"  href="${pageContext.request.contextPath}/e/css/index.css" type="text/css"></link>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/e/css/box.all.css" type="text/css"></link>
	<link href="${pageContext.request.contextPath}/admin/css/web2table.css" rel="stylesheet" type="text/css" />
	<script type="text/javascript" src="${pageContext.request.contextPath}/webui/jquery/jquery-1.12.4.min.js"></script>
	<link href="${pageContext.request.contextPath}/admin/css/web2table.css" rel="stylesheet" type="text/css"/>
	<script type='text/javascript' src='${pageContext.request.contextPath}/webui/vue/vue.js'></script>
	<script type='text/javascript' src='${pageContext.request.contextPath}/webui/vue/vue-resource-1.3.4.js'></script>
	<link href="${pageContext.request.contextPath}/webui/vue/elementui/theme-chalk/index.css" rel="stylesheet"/>
	<script src="${pageContext.request.contextPath}/webui/vue/elementui/index.js"></script>


</head>
<body >
<div id="app">
	<page-header></page-header>
<div class="wrap round-block">
	<div class="line-title">
		当前位置：<a href="${pageContext.request.contextPath}/e/index.jsp">首页</a> &gt;&gt; 查看订单信息
	</div>


		<div class="pcontent">

			<div >
				<div class="search-title">
					<h2>
						订单详情
					</h2>
					<div class="description">
					</div>
				</div>
				<div style="margin:22px 30px; ">
					<el-steps :space="200" :active="3" finish-status="success">
						<el-step title="下单"></el-step>
						<el-step title="付款"></el-step>
						<el-step title="发货"></el-step>
						<el-step title="收货评价"></el-step>
					</el-steps>
				</div>
				<div class="shaddr-wrap">
					<div class="logo"><i class="fa fa-location-arrow"></i></div>
					<div v-if="huiyuan!=null" class="bd">

						<div class="contact">
							{{huiyuan.receaddresses[0].mobile}}
							{{huiyuan.name}}
						</div>
						<div class="addinfo">{{huiyuan.receaddresses[0].addinfo}}
							<span>{{huiyuan.receaddresses[0].postcode}}</span>
						</div>

					</div>

				</div>
				<table border="1" class="smart-table">
					<tr>
						<td class="tlabel">订单编号</td>
						<td>{{order.ddno}}</td>
						<td class="tlabel">下单时间:</td>
						<td>
							{{order.createtime}}

						</td>
					</tr>
				</table>
				<table   width="100%" border="0" cellspacing="0" cellpadding="0" class="ui-record-table">


					<thead>

					<tr>
						<th>名称</th>
						<th>价格</th>
						<th>数量</th>
						<th>状态</th>
					</tr>
					</thead>
					<tbody>

					<tr v-for="od in order.orderDetail">
						<td><img width="80" height="80" :src="hostHead+od.images[0]"/>
							{{od.spname}}</td>
						<td>{{od.price}}元</td>
						<td>{{od.count}}</td>
						<td>
							<span v-if="od.state==1">待付款</span>
							<span v-if="od.state==2">已付款</span>
							<span v-if="od.state==3">
                    物流号:{{od.wlno}}
                </span>
							<span v-if="od.state==4">已完成</span>


						</td>
					</tr>


					</tbody>
				</table>



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
		el:"#app",

		data:{
			id:"${param.id}",
			oiid:'${param.oiid}',
			wlno:'',
			wltype:'顺丰',
			hostHead:'${pageContext.request.contextPath}',
			order:{},
			huiyuan:null
		},
		methods:{

			async getOrderInfo(){
				let {data:res}= await this.$http.post("admin/shorder/info",{id:this.id});
				if (res.stateCode<0){
					this.$message.error(res.des);
					return ;
				}
				console.log("订单数据",res);
				this.order=res.data;

			},
			async getHuiyuanInfo(){

				let {data:res}=await this.$http.post("admin/huiyuan/info",{id:this.order.purchaser});

				if (res.stateCode<0){
					this.$message.error(res.des);
					return ;
				}
				this.huiyuan=res.data;
				console.log("huiyuan",this.huiyuan);
			}

		},
		async created(){
			await this.getOrderInfo();
			await this.getHuiyuanInfo();
		}

	});

</script>

<!DOCTYPE html>
<%@ include file="import.jsp" %>

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>系统首页</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/e/css/index.css" type="text/css"></link>

<link rel="stylesheet" href="${pageContext.request.contextPath}/e/css/box.all.css" type="text/css"></link>

	<script type='text/javascript' src='${pageContext.request.contextPath}/e/js/SmartStorage.js'></script>
	<script src="${pageContext.request.contextPath}/webui/jquery/jquery-1.12.4.min.js" type="text/javascript"></script>
	<script type='text/javascript' src='${pageContext.request.contextPath}/webui/vue/vue.js'></script>
	<script type='text/javascript' src='${pageContext.request.contextPath}/webui/vue/vue-resource-1.3.4.js'></script>
	<link href="${pageContext.request.contextPath}/webui/vue/elementui/theme-chalk/index.css" rel="stylesheet"/>
	<script src="${pageContext.request.contextPath}/webui/vue/elementui/index.js"></script>

</head>
<body>


	<div id="app">

		<page-header headid="${param.headid}"></page-header>
		<div class="wrap round-block">
			<el-steps :space="200" :active="1" finish-status="success">
				<el-step title="加入购物车"></el-step>
				<el-step title="填写收货地址"></el-step>
				<el-step title="付款"></el-step>
			</el-steps>
			<div v-if="cartItems.length>0" class="shopcart-box">
				<div class="hd">购物车</div>
				<div class="bd">
					<table class="table table-striped table-hover table-bordered">
						<thead>
						<tr>
							<th>全选</th>
							<th>商品</th>
							<th>数量</th>
							<th>单价(元)</th>
							<th>金额(元)</th>
							<th>操作</th>
						</tr>
						</thead>
						<tbody>
						<tr v-for="item in cartItems" :key="item.id">
							<td>
								<el-checkbox  v-model="item.value.selected"></el-checkbox>
								<a :href="hostHead+'/e/shangpininfo.jsp?id='+item.id">
									<img width="120" height="120" :src="hostHead+item.value.tupian"/>
								</a>

							</td>
							<td>{{item.value.name}}</td>
							<td>
								<el-input-number v-model="item.value.count" @change="countChange(item.value)"  :min="1" :max="10" label="描述文字"></el-input-number>
							</td>
							<td>{{ item.value.price }}¥</td>
							<td>{{ item.value.count*item.value.price }}¥</td>
							<td><span class="btn btn-danger" @click="removeHandler(item.id)"><i class="fa fa-trash"></i>删除</span></td>
						</tr>
						</tbody>

					</table>

					<div class="cart-tool">
						<el-checkbox @change="selectedAllHandler" v-model="selectedAll">全选</el-checkbox>
						<div class="pull-right">
							已选 商品 <span>{{selectedCount}}</span> 件
							合计{{totalPrice}}¥
							<el-button-group>
							   <el-button @click="doOrderHandler" type="danger" icon="el-icon-check">提交订单</el-button>
							   <a  class="el-button el-button--success"  href="${pageContext.request.contextPath}/e/index.jsp"><i class="fa fa-arrow-circle-o-left"></i>继续购物</a>
							</el-button-group>
						</div>
					</div>
				</div>
			</div>
            <div v-else class="no-record-tip">

				<div class="content">

					<i style="color:red;font-size: 72px;" class="fa fa-shopping-cart"></i>

					<a href="${pageContext.request.contextPath}/e/index.jsp">继续逛逛</a>

				</div>

			</div>

		</div>


		<login-dlg :show.sync="openLogin"></login-dlg>

	</div>

	<jsp:include page="bottom.jsp"></jsp:include>
    
	<jsp:include page="loginmodal.jsp"></jsp:include>
    


</body>
</html>

<script type="text/javascript">
	let vm=new Vue({
		el: "#app",
		data(){
			return {
				cartItems:[],
				hostHead:"${pageContext.request.contextPath}",
				selectedAll:true,
				openLogin:false,
				hyid:"${sessionScope.huiyuan.id}",
			}
		},
		methods:{
			selectedAllHandler(){
				if(this.cartItems==null||this.cartItems.length==0)
					return ;
				console.log("执行全选");
				this.cartItems.forEach(c=>{
					c.value.selected=this.selectedAll;
				});
			},
			countChange(item){
				console.log("item=",item);
				let cart=new SmartStorage();
				cart.update(item.id,item);
			},
			removeHandler(id){
				let shopcart=new SmartStorage();
				shopcart.remove(id);
				this.load();

			},
			load(){
				let cart=new SmartStorage();
				this.cartItems=cart.getItems();
				console.log("this.cartItems=",this.cartItems);
			},
			doOrderHandler(){
				if(this.hyid=="") {
					this.openLogin = true;
					return;
				}
				window.location.href=this.hostHead+"/e/xiadan.jsp";
			}
		},
		computed:{
			totalPrice(){
				if(this.cartItems==null||this.cartItems.length==0)
					return 0;
				let sum=0;
				this.cartItems.forEach(c=>{
					if(c.value.selected)
						sum+=c.value.count*c.value.price;
				});
				return sum;
			},
			selectedCount(){
				if(this.cartItems==null||this.cartItems.length==0)
					return 0;
				let count=0;
				this.cartItems.forEach(c=>{
					if(c.value.selected)
						count++;
				});
				return count;
			}
		},
		watch:{
			cartItems:{
				handler() {
					let shopcart=new SmartStorage();
					this.cartItems.forEach(c=>{
						shopcart.update(c.id,c.value);
					});

				},
				immediate:false,
				deep:true
			}
		},
		created () {
			this.load();
		}

	});
</script>

<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>
<%@ include file="law.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>


<head>

	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>会员登录</title>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/e/css/index.css" type="text/css"></link>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/e/css/box.all.css" type="text/css"></link>
	<script type="text/javascript" src="${pageContext.request.contextPath}/webui/jquery/jquery-1.12.4.min.js"></script>
	<link href="${pageContext.request.contextPath}/webui/bootstrap/css/bootstrap.css" rel="stylesheet" type="text/css"/>
	<link href="${pageContext.request.contextPath}/webui/bootstrap/css/font-awesome.css" rel="stylesheet"  type="text/css"/>
	<script type="text/javascript" src="${pageContext.request.contextPath}/webui/vue/vue.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/webui/vue/vue-resource-1.3.4.js"></script>
	<link href="${pageContext.request.contextPath}/webui/vue/elementui/theme-chalk/index.css" rel="stylesheet"/>
	<script src="${pageContext.request.contextPath}/webui/vue/elementui/index.js"></script>
	<link href="${pageContext.request.contextPath}/webui/vuecontrol/dwvuecontrol.css" rel="stylesheet"/>
	<script src="${pageContext.request.contextPath}/webui/vuecontrol/dwvuecontrol.umd.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/webui/vue/vueutil.js"></script>

	<link href="${pageContext.request.contextPath}/admin/css/web2table.css" rel="stylesheet" type="text/css"/>





</head>
<body>

<div id="app">

	<page-header></page-header>
	<div class="wrap round-block">

		<div class="line-title">
			当前位置：<a href="${pageContext.request.contextPath}/e/index.jsp">首页</a> &gt;&gt; 账户余额
		</div>
        <div class="pcontent">

			<div style="padding:30px;font-size:18px;">
				我的余额<span style="font-size:24px;font-weight:800;color:#f00;">{{huiyuan.yue}}元</span>

				<el-button @click="chongzhiDlg=true" type="primary">我要充</el-button>

			</div>



			<el-dialog title="充积分" :visible.sync="chongzhiDlg">

				<table class="grid" cellspacing="1" width="100%">
					<tr>
						<td width="15%" align="right">金额:</td>
						<td width="*">
							<input name="name" v-model="fee"  placeholder="名称"
								   v-validate="{required:true,digits:true,messages:{required:'请输入金额',digits:'请输入正确的金额'}}" class="input-txt" type="text"/>

						</td>
					</tr>

					<tr>
						<td width="15%" align="right">支付方式:</td>
						<td  width="*">

							<el-radio-group v-model="paytype">
								<el-radio :label="1">
									<img :src="hostHead+'/e/images/alipay.jpg'" alt="支付宝" />
								</el-radio>
								<el-radio :label="2">
									<img :src="hostHead+'/e/images/wechat.jpg'" alt="微信" />
								</el-radio>

							</el-radio-group>


						</td>
					</tr>
				</table>
				<div slot="footer" class="dialog-footer">
					<el-button @click="chongzhiHandler" type="primary" >确 定</el-button>
					<el-button @click="chongzhiDlg = false">取 消</el-button>
				</div>
			</el-dialog>



		</div>

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

	let vm=new Vue({
		el:"#app",

		data(){
			return {
				actiontype:'save',
				"chongzhiDlg":false,
				fee:100,
				paytype:1,
				hostHead:'${pageContext.request.contextPath}',
				"huiyuan":{
				},
			}
		},
		methods:{
			//begin load
			async load(){
				let id="${sessionScope.huiyuan.id}"
				let util=new VueUtil(this);
				if(id!=""){
					let url="admin/huiyuan/load";
					let {data:res}=await util.http.post(url,{id:id});
					console.log("res",res);
					if(res!=null&&res.data!=null)
						this.huiyuan=res.data;
				}
			},//end load
			async chongzhiHandler(){
				const validRes = this.myValidator.valid(this);
				if (!validRes)
					return;

				window.location.href=this.hostHead+"/admin/huiyuan/chongzhi?hyid="+this.huiyuan.id+"&amount="+this.fee;

			}

		},
		created(){
			this.load();
		}

	});

</script>
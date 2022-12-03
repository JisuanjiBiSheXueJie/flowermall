
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>
<%@ include file="law.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>修改信息</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/e/css/index.css" type="text/css"></link>

<link rel="stylesheet" href="${pageContext.request.contextPath}/e/css/box.all.css" type="text/css"></link>

<script src="${pageContext.request.contextPath}/webui/jquery/jquery-1.12.4.min.js" type="text/javascript"></script>

    <script  type="text/javascript" src="${pageContext.request.contextPath}/webui/jquery/jquery.validate.min.js"></script>
    <script type="text/javascript"  src="${pageContext.request.contextPath}/webui/jquery/jquery.validateex.js" ></script>
    <script type="text/javascript"  src="${pageContext.request.contextPath}/webui/jquery/jquery.metadata.js" ></script>
    <script type="text/javascript"  src="${pageContext.request.contextPath}/webui/jquery/messages_cn.js" ></script>
	<link href="${pageContext.request.contextPath}/webui/dapper/dapper.css" rel="stylesheet" type="text/css" />
	<script src="${pageContext.request.contextPath}/webui/dapper/dapper.js" type="text/javascript"></script>
	<script type='text/javascript' src='${pageContext.request.contextPath}/webui/vue/vue.js'></script>
	<script type='text/javascript' src='${pageContext.request.contextPath}/webui/vue/vue-resource-1.3.4.js'></script>
	<link href="${pageContext.request.contextPath}/webui/vue/elementui/theme-chalk/index.css" rel="stylesheet"/>
	<script src="${pageContext.request.contextPath}/webui/vue/elementui/index.js"></script>

    <script type="text/javascript">
     
          $(function(){
        	  

        	  $.metadata.setType("attr","validate");
              $("#huiyuanForm").validate();

          });
          
          
    
    </script>



</head>
<body>

	<jsp:include page="head.jsp"></jsp:include>

	<div class="wrap round-block">
		<div class="line-title">
			当前位置：<a href="${pageContext.request.contextPath}/e/index.jsp">首页</a> &gt;&gt;我感兴趣标签
		</div>
	

		<div class="main">

			<jsp:include page="menu.jsp"></jsp:include>
			<div class="main-content">
               <div id="app">

					<table class="grid" cellspacing="1" width="100%">

						
						<tr>
							<td align="right">标签:</td>
							<td>
								<span v-for="item in listFans">
									 <input :id="'chk'+item.id" type="checkbox"  @change="changeHandler(item.id)"   :checked="item.checked?'checked':''" :value="item.id" /> {{item.name}}
								</span>
							</td>
						</tr>

						
						<tr>
							<td align="right"></td>
							<td>
								<input @click="submitFans" type="submit" value="提交"
									   class="dw-btn" />
							</td>
						</tr>

						
					
					</table>


              </div>
			</div>
		</div>

	</div>



	<div class="fn-clear"></div>


	<jsp:include page="bottom.jsp"></jsp:include>



</body>
</html>

<script type="text/javascript">


	Vue.http.options.root = '${pageContext.request.contextPath}';

	Vue.http.options.emulateJSON = false;
	Vue.http.options.xhr = {withCredentials: true};

	let vm = new Vue({
		el: "#app",
		data: {

			hostHead: '${pageContext.request.contextPath}',
			listStag:[],
			listFans:[],
			id:"${requestScope.huiyuan.id}",


		},
		async created() {

		},
		async mounted() {
			this.getTags();
			this.getHuiyuan();
		},
		methods: {
			async getTags(){
				let url = "admin/stag/list";
				let {data:res}=await this.$http.post(url);
				if(res!=null&&res.data!=null) {
					this.listStag =res.data;
				}
				this.listStag.forEach(e=>e.checked=false);

				console.log("this.listStag1=",this.listStag);

			},
			changeHandler(id){

				let checkbox=document.getElementById("chk"+id);
				this.listFans.forEach(e=>{
					if (e.id==id)
						e.checked=checkbox.checked;
				})
				console.log("this.listFans=",this.listFans);
			},

			async getHuiyuan(){

				let url = "admin/huiyuan/info";
				let {data:res}=await this.$http.post(url,{
					id:this.id
				});
				if(res!=null&&res.data!=null) {
                    console.log("res.data=",res.data);
                    if (res.data.fans==null) {
						this.listFans = this.listStag;
						return;
					}
					let myfans=res.data.fans.split("$;");
					console.log("myfans=",myfans);
					this.listStag.forEach(c=>{
						if (myfans.length==0)
							c.checked=false;
						else {
							let res = myfans.some(e => c.id == e);
							c.checked = res;
						}
					});
                    this.listFans=this.listStag;
					console.log("this.listFans=",this.listFans);

				}
			},
			async submitFans(){
				let url = "admin/huiyuan/ufans";
				let ids=this.listStag.filter(e=>e.checked).map(e =>e.id);

				console.log("id=",ids);
				let {data:res}=await this.$http.post(url,{
					ids,
					hyid:this.id
				});
				if(res!=null&&res.stateCode!=null) {
					alert("更新成功");
				}

			}

		}

	});

</script>

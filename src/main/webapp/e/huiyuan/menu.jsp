<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>


<template id="pageMenu">
	<div class="aside-menu" id="side-menu">

		<div class="title">系统菜单</div>
		<dl>
			<dt><i class="fa fa-plus"></i>与我相关</dt>
			<dd id="301" >
				<a  href="${pageContext.request.contextPath}/e/huiyuan/shordermanager.jsp?seedid=301">我的订单</a>
			</dd>

			<dd id="302" >
				<a  href="${pageContext.request.contextPath}/e/huiyuan/shoucangmanager.jsp?seedid=302">我的收藏夹</a>
			</dd>

			<dd id="303" >
				<a  href="${pageContext.request.contextPath}/e/huiyuan/leavewordmanager.jsp?seedid=303">我的咨询</a>
			</dd>

		</dl>


		<dl>
			<dt><i class="fa fa-cog"></i>安全中心 </dt>


			<dd id="203">
				<a href="${pageContext.request.contextPath}/e/huiyuan/modifypw.jsp?seedid=203" target="_self">登录密码修改</a>
			</dd>
			<dd id="204">
				<a href="${pageContext.request.contextPath}/e/huiyuan/modifypaypw.jsp?seedid=204" target="_self">支付密码修改</a>
			</dd>


		</dl>

		<dl>
			<dt><i class="fa fa-plus"></i>账户信息</dt>
			<dd id="101"><a  href="${pageContext.request.contextPath}/e/huiyuan/accountinfo.jsp?seedid=101">账户信息</a></dd>
			<dd id="103" ><a  href="${pageContext.request.contextPath}/e/huiyuan/yue.jsp?seedid=103">账户余额</a></dd>
			<dd id="105" ><a  href="${pageContext.request.contextPath}/e/huiyuan/receaddressmanager.jsp?seedid=105">收货地址</a></dd>
			<dd id="104" ><a  href="${pageContext.request.contextPath}/e/huiyuan/modifyinfo.jsp?seedid=104">编辑资料</a></dd>
		</dl>
	</div>
</template>


<script type="text/javascript">

	Vue.component("pageMenu", {
		template: "#pageMenu",
		data() {
			return {}
		},
		methods: {
			load() {

				let lis = document.querySelectorAll("#side-menu dl dd");
				console.log("lis=", lis);
				for (let i = 0; i < lis.length; i++) {
					if (lis[i].id == this.seedid) {
						lis[i].classList.add("current");
						console.log("添加样式current");
					} else
						lis[i].classList.remove("current");

				}
			}
		},
		props: {
			seedid: {
				type: String,
				default: "101"
			}
		},
		mounted() {
			this.load();
		},


	})


</script>
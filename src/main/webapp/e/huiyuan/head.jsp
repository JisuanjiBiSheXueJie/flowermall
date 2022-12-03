<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>


<template id="pageheader">
    <div >
        <div class="page-head3">
           <div class="wrap">
               <el-menu  text-color="#fff" active-text-color="#ffd04b" background-color="#151320"  class="el-menu-demo" mode="horizontal" >

                   <el-menu-item index="0"> <a :href="hostHead+''"><i class="el-icon-s-home"></i>首页</a></el-menu-item>

                   <el-submenu index="1">
                       <template slot="title">${sessionScope.huiyuan.accountname}--${sessionScope.huiyuan.name}</template>
                       <el-menu-item @click.native="exitHandler" index="1_1"> <i class="el-icon-picture"></i>退出</el-menu-item>

                   </el-submenu>
                   <el-submenu index="2">
                       <template slot="title">与我相关</template>
                       <el-menu-item index="2_1"><a :href="hostHead+'/e/huiyuan/shordermanager.jsp'">订单管理</a></el-menu-item>
                       <el-menu-item index="2_2"><a :href="hostHead+'/e/huiyuan/shoucangmanager.jsp'">我的收藏夹</a></el-menu-item>
                       <el-menu-item index="2_3"><a :href="hostHead+'/e/huiyuan/leavewordmanager.jsp'">我的咨询</a></el-menu-item>

                   </el-submenu>
                   <el-submenu index="3">
                       <template slot="title">安全中心</template>
                       <el-menu-item index="3_1"><a :href="hostHead+'/e/huiyuan/modifypw.jsp'">修改密码</a></el-menu-item>
                       <el-menu-item index="3_2"><a :href="hostHead+'/e/huiyuan/modifypaypw.jsp'">支付密码修改</a></el-menu-item>

                   </el-submenu>

                   <el-submenu index="4">
                       <template slot="title">账户设置</template>
                       <el-menu-item index="4_1"><a :href="hostHead+'/e/huiyuan/accountinfo.jsp'" >我的账户</a></el-menu-item>
                       <el-menu-item index="4_2"><a :href="hostHead+'/e/huiyuan/yue.jsp'" >账户余额</a></el-menu-item>
                       <el-menu-item index="4_3"><a :href="hostHead+'/e/huiyuan/receaddressmanager.jsp'" >收货地址管理</a></el-menu-item>
                       <el-menu-item index="4_4"><a :href="hostHead+'/e/huiyuan/modifyinfo.jsp'" >编辑账户</a></el-menu-item>

                   </el-submenu>


               </el-menu>

           </div>

        </div>
    </div>
    <div>
        <div class="p-head2">
            <div class="cont">

                <div class="site-name">在线鲜花销售系统</div>
                <div class="navigation">


                </div>

            </div>

            <div class="oper-con">
                <template v-if="!isLogin()">
                    <a href="${pageContext.request.contextPath}/e/login.jsp" class="lb lb-primary">登录</a>
                    <a href="${pageContext.request.contextPath}/e/register.jsp" class="lb lb-success">注册</a>
                </template>

                <template v-else>
                    <el-dropdown>
                      <span class="el-dropdown-link">
                        ${sessionScope.huiyuan.accountname}<i class="el-icon-arrow-down el-icon--right"></i>
                      </span>
                        <el-dropdown-menu slot="dropdown">
                            <el-dropdown-item><a href="${pageContext.request.contextPath}/e/huiyuan/accountinfo.jsp"><i
                                    class="fa fa-user"></i>账户信息</a></el-dropdown-item>
                            <el-dropdown-item><a href="${pageContext.request.contextPath}/e/huiyuan/modifypw.jsp"><i
                                    class="fa fa-lock"></i>修改密码</a></el-dropdown-item>
                            <el-dropdown-item><a href="${pageContext.request.contextPath}/e/huiyuan/modifyinfo.jsp"><i
                                    class="fa fa-edit"></i>编辑账号</a></el-dropdown-item>
                            <el-dropdown-item divided></el-dropdown-item>
                            <el-dropdown-item @click.native="exitHandler"><span class="exit">退出</span></el-dropdown-item>
                        </el-dropdown-menu>
                    </el-dropdown>
                </template>

                <a href="${pageContext.request.contextPath}/e/search.jsp" class="lb lb-info"><i
                        class="fa fa-search"></i></a>

            </div>

        </div>
        <div style="height: 70px;"></div>
    </div>
</template>


<script type="text/javascript">


    Vue.http.options.root = '${pageContext.request.contextPath}';
    Vue.http.options.emulateJSON = true;
    Vue.http.options.xhr = {withCredentials: true};
    Vue.component("pageHeader", {
        data() {
            return {
                listSitenav: [],
                loginDlg: false,
                hostHead: "${pageContext.request.contextPath}"
            }
        },
        methods: {
            async list() {
                let url = "admin/sitenav/list";
                let param = {
                    "ispaged": "-1",
                    "order": " order by id desc"
                };
                let {data: res} = await this.$http.post(url, param);
                if (res.data != null) {
                    console.log("header res=", res);
                    this.listSitenav = res.data;
                }
            },
            isLogin() {
                let huiyuan = "${sessionScope.huiyuan.accountname}";
                if (huiyuan == "")
                    return false;
                return true;
            },
            async exitHandler() {
                this.$confirm('确定要离开?', '系统提示', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning',
                }).then(async (r) => {
                    let {data: res} = await this.$http.post("admin/huiyuan/exit");
                    if (res != null && res.stateCode < 0) {
                        this.$message.error(res.des);
                        return;
                    }
                    window.location.reload();

                }).catch(e => {
                });
            }
        },
        created() {
            this.list();
        },
        props: {
            headid: {
                type: String,
                default: "1"
            }
        },
        template: "#pageheader"

    });


</script>
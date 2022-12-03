<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ include file="import.jsp" %>
<template id="pageheader">
    <div>

       <div class="p-head2">
        <div class="cont">

            <div class="site-name">在线鲜花销售系统</div>
            <div class="navigation">
                <ul>
                    <template v-for="sn in listSitenav">
                        <li v-if="sn.withParam"><a :class="{current:sn.id==headid}" :id="sn.id"
                                                   :href="hostHead+sn.href+'&headid='+sn.id">{{sn.title}}</a></li>
                        <li v-else><a :id="sn.id" :class="{current:sn.id==headid}"
                                      :href="hostHead+sn.href+'?headid='+sn.id">{{sn.title}}</a></li>
                    </template>


                </ul>
            </div>

        </div>

        <div class="oper-con">

            <a :href="hostHead+'/e/shopcart.jsp'" class="el-button el-button--danger is-circle" ><i class="el-icon-shopping-cart-1"></i></a>
            <a :href="hostHead+'/e/search.jsp'" class="el-button el-button--primary is-circle" ><i class="el-icon-search"></i></a>
            <template v-if="!isLogin()">

                <a title="登录" :href="hostHead+'/e/login.jsp'" class="el-button el-button--waring is-circle" ><i class="el-icon-user"></i></a>
                <a title="注册" :href="hostHead+'/e/register.jsp'" class="el-button el-button--success is-circle" ><i class="el-icon-plus"></i></a>


            </template>

            <template v-else>
                <el-dropdown style="padding:2px 10px;color: #fffdf4; ">
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
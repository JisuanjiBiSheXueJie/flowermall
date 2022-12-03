<%@page import="com.daowen.util.*"%>
<%@page import="com.daowen.entity.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>会员登录</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/e/css/index.css" type="text/css"></link>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/e/css/box.all.css" type="text/css"></link>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/e/css/login.css" type="text/css"></link>

    <script type="text/javascript" src="${pageContext.request.contextPath}/webui/vue/vue.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/webui/vue/vue-resource-1.3.4.js"></script>
    <link href="${pageContext.request.contextPath}/webui/vue/elementui/theme-chalk/index.css" rel="stylesheet"/>
    <script src="${pageContext.request.contextPath}/webui/vue/elementui/index.js"></script>
    <link href="${pageContext.request.contextPath}/webui/vuecontrol/dwvuecontrol.css" rel="stylesheet"/>
    <script src="${pageContext.request.contextPath}/webui/vuecontrol/dwvuecontrol.umd.js"></script>
    <script src="${pageContext.request.contextPath}/webui/quill/quill.min.js"></script>
    <script src="${pageContext.request.contextPath}/webui/quill/vue-quill-editor.js"></script>
    <link href="${pageContext.request.contextPath}/webui/quill/quill.core.css" rel="stylesheet"/>
    <link href="${pageContext.request.contextPath}/webui/quill/quill.snow.css" rel="stylesheet"/>
    <link href="${pageContext.request.contextPath}/webui/quill/quill.bubble.css" rel="stylesheet"/>
    <script type="text/javascript" src="${pageContext.request.contextPath}/webui/vue/vueutil.js"></script>

    <style type="text/css">
        label.error{
            position: absolute;
            top:12px;
            left: 320px;
        }
    </style>


</head>
<body>
<div id="app">
<div class="login-hd">
    <a href="${pageContext.request.contextPath}/e/index.jsp" class="text">
        在线鲜花销售系统
    </a>
</div>

<div  class="login-con">

    <div  class="carousel-con">
        <el-carousel  height="650px" :interval="5000" arrow="always">
            <el-carousel-item v-for="(jdt,index) in listJiaodiantu" :key="index">

                <img class="image" :src="hostHead+jdt.tupian " />

            </el-carousel-item>
        </el-carousel>
    </div>

        <div class="login-form">
            <div class="title clearfix">
                <h1>用户登录</h1>
                <a href="${pageContext.request.contextPath}/e/register.jsp">立即注册</a>
            </div>
            <div class="bd">

                <div class="table-row">
                    <input type="text" name="accountname" v-model="accountname" v-validate="{required:true,messages:{required:'请输入账户名'}}" class="smart-input"  placeholder="请输入用户名">
                </div>
                <div class="table-row">
                    <input type="password" name="password" v-model="password" class="smart-input" v-validate="{required:true,messages:{required:'请输入密码'}}"  placeholder="请输入密码">

                </div>


                <div class="more_input clearfix">
                </div>
                <input type="submit" @click="loginHandler" value="登录" class="login-btn">

                <div >

                    <a href="${pageContext.request.contextPath}/e/forgetpw.jsp">忘记密码</a>
                </div>

            </div>
        </div>

</div>

</div>
</body>
</html>


<script type="text/javascript">

    Vue.http.options.root = '${pageContext.request.contextPath}';
    Vue.http.options.emulateJSON = true;
    Vue.http.options.xhr = {withCredentials: true};
    Vue.use(window.VueQuillEditor);
    let vm = new Vue({
        el: "#app",
        data() {
            return {
                accountname:"",
                password:"",
                usertype:0,
                listJiaodiantu:[],
                errors: {},
                hostHead: '${pageContext.request.contextPath}',
            }
        },
        methods: {
            async loginHandler() {
                let util = new VueUtil(this);
                const  validRes=this.myValidator.valid(this,{isShowErrors:true});
                console.log("valRes",validRes);
                if (!validRes)
                    return ;

                let {data: res} = await util.http.post("admin/huiyuan/login", {
                    accountname: this.accountname,
                    password: this.password,
                    usertype:this.usertype

                });
                if (res.stateCode <= 0) {
                    util.alert(res.des, '系统提示', {
                        confirmButtonText: '确定'
                    });
                    return;
                }

                window.location.href = this.hostHead + "/e/huiyuan/accountinfo.jsp";

            },
            getJiaodiantu() {
                let url = "admin/jiaodiantu/list";
                this.$http.post(url,{"ispaged":"-1"}).then(res => {
                    //console.log(res.data);
                    this.listJiaodiantu = res.data.data;

                });
            },
        },
        created() {
            console.log("注册创建");
            this.getJiaodiantu();
        }

    });

</script>
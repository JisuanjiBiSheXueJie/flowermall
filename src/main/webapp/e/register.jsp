
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>

<%@ include file="import.jsp" %>
<%@ taglib prefix="web" uri="/WEB-INF/webcontrol.tld"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>系统注册</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/e/css/index.css" type="text/css"></link>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/e/css/box.all.css" type="text/css"></link>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/e/css/register.css" type="text/css"></link>
    <script src="${pageContext.request.contextPath}/webui/jquery/jquery-1.12.4.min.js"  type="text/javascript"></script>
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
            top: -2px;
        }
    </style>
</head>
<body>
<div id="app" class="full-wrapper">
    <div class="center-wrapper">

        <div class="wrapper-title">
            会员注册
        </div>
        <div></div>


        <div class="wrapper-content">



            <div class="stdrow">
                <div style="width:120px;" class="tb">账户:</div>
                <div class="ct">
                    <div class="input-pack">
                        <input  type="text" placeholder="账户名" v-model="huiyuan.accountname" v-validate="{required:true,messages:{required:'请输入账户名'}}" name="accountname" />
                    </div>
                </div>
            </div>



            <div class="stdrow">
                <div style="width:120px;" class="tb">密码:</div>
                <div class="ct">
                    <div class="input-pack">
                        <input  type="password"  placeholder="密码" v-model="huiyuan.password" v-validate="{required:true,messages:{required:'请输入密码'}}" name="password" />
                    </div>
                </div>
            </div>

            <div class="stdrow">
                <div style="width:120px;" class="tb">确认密码:</div>
                <div class="ct">
                    <div class="input-pack">
                        <input  type="password" placeholder="确认密码"  v-model="huiyuan.password2"  v-validate="{required:true,messages:{required:'请再次输入密码'}}" name="password2" />
                    </div>
                </div>
            </div>

            <div class="stdrow">
                <div style="width:120px;" class="tb">性别:</div>
                <div class="ct">
                    <el-radio-group v-model="huiyuan.sex">
                        <el-radio-button label="男">男</el-radio-button>
                        <el-radio-button label="女">女</el-radio-button>

                    </el-radio-group>
                </div>
            </div>

            <div class="stdrow">
                <div style="width:120px;" class="tb">相片:</div>
                <div class="ct">
                    <dw-upload :host-head="hostHead" v-model="huiyuan.touxiang"></dw-upload>
                </div>
            </div>




            <div class="stdrow">
                <div style="width:120px;" class="tb">身份证号:</div>
                <div class="ct">
                    <div class="input-pack">
                        <input  type="text" placeholder="身份证号" v-model="huiyuan.idcardno" v-validate="{required:true,idcardno:true,messages:{required:'请输入身份证号',idcardno:'请输入正确的身份证号'}}"  name="idcardno" />
                    </div>
                </div>
            </div>

            <div class="stdrow">
                <div style="width:120px;" class="tb">姓名:</div>
                <div class="ct">

                    <div class="input-pack">
                        <input  type="text" placeholder="姓名" v-model="huiyuan.name" v-validate="{required:true,messages:{required:'请输入姓名'}}"  name="name" />
                    </div>

                </div>
            </div>

            <div class="stdrow">
                <div style="width:120px;" class="tb">邮箱:</div>
                <div class="ct">


                    <div class="input-pack">
                        <input  type="text" placeholder="邮箱" v-model="huiyuan.email" v-validate="{required:true,email:true,messages:{required:'请输入邮箱',email:'请输入正确邮箱'}}"   name="email" />
                    </div>

                </div>
            </div>




            <div class="agree-protocol">
                点击注册，表示您同意 <a href="#">《服务协议》</a>

            </div>
            <button @click="registerHandler" class="register-btn">同意并注册</button>
            <div style="position:relative;">${errormsg }</div>
            <div class="agree-protocol">
                <a href="${pageContext.request.contextPath}/e/login.jsp">登录系统</a>

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

                actiontype: 'save',
                errors: {},
                hostHead: '${pageContext.request.contextPath}',
                "huiyuan": {
                    "accountname": "",
                    "password": "",
                    "email": "",
                    "idcardno": "",
                    "nickname": "",
                    "name": "",
                    "email":"",
                    "sex": "男",
                    "touxiang": "/upload/nopic.jpg",
                    "des": ""
                },
            }
        },
        methods: {

            async registerHandler() {

                let defaultOptions = {
                    url: "admin/huiyuan/save",
                    actionTip: "注册成功"
                };

                const  validRes=this.myValidator.valid(this,{isShowErrors:true});
                console.log("valRes",validRes);
                if (!validRes)
                    return ;
                let util = new VueUtil(this);
                let params = {...this.huiyuan};
                let {data: res} = await util.http.post(defaultOptions.url, params);
                if (res.stateCode <= 0) {
                    util.alert(res.des, '系统提示', {
                        confirmButtonText: '确定'
                    });
                    return;
                }
                util.message({
                    message: defaultOptions.actionTip,
                    type: 'success',
                    duration: 2000
                });
                window.location.href = this.hostHead + "/e/regresult.jsp";
            }
        },
        created() {
            console.log("注册创建");
        }

    });

</script>
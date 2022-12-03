<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="UTF-8"%>

<template id="loginModal">
    <div>
        <el-dialog width="30%"  :close-on-click-modal="false" :visible="show" @update:visible="closeHandler">

            <span slot="title">用户登录</span>
            <div class="form-line">
                <div class="form-group">
                    <label>用户名</label>
                    <input type="text" class="form-control" v-model="accountname"   placeholder="用户名">
                </div>
            </div>

            <div class="form-line">
                <div class="form-group">
                    <label>密码</label>
                    <input type="password" class="form-control" v-model="password"   placeholder="密码">
                </div>
            </div>


            <span slot="footer" class="dialog-footer">
                <el-button type="primary" @click="loginHandler">确 定</el-button>
                <el-button @click="cancelHandler">取 消</el-button>
                <el-divider></el-divider>
                <a href="${pageContext.request.contextPath}/e/register.jsp">注册</a>| <a href="${pageContext.request.contextPath}/e/forgetpw.jsp">忘记密码</a>
            </span>
        </el-dialog>
    </div>

</template>
<script>
    Vue.component('loginDlg',{
        data(){
            return{
                accountname: '',
                password: ''
            }
        },
        methods:{
            cancelHandler(){
                this.$emit("update:show",false);
            },
            async loginHandler(){
                let url="${pageContext.request.contextPath}/admin/huiyuan/login";
                let {data:res}=await this.$http.post(url,{
                    accountname:this.accountname,
                    password:this.password,
                    type:1
                });
                if(res!=null&&res.stateCode<0) {
                    this.$message.error(res.des);
                    return;
                }
                if(res!=null&&res.stateCode>0){
                    console.log("登录成功");
                    this.$emit("update:show",false);
                    //window.sessionStorage.setItem('huiyuan',JSON.stringify(res.data));
                    this.$emit("afterLogin",true);
                    window.location.reload();
                }
            },
            closeHandler (val) {
                console.log("执行关闭");
                this.$emit("update:show",val);
            }
        },
        props:{
            show:{
                type:Boolean,
                default:false
            }
        },
        template:"#loginModal"
    })

</script>

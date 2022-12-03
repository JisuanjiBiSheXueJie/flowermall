
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>系统首页</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/e/css/index.css" type="text/css"></link>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/e/css/box.all.css" type="text/css"></link>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/e/css/register.css" type="text/css"></link>
    <script src="${pageContext.request.contextPath}/webui/jquery/jquery-1.12.4.min.js" type="text/javascript"></script>
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


</head>
<body>

<div id="app">

    <page-header active="${param.headid}"></page-header>
    <div class="wrap  round-block">
        <div class="line-title">
            当前位置：<a href="${pageContext.request.contextPath}/e/index.jsp">首页</a> &gt;&gt; 系统公告
        </div>
        <div class="fn-clear"></div>
        <div style="min-height:600px;" class="info">
            <h1>
                {{notice.title}}
            </h1>
            <h5>
                来源: {{notice.pubren}}
                浏览:<span id="count">2次</span>
                发布时间：{{notice.pubtime}}
            </h5>
            <div class="news-content">
                <div v-html="notice.dcontent">
                </div>
            </div>

        </div>
    </div>

    <div class="fn-clear"></div>


</div>
<jsp:include page="bottom.jsp"></jsp:include>


</body>
</html>


<script type="text/javascript">


    Vue.http.options.root = '${pageContext.request.contextPath}';

    Vue.http.options.emulateJSON = true;
    Vue.http.options.xhr = {withCredentials: true};

    let vm = new Vue({
        el: "#app",
        data: {

            hostHead: '${pageContext.request.contextPath}',
            notice:{}

        },
        async created() {
            this.getInfo();
        },
        methods: {
           async getInfo() {
                let url = "admin/notice/load";
                let {data:res}=await this.$http.post(url, {
                    id: "${param.id}"
                });
                if (res!=null&&res.stateCode<0){
                    this.$message.error(res.des);
                    return ;
                }
                this.notice = res.data;
            }
        }

    });

</script>
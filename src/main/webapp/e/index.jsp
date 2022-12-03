<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ include file="import.jsp" %>


<!DOCTYPE HTML>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>系统首页</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/e/css/index.css" type="text/css"></link>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/e/css/style.css" type="text/css"></link>
    <link href="${pageContext.request.contextPath}/e/css/box.all.css" rel="stylesheet" type="text/css"/>
    <link href="${pageContext.request.contextPath}/e/css/carousel.css" rel="stylesheet" type="text/css"/>
    <script src="${pageContext.request.contextPath}/webui/jquery/jquery-1.12.4.min.js" type="text/javascript"></script>
    <script type='text/javascript' src='${pageContext.request.contextPath}/e/js/jquery.SuperSlide.2.1.1.js'></script>
    <script type='text/javascript' src='${pageContext.request.contextPath}/webui/vue/vue.js'></script>
    <script type='text/javascript' src='${pageContext.request.contextPath}/webui/vue/vue-resource-1.3.4.js'></script>
    <link href="${pageContext.request.contextPath}/webui/vue/elementui/theme-chalk/index.css" rel="stylesheet"/>
    <script src="${pageContext.request.contextPath}/webui/vue/elementui/index.js"></script>


</head>
<body>



<div id="app">

    <page-header  headid="${param.headid}"></page-header>
    <div class="banner-content">
        <div class="banner-content-box">
            <div class="banner-nav-left">
                <ul>

                    <li v-if="lanmu.type==2" class="index==(listLanmu.length-1)?'bor-none':''" v-for="(lanmu,index) in listLanmu">
                        <h3><a :href="hostHead+'/e/shangpinlist.jsp?typeid='+lanmu.id">{{lanmu.name}}</a></h3>
                        <a v-for="subtype in lanmu.subtypes" :href="hostHead+'/e/shangpinlist.jsp?typeid='+lanmu.id+'&subtypeid='+subtype.id" >{{subtype.name}}</a>
                    </li>
                    <li v-if="lanmu.type==1" class="index==(listLanmu.length-1)?'bor-none':''" v-for="(lanmu,index) in listLanmu">
                        <h3><a :href="hostHead+'/e/lanmuinfo.jsp?lanmuid='+lanmu.id">{{lanmu.name}}</a></h3>
                        <a v-for="subtype in lanmu.subtypes" :href="hostHead+'/e/lanmuinfo.jsp?lanmuid='+lanmu.id+'&subtypeid='+subtype.id" >{{subtype.name}}</a>
                    </li>

                </ul>
            </div>
        </div>
        <div style="position: absolute;right:20px;z-index:123;background: #fff;height: 405px; " class="plat-notice-panel">
            <div class="title">
                <i class="fa fa-volume-up"></i>系统公告
                <div class="more"><a href="${pageContext.request.contextPath}/e/noticelist.jsp"><i
                        class="fa fa-chevron-right"></i></a></div>
            </div>

            <ul>

                <li v-for="notice in listNotice">
                    <a :href="'${pageContext.request.contextPath}/e/noticeinfo.jsp?id='+notice.id">{{notice.title}}</a>
                </li>

            </ul>
        </div>
    </div>



    <div class="city-slide">
        <div class="hd city-slide-header">
            <a class="prev" href="javascript:void(0)"></a>
            <a class="next" href="javascript:void(0)"></a>
        </div>
        <div class="bd city-slide-body">
            <ul>
                <li style="background:#bf271d" v-for="jdt in listJiaodiantu">
                    <a :href="jdt.href">
                        <img :src="hostHead+jdt.tupian" alt=""/>
                    </a>
                </li>


            </ul>
        </div>
    </div>

    <div class="wrap com-panel">


        <div  class="image-text-box">

            <div class="hd">
                <div class="text">今日推荐</div>
            </div>
            <div class="bd">

                <div v-for="item in listHotclickSp" class="item2">
                    <div class="image-wrap">
                        <a :href="hostHead+'/e/shangpininfo.jsp?id='+item.id">
                            <img :src="hostHead+item.images[0]"/>

                        </a>

                    </div>
                    <div class="name">
                        {{item.name}}
                    </div>
                    <div class="name red">
                        {{item.jiage}}¥ <span style="float: right;padding-right:12px "> </span>
                    </div>

                </div>


                <div v-if="listHotclickSp.length<=0" class="no-record-tip">
                    <div class="content"><i class="fa fa-warning"></i>暂无推荐信息</div>
                </div>
            </div>

        </div>



    </div>
    <div class="wrap com-panel">
        <div v-if="textArea!=null" class="text-box-wrap">


            <div v-for="lanmu in textArea.listLanmuContent" class="text-box">
                <div class="hd">
                    <div class="title">{{lanmu.name}}</div>
                    <div class="more"><a :href="'${pageContext.request.contextPath}/e/lanmuinfo.jsp?lanmuid='+lanmu.id">更多</a>
                    </div>
                </div>
                <div class="bd">

                    <div v-for="(item,index) in lanmu.content" v-if="index==0" class="first">
                        <img class="image" :src="'${pageContext.request.contextPath}'+item.tupian">
                        <div class="des">
                            <div class="time">{{item.pubtime}}</div>
                            <div class="name"><a
                                    :href="'${pageContext.request.contextPath}'+item.href">{{item.name}}</a></div>
                        </div>
                    </div>

                    <ul>

                        <li v-for="(item,index) in lanmu.content" v-if="index>0"><a class="text"
                                                                                    :href="'${pageContext.request.contextPath}'+item.href">{{item.name}}</a><span
                                class="time">{{item.pubtime}}</span></li>

                    </ul>
                </div>
            </div>


        </div>
    </div>

    <div v-if="imagetextArea!=null" class="wrap com-panel clearfix">

        <div v-for="lanmu in imagetextArea.listLanmuContent" class="image-text-box">

            <div class="hd">
                <div class="text">{{lanmu.name}}</div>
            </div>

            <div class="ly-row">

                <div style="width:200px" class="ly-column">
                    <div class="lanmu-banner">
                        <img :src="'${pageContext.request.contextPath}'+lanmu.bannerurl" class="image"/>
                    </div>
                </div>
                <div style="width:1050px" class="ly-column">

                    <div class="bd">

                        <div v-for="item in lanmu.content" class="item2">
                            <div class="image-wrap">
                                <a :href="'${pageContext.request.contextPath}'+item.href">
                                    <img :src="'${pageContext.request.contextPath}'+item.tupian"/>
                                    <div v-if="lanmu.type==3" class="video-tag"></div>
                                </a>

                            </div>
                            <div class="name">
                                {{item.name}}
                            </div>
                            <div v-if="lanmu.type==2" class="name red">
                                {{item.price}}¥
                            </div>

                        </div>


                        <div v-if="lanmu.content.length<=0" class="no-record-tip">
                            <div class="content"><i class="fa fa-warning"></i>暂无{{lanmu.name}}信息</div>
                        </div>
                    </div>
                </div>
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

    Vue.http.options.emulateJSON = true;
    Vue.http.options.xhr = {withCredentials: true};

    let vm = new Vue({
        el: "#app",
        data: {
            imagetextArea: {},
            textArea: {},
            hostHead: '${pageContext.request.contextPath}',
            listJiaodiantu: [],
            listHotclickSp:[],
            listLanmu:[],
            listNotice: []
        },
        async created() {
            console.log("created");
            this.getNotice();
            this.imagetextArea = await this.getAreaContent(1);
            //this.textArea = await this.getAreaContent(2);
            this.getJiaodiantu();
            this.getHotclick();
            this.getLanmu();
        },

        async mounted() {


        },
        methods: {
            async getAreaContent(areaId) {
                let url = "admin/pagesetting/content/" + areaId;
                let res = await this.$http.get(url);
                console.log(res.data);
                return res.data.data;
            },
            getNotice() {
                let url = "admin/notice/list";
                this.$http.post(url,{ispaged:"-1"}).then(res => {
                    console.log(res.data);
                    this.listNotice = res.data.data;
                });
            },
            getHotclick() {
                let url = "admin/shangpin/hotclick";
                this.$http.post(url).then(res => {
                    console.log("点击排行榜",res.data);
                    this.listHotclickSp = res.data.data;
                });
            },
            getJiaodiantu() {
                let url = "admin/jiaodiantu/list";
                this.$http.post(url,{ispaged:"-1"}).then(res => {
                    console.log(res.data);
                    this.listJiaodiantu = res.data.data;
                    this.$nextTick(() => {
                        $(".city-slide").slide({
                            mainCell: ".bd ul",
                            effect: "fold",
                            autoPlay: true,
                            delayTime: 800
                        });
                    });
                });
            },
            getLanmu(){
                let url = "admin/lanmu/list";
                this.$http.post(url).then(res => {
                    console.log(res.data);
                    this.listLanmu = res.data.data;

                });
            }

        }

    });

</script>

(function (target) {


    let musicHandler=null;
    let load=function(options){

        let defaultOption={
           url: 'http://localhost:8080/music/admin/musicHandler/playlist',
        };
        Object.assign(defaultOption,options);
        musicHandler = new mjs();
        musicHandler.lycCallback = (lycText) => {
            //console.log("lycText"+lycText);
            $('#lyctext').html(lycText);
        };
        let data =defaultOption.data;
        if(data==null) {
            //获取歌单json
            $.ajax({
                url: defaultOption.url,
                type: 'post',
                async: false,
                data: {},
                success: function (res) {
                    data = res.data;
                    //console.log("data", data);
                },
                fail: function () {
                    alert('歌单获取失败！');
                }
            });
        }

        musicHandler.switchCallback = (attr) => {
            musicHandler.autoPlay(); //

            $('#divSongName').html(attr.title + "-" + attr.author);
            $("#divAllTime").html(musicHandler.alltime);
            $('#divCurpic').html('<img src="' + attr.pic + '" class="image"/>');
            if( typeof defaultOption.playCallback==="function"){
                defaultOption.playCallback(attr);
            }
        };

        $(".playBtn").click(function(){


            let p = $(this).attr("isplay");
            console.log("p="+p);
            if (p==0) {
                $(this).css("background-position","0 -30px");
                $(this).attr("isplay","1");
                musicHandler.autoPlay();
            };
            if (p==1) {
                $(this).css("background-position","");
                $(this).attr("isplay","0");
                musicHandler.stopPlay();
            };
        });

        $(".p-mode").click(function(){
            let type=$(this).data("type");
            //单曲
            if(type==1){
                $(this).data("type",2);
                $(this).css("background-position","0 -220px");
                musicHandler.orderMusic(2);
            }
            if(type==2){
                $(this).data("type",1);
                $(this).css("background-position","0 -181px");
                musicHandler.orderMusic(0);
            }

        });

        musicHandler.init(data, 1, 0.5);
        musicHandler.timeCallback = (musicHandler) => {
            $("#divPlayTime").html(musicHandler.nowtime);
        };
        $( ".play-bar" ).draggable({
            containment:".pro2",
            drag: function() {
                let width=$(this).css("left");
                let num=parseInt(width);
                musicHandler.playProgress((num*100)/678);

            }
        });
        $(".volume-bar").draggable({
            containment: ".volControl",
            drag: function () {
                let width= $(this).css("left");
                let strength = parseInt(width);
                musicHandler.playVolume(strength);
            }
        });

        $(".prevBtn").click(function(){
            musicHandler.prevMusic(function (musicHandler) {

            });
        });
        $(".nextBtn").click(function(){
            musicHandler.nextMusic(function (musicHandler) {});
        });
        return musicHandler;
    };
    let switchMusic=function(item){
        if(musicHandler==null||item==null)
            return;
        musicHandler.attrMusic(item);
    };

    window.myPlayer={
        load:load,
        switchMusic:switchMusic
    };

})(window);


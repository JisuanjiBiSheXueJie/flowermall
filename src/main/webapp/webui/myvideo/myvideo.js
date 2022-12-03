
	var danmuTopCube = Array(30,60,90,120,150,180,210,240);
	var ap_video_name = 'trailer_lc.mp4';
	// 获取播放器
	var apcore = $('#ap-player');
		apcore[0].volume = 0.5;
	createCp('default'); //创建拾色器
	// 初始化全局变量
	var ap_jdbar_off = true;
	var ap_volume_off = true;
	var ap_mouse;
	var ap_fullscreen = false;
	var ap_switch = true;
	var loaded;
	var autoConsole = setTimeout(function(){},100);
	var inConsole = false;
	// 加载弹幕文件
	var fileName = 1001;	//弹幕文件名
	//var ap_danmu = CL_GET(fileName); // 传入弹幕文件名
	//	ap_danmu = ap_danmu.replace(/\\/g,'');
	// var chatLib = '{'+ ap_danmu +'}';
	// 	chatLib = $.parseJSON(chatLib);
      var chatLib={};


// JQUERY - AP 拓展函数定义
// --------------------------------------------------------------------------
	// 函数：apAdd - 为播放器添加教程地址并重置播放器
	jQuery.fn.apAdd = function(src){
		if (this.is('video')) {
			this.attr('src',src);
			// blobVideoSrc(src,'10051');
			this.loadVideo();
			apcore[0].ondurationchange = function(){
				apcore.apRun();
				$('#ap-loading-box').css('display','none');
			};
		}else {
			return false;
		}
	}//end
	// 函数：reRun - 为播放器修改教程地址并播放
	jQuery.fn.reRun = function(src){
		clearInterval(ap_main);
		$('#ap-loading-box').css('display','block');
		var ap_rejd = apcore[0].currentTime;
		if (this.is('video')) {
			this.attr('src',src);
			this.loadVideo();
			apcore[0].ondurationchange = function(){
				apcore.apRun();
				apcore[0].currentTime = ap_rejd;
				apcore.play();
				$('#ap-loading-box').css('display','none');
			};	
		}else {
			return false;
		}
	}
	// 函数：apRun - 播放器开始运行及播放器主循环
	jQuery.fn.apRun = function(){
		// 初始化播放时间
		var numMax = ($(this)[0].duration / 60).toFixed(2);
			numMax = numMax.replace(/\./, ":");
		$('#ap-console-time').html('00:00 / '+ numMax +'');
		// 加载教程数据
		$('#ap-danmu-num span').html(getJsonLength(chatLib)-1);
		// 定义主循环
		ap_main = setInterval(function(){
			// 教程加载
			loaded = apcore[0].buffered.end(apcore[0].buffered.length-1);
			loaded = loaded/apcore[0].duration;
			loaded = (loaded*100)*($('#ap-console-jdbar').width()/100);
			$('#ap-console-jdbar-okbar').stop().animate({width:loaded+'px'},300);
			// 弹幕移动
			for(var o in chatLib){
				var showid = o;
				var showtext = chatLib[o][1];
					showtext = showtext = readDanmu(showtext);
				var showtime = (apcore[0].currentTime).toFixed(3);
					showtime = showtime.substr(0,showtime.length - 2);
					showtime = showtime*10;
				var showcolor = chatLib[o][2];
				var showtype = chatLib[o][3];
				var exist = false;
				var topNumb = 0;
				if (chatLib[o][0] == showtime && apcore[0].paused != true) {
					switch(showtype){
						case '1':
							var random = Math.ceil(Math.random()*danmuTopCube.length);
								random -= 1;
							var dleft = parseInt($('#ap-chatbox').css('width'));
						break;
						case '2':
							var random = 0;
							var dleft = ($('#ap-chatbox').width()/2)-((showtext.length*25)/2);
						break;
					}
					for (var i = 0; i < $('.ap-danmu').length; i++) {
						// 判断弹幕类型
						switch(showtype){
							case '1':
								if (parseInt($('.ap-danmu').eq(i).css('top')) == danmuTopCube[random]) {
									if (parseInt($('.ap-danmu').eq(i).css('left')) > 0) {
										dleft += $('.ap-danmu').eq(i).width();
										dleft += 4;
									}
								}
							break;
							case '2':
								if (parseInt($('.ap-danmu').eq(i).css('top')) == danmuTopCube[random]) {
									if (topNumb == danmuTopCube.length) {
										random == 0+topNumb;
									}else {
										if (random == danmuTopCube.length) {
											random == 0;
										}
										random += 1;
										topNumb ++;
									}
								}
							break;
						}
						if ($('.ap-danmu').eq(i).attr('dm-id') == showid) {
							exist = true;
						}
					}
					// 判断弹幕是否存在
					if (!exist) {
						// 创建弹幕DIV
						$('#ap-chatbox').append(setDanmu({
							'id':showid,
							'type':showtype,
							'class':'ap-danmu',
							'color':showcolor,
							'left':dleft,
							'top':danmuTopCube[random],
							'text':showtext
						}));
					}	
				}
			}
			if (!apcore[0].paused) {
				for (var i = 0; i < $('.ap-danmu').length; i++) {
					if (parseInt($('.ap-danmu:eq('+i+')').css('left')) < (-(500)) || $('.ap-danmu:eq('+i+')').css('opacity') <= 0) {
						$('.ap-danmu:eq('+i+')').remove();
					}else {
						switch($('.ap-danmu:eq('+i+')').attr('type')){
							case '1':
								// 常规横向滚动弹幕操作
								$('.ap-danmu:eq('+i+')').stop().animate({left:+(parseInt($('.ap-danmu:eq('+i+')').css('left')) - 10) + 'px'},100);
							break;
							case '2':
								// 顶部悬停弹幕操作
								$('.ap-danmu:eq('+i+')').css({opacity:$('.ap-danmu:eq('+i+')').css('opacity') - 0.02});
							break;
							case '3':
								// 炫彩弹幕操作
								
							break;
						}
						
					}
				}
			}
			// 即时更改播放器进度条
			if (ap_jdbar_off) {
				setJdbar(apcore,500);
			}
			// 即时判断播放器是否结束播放
			if (apcore[0].ended) {
				apcore.end();
			}
			// 即时判断播放器是否全屏
			if (ap_fullscreen) {
				$('#ap-player-bar').css({width:$(window).width()+'px',height:$(window).height()+'px',position:'absolute',top:"0px",left:"0px"});
			}
			// 即时更改播放器时间
			$('#ap-console-time').html(getTime(apcore));
		},100);
	}//end
jQuery.fn.apFound = function(){

}
jQuery.fn.play = function(){
	$('#ap-player-hide').css('background','rgba(0,0,0,0)');
	$('#ap-player-icon').css('opacity','0');
	$('#ap-console-play').children('i').removeClass('fa-play');
	$('#ap-console-play').children('i').addClass('fa-pause');
	this[0].play();
}
jQuery.fn.pause = function(){
	$('#ap-player-hide').css('background','rgba(0,0,0,0.5)');
	$('#ap-player-icon').css('opacity','1');
	$('#ap-console-play').children('i').addClass('fa-play');
	$('#ap-console-play').children('i').removeClass('fa-pause');
	this[0].pause();
}
jQuery.fn.paused = function(){
	if (this[0].paused) {
		return true;
	}else {
		return false;
	}
}
jQuery.fn.end = function(){
	console.log('教程结束了');
}
jQuery.fn.loadVideo = function(){
	this[0].load();
}
jQuery.fn.superColor = function(){

}
// END
// --------------------------------------------------------------------------

// AP 拓展函数定义
// --------------------------------------------------------------------------
	// 获取本地时间
	function getLocalTime(S) {     
	   return new Date(parseInt(S)).toLocaleString();     
	}
	// 定义获取网址参数函数
	function getUrlParam(name) {
		var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)");
		var r = window.location.search.substr(1).match(reg);
		if (r != null) return unescape(r[2]); return null;
	}
	// 从数据库获取弹幕文件
	function CL_POST(){}
	// 从服务器获取弹幕文件
	function CL_GET(dmid){
		console.log(dmid);

	}
	// 将弹幕保存至服务器
	function CL_SAVA(uval,uuid){
		$.ajax({
			url:"php/danmu.php",
			type:"post",
			data:{
				val:uval,
				uid:uuid
			},
			dataType:"html",
			async:false,
			success:function(result){
			}
		})
	}
	// 获取播放进度时间 (返回 00:00 格式)
	function getTime(obj){
		var numMax_n = (obj[0].duration / 60).toFixed(2);
			numMax_n = numMax_n.substr(0,numMax_n.length - 3);
			numMax_s = (obj[0].duration % 60).toFixed(2);
			numMax_s = numMax_s.substr(0,numMax_s.length - 3);
			if (numMax_n < 10) {
				numMax_n = "0"+ numMax_n;
			}
			if (numMax_s < 10) {
				numMax_s = "0"+ numMax_s;
			}
		var numMax = numMax_n + ":" + numMax_s;
			if (apcore[0].currentTime >= 60) {
				var n = (apcore[0].currentTime/60).toFixed(2);
					n = n.substr(0,n.length - 3);
					ns = n;
				if (n < 10) {
					n = "0"+ n;
				}
				var s = (apcore[0].currentTime - (ns*60)).toFixed(1);
					s = s.substr(0,s.length - 2);
					s = s.replace(/-/, "");
				if (s < 10) {
					s = "0"+ s;
				}
				var num = n + ":" + s;
			}else {
				var num = (apcore[0].currentTime).toFixed(1);
				num = num.substr(0,num.length - 2);
				if (num < 10) {
					num = "00:0"+num;
				}else{
					num = "00:"+num;
				}
			}
			return num +' / '+ numMax;
	}
	// 设置进度条
	function setJdbar(obj,speed){
		var barmax = obj[0].duration;
		var barcur = obj[0].currentTime;
		var barwidth = $('#ap-console-jdbar').width();
		var barvelue = (barcur/barmax).toFixed(3);
			barvelue = barvelue.substr(0,barvelue.length - 1);
			barvelue = (barvelue*100)*(barwidth/100);
		$('#ap-console-jdbar-btn').stop().animate({left:barvelue-2.5+'px'},speed);
	}
	// 获取鼠标当前坐标 (返回 Json 对象，包含 x , y 属性)
	function getMouse(event){ 
	    var e = window.event || arguments.callee.caller.arguments[0];
	    var scrollX = document.documentElement.scrollLeft || document.body.scrollLeft; 
	    var scrollY = document.documentElement.scrollTop || document.body.scrollTop; 
	    var x = e.pageX || e.clientX + scrollX; 
	    var y = e.pageY || e.clientY + scrollY; 
	 //    var cX= $('#ap-player-box')[0].getBoundingClientRect().left+document.documentElement.scrollLeft; 
		// var cY =$('#ap-player-box')[0].getBoundingClientRect().top+document.documentElement.scrollTop;
		// x = x-cX;
		// y = y-cY;
	    return {'x':x,'y':y};
	}
	// 清空弹幕
	function emptyDanmu(){
		$('#ap-chatbox').empty();
	}
	// 全屏函数
	function fullscreen(){  
	    elem=document.body;  
	    if(elem.webkitRequestFullScreen){  
	        elem.webkitRequestFullScreen();     
	    }else if(elem.mozRequestFullScreen){  
	        elem.mozRequestFullScreen();  
	    }else if(elem.requestFullScreen){  
	        elem.requestFullscreen();  
	    }else{  
	        //浏览器不支持全屏API或已被禁用  
	    }  
	}  
	// 退出全屏函数
	function exitFullscreen(){  
	    var elem=document;  
	    if(elem.webkitCancelFullScreen){  
	        elem.webkitCancelFullScreen();      
	    }else if(elem.mozCancelFullScreen){  
	        elem.mozCancelFullScreen();  
	    }else if(elem.cancelFullScreen){  
	        elem.cancelFullScreen();  
	    }else if(elem.exitFullscreen){  
	        elem.exitFullscreen();  
	    }else{  
	        //浏览器不支持全屏API或已被禁用  
	    }  
	}
	// 显示右键菜单
	function showMenu(e){
		ap_mouse = getMouse(e);
		$('#ap-mouse-rightkey').css({left:ap_mouse.x+'px',top:ap_mouse.y+'px',display:'block'});
	}
	// 隐藏菜单
	function hideMenu() {
	    $('#ap-mouse-rightkey').css('display','none');
	}
	// 弹出提示
	var tipsA,tipsB;
	function showTips(tipstext){
		if ($('#ap-player-tips').length > 0) {
			clearInterval(tipsA);clearInterval(tipsB);
			$('#ap-player-tips').remove();
		}
		$('#ap-player-bar').prepend('<div id="ap-player-tips"></div>');
		$('#ap-player-tips').html(tipstext);
		$('#ap-player-tips').css('top','calc(50% + 30px)');
		$('#ap-player-tips').stop().animate({top:(parseInt($('#ap-player-tips').css('top')) - 30) + 'px',opacity:'1'},200);
		tipsA = setTimeout(function() {
			$('#ap-player-tips').stop().animate({top:(parseInt($('#ap-player-tips').css('top')) - 60) + 'px',opacity:'0'},200);
			tipsB = setTimeout(function() {
				$('#ap-player-tips').remove();
			}, 200);
		}, 700);
	}
	// 弹幕过滤及转义
	function filterDanmu(string){
		string = string.replace(/\'/g,'%F001%'); // %F001% 单引号 '
		string = string.replace(/\"/g,'%F002%'); // %F002% 双引号 "
		string = string.replace(/\\/g,'%F003%'); // %F003% 反斜杠 \
		string = string.replace(/\//g,'%F004%');  // %F004%  斜杠  /
		string = string.replace(/{/g,'%F005%');  // %F005% 前括号 {
		string = string.replace(/}/g,'%F006%');  // %F006% 后括号 {
		string = string.replace(/\[/g,'%F007%');  // %F007% 前括号 [
		string = string.replace(/\]/g,'%F008%');  // %F008% 前括号 ]
		string = string.replace(/\,/g,'%F009%');  // %F009%  逗号  ,
		string = string.replace(/\:/g,'%F010%');  // %F010%  冒号  :
		return string;
	}
	// 弹幕反转义
	function readDanmu(string){
		string = string.replace(/%F001%/g,'\''); // %F001% 单引号 '
		string = string.replace(/%F002%/g,'\"'); // %F002% 双引号 "
		string = string.replace(/%F003%/g,'\\'); // %F003% 反斜杠 \
		string = string.replace(/%F004%/g,'/');  // %F004%  斜杠  /
		string = string.replace(/%F005%/g,'{');  // %F005% 前括号 {
		string = string.replace(/%F006%/g,'}');  // %F006% 后括号 {
		string = string.replace(/%F007%/g,'[');  // %F007% 前括号 [
		string = string.replace(/%F008%/g,']');  // %F008% 前括号 ]
		string = string.replace(/%F009%/g,',');  // %F009%  逗号  ,
		string = string.replace(/%F010%/g,':');  // %F010%  冒号  :
		return string;
	}
	// 绘制弹幕拾色器
	function createCp(){
		var sort = $('#ap-danmu-color-cube li').length;
		for (var i = 0; i < sort; i++) {
			$('#ap-danmu-color-cube li').eq(i).css('background',$('#ap-danmu-color-cube li').eq(i).attr('ap-color'));
		}
	}
	// 获取JSON对象长度
	function getJsonLength(jsonData){  
	    var jsonLength = 0;  
	    for(var item in jsonData){  
	    	jsonLength++;    
	    }    
	    return jsonLength;  
	}
	// 获取教程地址
	function getVideoUrl(){
		return 'v/The Weeknd - False Alarm_hd.mp4';
	}
	// 教程地址blob加密
	function blobVideoSrc(src,key){
		var xhr = new XMLHttpRequest();
		xhr.open('get',src + '?key=' + key + '&bility=' + md5(Math.random()),true);
		xhr.responseType = 'blob';
		xhr.setRequestHeader("If-Modified-Since","0");
		xhr.onreadystatechange = function() {
	    	if (this.readyState==4 && this.status == 200) {
	        	var blob = this.response;
	        	console.log(blob);
	        	apcore[0].onload = function(e) {
	            	URL.revokeObjectURL(apcore[0].src);
	        	};
	        	apcore[0].src = URL.createObjectURL(blob);
	    	}
	    }
		xhr.send(null);
	}//end
	// 创建弹幕盒子
	function setDanmu(arr){
		// 标头start
		var result = '<div ';
		// Attr
		result += 'dm-id="' + arr['id'] + '" ';
		result += 'type="' + arr['type'] + '" ';
		result += 'class="' + arr['class'] + '" ';
		// Style
		result += 'style="';
		result += 'color:'+arr['color']+';';
		result += 'text-shadow:#666 1px 0 0,#666 0 1px 0,#666 -1px 0 0,#666 0 -1px 0;font-size:22px;font-weight:600;margin:5px;white-space:pre;position:absolute;display:inline-block;'
		result += 'left:'+arr['left']+'px;';
		result += 'top:'+arr['top']+'px;';
		result += '" ';
		// 标头end
		result += '>'+arr['text']+'</div>'
		return result;
	}
// END
// --------------------------------------------------------------------------

// AP 播放器操作
// --------------------------------------------------------------------------
	// 发送弹幕
	$('#ap-danmu-submit').click(function(){
		var value = $('#ap-danmu-input').val();
		var text = $('#ap-danmu-input').val();
		var color = $('#ap-danmu-color-box').attr('ap-color');
		var type = 0;
		switch($('.ap-danmu-cog-type input:radio:checked').val()){
			case "1":
				type = '1';
			break;
			case "2":
				type = '2';
			break;
		}
		var topNumb = 0;
		if (value.length > 12) {
			showTips('弹幕不得超过12个字符');
			return;
		}else if (value.length < 2) {
			showTips('弹幕不得小于2个字符');
			return;
		}
		var ap_time = (apcore[0].currentTime).toFixed(3);
			ap_time = ap_time.substr(0,ap_time.length - 2);
			ap_time = ap_time*10;
		value = filterDanmu(value);
		value = ',"'+(new Date()).valueOf()+'":["'+ap_time+'","'+value+'","'+color+'","'+type+'"]';
		CL_SAVA(value,'1001');
		switch(type){
			case '1':
				var random = Math.ceil(Math.random()*danmuTopCube.length);
					random -= 1;
				var dleft = parseInt($('#ap-chatbox').css('width'));
			break;
			case '2':
				var random = 0;
				var dleft = ($('#ap-chatbox').width()/2)-((text.length*25)/2);
			break;
		}
		for (var i = 0; i < $('.ap-danmu').length; i++) {
			// 判断弹幕类型
			switch(type){
				case '1':
					if (parseInt($('.ap-danmu').eq(i).css('top')) == danmuTopCube[random]) {
						if (parseInt($('.ap-danmu').eq(i).css('left')) > 0) {
							dleft += $('.ap-danmu').eq(i).width();
						}	
					}
				break;
				case '2':
					if (parseInt($('.ap-danmu').eq(i).css('top')) == danmuTopCube[random]) {
						if (topNumb == danmuTopCube.length) {
							random == 0+topNumb;
						}else {
							if (random == danmuTopCube.length) {
								random == 0;
							}
							random += 1;
							topNumb ++;
						}
					}
				break;
			}
		}
		console.log(dleft);
		$('#ap-chatbox').append(setDanmu({
			'id':'new',
			'type':type,
			'class':'ap-danmu',
			'color':color,
			'left':dleft,
			'top':danmuTopCube[random],
			'text':text
		}));
		$('#ap-danmu-input').val('');
		$('#ap-danmu-input').blur();
		$('#ap-danmu-num span').html(parseInt($('#ap-danmu-num span').html())+1);
	});
	// 通过点击控制播放器开始与暂停
	$('#ap-player-hide,#ap-console-play').click(function(){
		// 教程播放暂停切换
		if (apcore.paused()) {
			apcore.play();
		}else {
			apcore.pause();
		}
	});//end
	// 通过点击进度条切换进度
	$('#ap-console-jdbar').click(function(){
		var qhX	= $('#ap-console-jdbar')[0].getBoundingClientRect().left+document.documentElement.scrollLeft;
			qhX = ap_mouse.x - qhX;
		$('#ap-console-jdbar-btn').stop().css('left',(qhX-2.5)+'px');
			qhX = qhX / $('#ap-console-jdbar').width();
			qhX = qhX.toFixed(2);
		if (qhX >= 1) {
			apcore.end();
			return;
		}
			qhX = qhX * apcore[0].duration;
		apcore[0].currentTime = qhX;
		emptyDanmu();
		apcore.play();
	});//end
	// 通过点击控制教程全屏切换
	$('#ap-console-full').click(function(){
		if ($('#ap-player-bar').css('position') == 'absolute') {
			ap_fullscreen = false;
			$('#ap-player-bar').css({width:'860px',height:'620px',position:'relative',top:"0px",left:"0px"});
			$('#ap-console-full').children('i').removeClass('fa-compress').addClass('fa-arrows-alt');
			exitFullscreen();
			setJdbar(apcore,10);
		}else {
			ap_fullscreen = true;
			$('#ap-player-bar').css({width:$(window).width()+'px',height:$(window).height()+'px',position:'absolute',top:"0px",left:"0px"});
			$('#ap-console-full').children('i').removeClass('fa-arrows-alt').addClass('fa-compress');
			fullscreen();
			setJdbar(apcore,10);
			setTimeout(function() {
				setJdbar(apcore,10);
			}, 10);
		}
		emptyDanmu();
	});//end
	// 切换教程清晰度(仅限教程有多清晰度源时使用)
	$('#ap-console-clarity li').click(function(){
		switch($(this).html()){
			case '超清':
				apcore.reRun('v/'+ap_video_name+'_sc.mp4');
				$('#ap-console-clarity-txt').html($(this).html());
				break;
			case '高清':
				apcore.reRun('v/'+ap_video_name+'_hd.mp4');
				$('#ap-console-clarity-txt').html($(this).html());
				break;
			case '流畅':
				apcore.reRun('v/'+ap_video_name+'_lc.mp4');
				$('#ap-console-clarity-txt').html($(this).html());
				break;
		}
	});//end
	// 控制台 弹幕关闭按钮
	$('#ap-danmu-switch-box').click(function(){
		if (ap_switch) {
			ap_switch = false;
			$('#ap-danmu-switch').stop().animate({marginLeft:'25px'},300);
			$('#ap-danmu-switch').css({background:'#454545',color:'#999'});
			$('#ap-chatbox').css('display','none');
		}else {
			ap_switch = true;
			$('#ap-danmu-switch').stop().animate({marginLeft:'0'},300);
			$('#ap-danmu-switch').css({background:'#336699',color:'#fff'});
			$('#ap-chatbox').css('display','block');
		}
	});//end
	// 开启弹幕拾色器
	$('#ap-danmu-color-box').mouseover(function(){
		$('#ap-danmu-color-cube').show();
		$('#ap-danmu-cog-cube').hide();
	});
	// 关闭弹幕拾色器
	$('#ap-danmu-color-cube').mouseout(function(){
		$('#ap-danmu-color-cube').hide();
	});
	// 当点击弹幕拾色器
	$('#ap-danmu-color-cube li').click(function(){
		var color = $(this).attr('ap-color');
		$('#ap-danmu-color-box').css('background',color);
		$('#ap-danmu-color-box').attr('ap-color',color);
		$('#ap-danmu-color-cube').css('display','none');
	});
	// 开启弹幕设置
	$('#ap-danmu-cog-box').mouseover(function(){
		$('#ap-danmu-cog-cube').show();
		$('#ap-danmu-color-cube').hide();
	});
	// 关闭弹幕设置
	$('#ap-danmu-cog-cube').mouseout(function(){
		$('#ap-danmu-cog-cube').hide();
	});

	//	当鼠标离开播放器区域
	$('#ap-player-bar').mouseout(function(){
		if (!apcore.paused()) {
			consoleout = setTimeout(function() {
				$('#ap-console').stop().animate({top:'0px'},300);
			}, 1000);
		}
	});//end
	//	当鼠标进入播放器区域
	$('#ap-player-bar').mouseover(function(){
		if (!apcore.paused() || apcore[0].ended) {
			clearTimeout(consoleout);
			$('#ap-console').stop().animate({top:'-33px'},300);
		}
	});//end
	// 当鼠标在播放器区域移动
	$('#ap-player-bar').mousemove(function(){
		clearInterval(autoConsole);
		if ($('#ap-console').css('top') == '0px' || $('#ap-console').css('top') == '-33px') {
			$('#ap-console').stop().animate({top:'-33px'},300);
			if (!inConsole && !apcore.paused()) {
				autoConsole = setTimeout(function() {
					$('#ap-console').stop().animate({top:'0px'},300);
				}, 3000);
			}
		}
	});//end
	// 当鼠标进入音量区域
	$('#ap-console-volume').mouseover(function(){
		$('#ap-console-volume-box').css('display','block');
	});
	// 当鼠标离开音量区域
	$('#ap-console-volume').mouseout(function(){
		if (ap_volume_off) {
			$('#ap-console-volume-box').css('display','none');
		}
	});
	// 当鼠标进入控制台区域
	$('#ap-console').mouseover(function(){
		inConsole = true;
	});
	// 当鼠标离开控制台区域
	$('#ap-console').mouseout(function(){
		inConsole = false;
	});
	// 当进度条按钮被按下
	$('#ap-console-jdbar-btn').mousedown(function(e){
		// 鼠标左键
		if (e.button == 0) {
			ap_jdbar_off = false;
		}
	});//end
	// 当音量按钮被按下
	$('#ap-console-volume-btn').mousedown(function(e){
		// 鼠标左键
		if (e.button == 0) {
			ap_volume_off = false;
		}
	});//end
	// 当鼠标移动到拾色器中
	$('#ap-danmu-color-cube li').mouseover(function(){
		var color = $(this).attr('ap-color');
		$('#ap-danmu-color-show').css('color',color);
		$('#ap-danmu-color-text').val(color);
		if (color == '#333333') {
			$('#ap-danmu-color-show').css('text-shadow','none');
		}else {
			$('#ap-danmu-color-show').css('text-shadow','#333 1px 0 0,#333 0 1px 0,#333 -1px 0 0,#333 0 -1px 0');
		}

	});
	// 鼠标移动事件
	$(window).mousemove(function(){
		ap_mouse = getMouse();
		// 进度条：
		if (!ap_jdbar_off) {
			var cX= $('#ap-console-jdbar')[0].getBoundingClientRect().left+document.documentElement.scrollLeft; 
				cX = ap_mouse.x - cX;
			if (cX > -(2.5) && cX <= $('#ap-console-jdbar').width()) {
				$('#ap-console-jdbar-btn').stop().css('left',(cX-2.5)+'px');
			}
		}
		// 进度条标记：
		var jdbjX= $('#ap-console-jdbar')[0].getBoundingClientRect().left+document.documentElement.scrollLeft; 
			jdbjX = ap_mouse.x - jdbjX;
		if (jdbjX > -(2.5) && jdbjX <= $('#ap-console-jdbar').width()) {
			$('#ap-console-jdbar-beacon').stop().css('left',(jdbjX-1)+'px');
		}
		// 音量：
		if (!ap_volume_off) {
			var cY= $('#ap-console-volume-bar')[0].getBoundingClientRect().top+document.documentElement.scrollTop; 
				cY = ap_mouse.y - cY;
			if (cY > -(2.5) && cY <= $('#ap-console-volume-bar').height()) {
				$('#ap-console-volume-btn').stop().css('top',(cY-2.5)+'px');

			}else if (cY < -(2.5)) {
				cY = 0;
			}else if (cY >= $('#ap-console-volume-bar').height()) {
				cY = $('#ap-console-volume-bar').height();
			}
			var vnum = (cY)/(80/100);
				vnum = 100-vnum;
				vnum = Math.round(vnum);
			if (vnum > 100) {
				vnum=100
			}else if (vnum > 50) {
				$('#ap-console-volume i').removeClass('icon-volume-down').addClass('icon-volume-up');
			}else if (vnum <= 50 && vnum > 0) {
				$('#ap-console-volume i').removeClass('icon-volume-up').addClass('icon-volume-down');
			}else if (vnum <= 0) {
				$('#ap-console-volume i').removeClass('icon-volume-down').addClass('icon-volume-off');
			}
			$('#ap-console-volume-text').html(vnum);
			apcore[0].volume = vnum/100;
		}
	});
// 鼠标抬起事件
$(window).mouseup(function(e){
	// 左键
	if (e.button == 0) {
		// 进度条:
		if (!ap_jdbar_off) {
			var jdbar = parseInt($('#ap-console-jdbar-btn').css('left')) + 2.5;
				jdbar = (jdbar / $('#ap-console-jdbar').width()).toFixed(3);
				jdbar = jdbar.substr(0,jdbar.length - 1);
				if (jdbar >= 1) {
					apcore.end();
					return;
				}
				jdbar = apcore[0].duration*jdbar;
			apcore[0].currentTime = jdbar;
			ap_jdbar_off = true;
			emptyDanmu();
			apcore.play();
		}
		// 音量
		if (!ap_volume_off) {
			$('#ap-console-volume-box').css('display','none');
			ap_volume_off = true;
		}		
	}
	// 右键
	if (e.button == 0) {
		
	}
	// 通用：
	hideMenu();
});
// 自定义右键
$('#ap-player-hide').contextmenu(function(e){
	//取消默认的浏览器自带右键 很重要！！
	e.preventDefault(e);
	showMenu(e);
});
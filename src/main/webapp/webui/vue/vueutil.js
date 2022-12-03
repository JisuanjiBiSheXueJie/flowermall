Date.prototype.format=function(fmt){
    let o = {
        "M+" : this.getMonth()+1,                 //月份
        "d+" : this.getDate(),                    //日
        "H+" : this.getHours(),                   //小时
        "m+" : this.getMinutes(),                 //分
        "s+" : this.getSeconds(),                 //秒
        "q+" : Math.floor((this.getMonth()+3)/3), //季度
        "S"  : this.getMilliseconds()             //毫秒
    };
    if(/(y+)/.test(fmt))
        fmt=fmt.replace(RegExp.$1, (this.getFullYear()+"").substr(4 - RegExp.$1.length));
    for(let k in o) {
        if (new RegExp("(" + k + ")").test(fmt))
            fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
    }
    return fmt;
};

let VueUtil=function (vue) {

    this.http=vue.$http;
    this.alert=vue.$alert;
    this.confirm=vue.$confirm;
    this.message=vue.$message;

    this.isDuringDate=function(begdateStr,enddateStr){

        let curDate=new Date(),
            begdate=new Date(begdateStr),
            enddate=new Date(enddateStr);
        if (curDate>=begdate&&curDate<=enddate)
            return true;
        return false;

    },
        this.isPasted=function(begdateStr,enddateStr){

            let curDate=new Date(),
                begdate=new Date(begdateStr),
                enddate=new Date(enddateStr);
            if (curDate>enddate)
                return true;
            return false;

        };



}
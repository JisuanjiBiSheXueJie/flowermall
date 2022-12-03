package com.daowen.controller;

import com.daowen.util.JsonResult;
import com.daowen.util.YiqingUtil;
import com.daowen.vo.EpiOverView;
import com.daowen.vo.Epidata;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
public class YiqingController {


    @ResponseBody
    @PostMapping("/admin/yiqing/epiov")
    public JsonResult  getEpiOverView(){
        EpiOverView epiOverView = YiqingUtil.getEpiOverView();
        return JsonResult.success(1,"成功",epiOverView);
    }

    @ResponseBody
    @PostMapping("/admin/yiqing/chinaepi")
    public JsonResult getChinaEpiData(){

        return JsonResult.success(1,"成功",YiqingUtil.getEpiData("中国"));
    }


}

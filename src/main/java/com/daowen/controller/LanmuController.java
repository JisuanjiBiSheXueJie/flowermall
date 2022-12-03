package com.daowen.controller;

import java.util.List;
import java.util.HashMap;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.daowen.util.JsonResult;
import com.daowen.vo.LanmuContentVo;
import com.daowen.vo.LanmuVo;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import jdk.nashorn.internal.scripts.JS;
import org.apache.tomcat.util.buf.C2BConverter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import com.daowen.entity.*;
import com.daowen.service.*;
import com.daowen.ssm.simplecrud.SimpleController;
import com.daowen.webcontrol.PagerMetal;

/**************************
 *
 * 板块管理控制
 *
 */
@RestController
public class LanmuController extends SimpleController {





    @PostMapping("/admin/lanmu/load")
    public JsonResult load() {
        String id=request.getParameter("id");
        if (id == null)
            return JsonResult.error(-1,"参数异常");
        LanmuVo lanmu=lanmuSrv.loadPlus(new Integer(id));

        return JsonResult.success(1,"获取板块信息成功",lanmu);
    }


    @PostMapping("/admin/lanmu/info")
    public JsonResult info() {
        String id=request.getParameter("id");
        if (id == null)
            return JsonResult.error(-1,"参数异常");
        LanmuVo lanmu=lanmuSrv.loadPlus(new Integer(id));

        return JsonResult.success(1,"获取板块信息成功",lanmu);
    }




    @PostMapping("/admin/lanmu/delete")
    public JsonResult delete() {
        String id=request.getParameter("id");
        if (id == null)
            return JsonResult.error(-1,"参数异常");

        lanmuSrv.deleteLanmu(Integer.parseInt(id));

        return JsonResult.success(1,"删除成功");
    }



    @PostMapping("/admin/lanmu/save")
    public JsonResult save() {

        //获取名称
        String name = request.getParameter("name");
        String bannerurl=request.getParameter("bannerurl");
        String type=request.getParameter("type");
        SimpleDateFormat sdflanmu = new SimpleDateFormat("yyyy-MM-dd");
        Lanmu lanmu = new Lanmu();
        // 设置名称
        lanmu.setName(name == null ? "" : name);
        lanmu.setBannerurl(bannerurl==null?"":bannerurl);
        if(type!=null)
            lanmu.setType(Integer.parseInt(type));
        else
            lanmu.setType(1);

        //产生验证
        Boolean validateresult = lanmuSrv.isExist("where name='" + name + "'");
        if (validateresult) {
           return JsonResult.error(-1,"已存在的板块名称");
        }
        lanmuSrv.save(lanmu);
        return JsonResult.success(1,"保存成功");
    }
    @PostMapping("/admin/lanmu/update")
    public JsonResult update() {
        String forwardurl = request.getParameter("forwardurl");
        String id = request.getParameter("id");
        if (id == null)
            return JsonResult.error(-1,"id不能为空");
        Lanmu lanmu = lanmuSrv.load(new Integer(id));
        if (lanmu == null)
            return JsonResult.error(-2,"不合法的数据");
        //获取名称
        String name = request.getParameter("name");
        String type = request.getParameter("type");
        String bannerurl=request.getParameter("bannerurl");
        SimpleDateFormat sdflanmu = new SimpleDateFormat("yyyy-MM-dd");
        if(type!=null)
            lanmu.setType(Integer.parseInt(type));
        else
            lanmu.setType(1);
        lanmu.setName(name);
        lanmu.setBannerurl(bannerurl==null?"":bannerurl);
        lanmuSrv.update(lanmu);
        return JsonResult.success(1,"更新成功");
    }


    @PostMapping("/admin/lanmu/list")
    public JsonResult list() {

        HashMap<String,Object> map=new HashMap<>();

        String name = request.getParameter("name");

        if (name != null)
            map.put("name",name);
        //
        int pageindex = 1;
        int pagesize = 10;
        // 获取当前分页
        String currentpageindex = request.getParameter("currentpageindex");
        // 当前页面尺寸
        String currentpagesize = request.getParameter("pagesize");
        // 设置当前页
        if (currentpageindex != null)
            pageindex = new Integer(currentpageindex);
        // 设置当前页尺寸
        if (currentpagesize != null)
            pagesize = new Integer(currentpagesize);

        List<LanmuVo> listlanmu = lanmuSrv.getEntityPlus(map);

        return JsonResult.success(1,"获取板块信息",listlanmu);
    }

    @PostMapping("/admin/lanmu/cascadelist")
    public JsonResult CascadeList(){
        HashMap<String,Object> map=new HashMap<>();

        String name = request.getParameter("name");

        if (name != null)
            map.put("name",name);


        List<LanmuVo> listLanmu = lanmuSrv.getEntityPlus(map);
        JSONArray jsonArray=new JSONArray();
        if(listLanmu!=null)
           listLanmu.forEach(c->{
            JSONObject jsonObject=new JSONObject();
            jsonObject.put("value",c.getId());
            jsonObject.put("label",c.getName());
            if(c.getSubtypes()!=null){
                JSONArray array = new JSONArray();
                c.getSubtypes().forEach(subtype->{
                    JSONObject cobj=new JSONObject();
                    cobj.put("label",subtype.getName());
                    cobj.put("value",subtype.getId());
                    array.add(cobj);
                    jsonObject.put("children",array);
                });
            }
            jsonArray.add(jsonObject);
        });

        return JsonResult.success(1,"获取成功",jsonArray);



    }


    @GetMapping("/admin/lanmu/content/{id}")
    public JsonResult getContent(@PathVariable("id") String id){
        if(id==null||id=="")
            return JsonResult.error(-1,"板块编号不合法");
        int nId=Integer.parseInt(id);
        LanmuContentVo lanmuVo=lanmuSrv.getContent(nId);
        if(lanmuVo==null||lanmuVo.getContent()==null)
            return JsonResult.error(-2,"没有找到板块内容");

        return JsonResult.success(1,"",lanmuVo);

    }


    @Autowired
    private LanmuService lanmuSrv = null;


}

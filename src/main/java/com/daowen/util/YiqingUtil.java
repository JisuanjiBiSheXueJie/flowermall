package com.daowen.util;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.daowen.vo.Epidata;
import com.daowen.vo.EpiOverView;

import org.jsoup.Connection;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class YiqingUtil {



    public static JsonResult  getData(){
        Document document = null;
        String url="https://c.m.163.com/ug/api/wuhan/app/data/list-total";
        try {

            Connection conn= Jsoup.connect(url);
            conn.header("authority","c.m.163.com");
            conn.header("accept"," text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9");
            conn.header("Accept-Encoding","gzip, deflate, br");
            conn.header("user-agent","Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.198 Safari/537.36");
            conn.header("Cookie","_ntes_nuid=aa3a8b61576b0b55c15139220c21e8df; _ntes_nnid=f3c3c56f1c85bc171240ea876d58ef18,1640236115563");
            conn.ignoreContentType(true);
            document = conn.get();

        } catch (IOException e) {

            e.printStackTrace();

        }
        if(document==null)
            return JsonResult.error(-1,"获取数据异常");
        String text=document.text();
        if(text=="")
            return JsonResult.error(-2,"返回异常");
        JSONObject jsonObject = JSONObject.parseObject(text);
        JSONObject data = jsonObject.getJSONObject("data");
        if(data==null)
            return JsonResult.error(-3,"数据格式错误");

        return JsonResult.success(1,"成功",data);

    }


    public static EpiOverView getEpiOverView(){
        JsonResult result=getData();
        if(result==null)
            return null;
        JSONObject jsonData= (JSONObject) result.getData();
        if(jsonData==null)
            return null;
      JSONObject joTotal=jsonData.getJSONObject("chinaTotal").getJSONObject("total");
      JSONObject joToday=jsonData.getJSONObject("chinaTotal").getJSONObject("today");
      JSONObject joExt=jsonData.getJSONObject("chinaTotal").getJSONObject("extData");

      EpiOverView epiOverView=new EpiOverView();

      epiOverView.setInput(joTotal.getInteger("input"));
      epiOverView.setInputIncrease(joToday.getInteger("input"));

      epiOverView.setNoSymptom(joExt.getInteger("noSymptom"));
      epiOverView.setInputIncrease(joExt.getInteger("incrNoSymptom"));

      epiOverView.setDead(joTotal.getInteger("dead"));
      epiOverView.setDeadIncrease(joToday.getInteger("dead"));

      epiOverView.setHeal(joTotal.getInteger("heal"));
      epiOverView.setHealIncrease(joToday.getInteger("heal"));

      epiOverView.setConfirm(joTotal.getInteger("confirm"));
      epiOverView.setConfirmIncrease(joToday.getInteger("confirm"));

      epiOverView.setNowConfirm(epiOverView.getConfirm()-epiOverView.getDead()-epiOverView.getHeal());
      epiOverView.setNowConfirmIncrease(epiOverView.getConfirmIncrease()-epiOverView.getDeadIncrease()-epiOverView.getHealIncrease());

      return epiOverView;
    }


    public static JsonResult getChinaEpiData(){

        JsonResult result=getData();
        if(result==null)
            return null;
        JSONObject jsonData= (JSONObject) result.getData();
        if(jsonData==null)
            return null;
        JSONArray jaAreaTree=jsonData.getJSONArray("areaTree");
        JSONArray data=null;
        for(int i=0; i<jaAreaTree.size();i++) {
            JSONObject current=jaAreaTree.getJSONObject(i);
            if(current!=null&&"中国".equals(current.getString("name"))){
                data=current.getJSONArray("children");
                break;
            }
        }
        return JsonResult.success(1,"成功",data);
    }

    public static List<Epidata> getEpiData(String name){

        JsonResult result=getData();
        if(result==null)
            return null;
        JSONObject jsonData= (JSONObject) result.getData();
        if(jsonData==null)
            return null;
        JSONArray jaAreaTree=jsonData.getJSONArray("areaTree");
        JSONArray data=null;
        for(int i=0; i<jaAreaTree.size();i++) {
            JSONObject current=jaAreaTree.getJSONObject(i);
            if(current!=null&&name.equals(current.getString("name"))){
                data=current.getJSONArray("children");
                break;
            }
        }
        return  getEpidata(data,name);
    }

    private static List<Epidata> getEpidata(JSONArray data,String name){

        List<Epidata> listEpidata=new ArrayList<>();
        if(data==null)
            return listEpidata;
        for(int i=0;i<data.size();i++){

            JSONObject joTotal=data.getJSONObject(i).getJSONObject("total");
            JSONObject joToday=data.getJSONObject(i).getJSONObject("today");
            JSONArray children=data.getJSONObject(i).getJSONArray("children");
            Epidata ed=new Epidata();
            ed.setName(data.getJSONObject(i).getString("name"));
            ed.setConfirm(joTotal.getInteger("confirm"));
            ed.setDead(joTotal.getInteger("dead"));
            ed.setHeal(joTotal.getInteger("heal"));
            ed.setNowConfirm(ed.getConfirm()-ed.getDead()-ed.getHeal());
            if(children!=null&&children.size()>0){
               ed.setChildren(getEpidata(children,ed.getName()));
            }
            listEpidata.add(ed);
        }
        return listEpidata;
    }


    public static void main (String []agrs){
        //JsonResult data=YiqingUtil.getData();
        //EpiOverView data = YiqingUtil.getEpiOverView();
        JsonResult data=YiqingUtil.getChinaEpiData();
        System.out.println("data="+data);
    }

}

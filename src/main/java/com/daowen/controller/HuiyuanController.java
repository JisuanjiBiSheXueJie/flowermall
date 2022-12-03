package com.daowen.controller;

import java.text.MessageFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.alibaba.fastjson.JSONObject;
import com.daowen.entity.Chongzhirec;
import com.daowen.service.ChongzhirecService;
import com.daowen.ssm.simplecrud.SimpleController;
import com.daowen.util.*;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import com.daowen.entity.Huiyuan;
import com.daowen.service.HuiyuanService;


@Controller
public class HuiyuanController extends SimpleController {

	@Autowired
	private HuiyuanService huiyuanSrv=null;
	@Autowired
	private ChongzhirecService chongzhirecSrv=null;


	@RequestMapping("/admin/huiyuan/chongzhi")
	public void chongzhi()  {

		String hyid=request.getParameter("hyid");
		String amount=request.getParameter("amount");
		Chongzhirec chongzhirec=new Chongzhirec();
		chongzhirec.setCreatetime(new Date());
		chongzhirec.setDdno(SequenceUtil.buildSequence("D"));
		chongzhirec.setPaytype(1);
		chongzhirec.setState(1);
		chongzhirec.setHyid(new Integer(hyid));
		chongzhirec.setAmount(new Integer(amount));
		chongzhirecSrv.save(chongzhirec);
		AlipayUtil alipayUtil=new AlipayUtil(request,response);
		AlipayUtil.PaymentOrder po = new AlipayUtil.PaymentOrder("会员充值",amount, chongzhirec.getDdno());
		po.setReturnurl("http://localhost:8080/"+request.getContextPath()+"/admin/huiyuan/czres");
		alipayUtil.pay(po);

	}
	@RequestMapping("/admin/huiyuan/czres")
	public String czres() {

		AlipayUtil alipayUtil=new AlipayUtil(request,response);
		String ddno=alipayUtil.getOrderno();
		HashMap map = new HashMap();
		map.put("ddno",ddno);
		Chongzhirec chongzhirec=chongzhirecSrv.loadPlus(map);
		if(chongzhirec==null)
			return "redirect:/e/payfail.jsp";
		chongzhirec.setState(2);
		chongzhirecSrv.update(chongzhirec);
		Huiyuan huiyuan = huiyuanSrv.load(chongzhirec.getHyid());
		if (huiyuan!= null) {
			huiyuan.setYue(huiyuan.getYue() + chongzhirec.getAmount());
			huiyuanSrv.update(huiyuan);
			request.getSession().setAttribute("huiyuan", huiyuan);
		}
		return "redirect:/e/paysucc.jsp";

	}


	@RequestMapping("/admin/huiyuanmanager.do")
	public void mapping(HttpServletRequest request, HttpServletResponse response) {
		this.mappingMethod(request, response);
	}

	@ResponseBody
	@PostMapping("/admin/huiyuan/forgetpw")
	public JsonResult forgetpw() {
		String accountname = request.getParameter("accountname");
		Huiyuan h = huiyuanSrv.load("where accountname='" + accountname + "'");
		if (h == null)
			return JsonResult.error(-1, "不存在的账号");
		JSONObject jsonObject = new JSONObject();
		jsonObject.put("url", "/forgetpwnext.jsp?id=" + h.getId());
		return JsonResult.success(1, "", jsonObject);
	}


	@ResponseBody
	@PostMapping("/admin/huiyuan/sendpwemail")
	public JsonResult sendpwemail() {
		String id = request.getParameter("id");
		Huiyuan h = huiyuanSrv.load("where id=" + id);
		if (h == null)
			return JsonResult.error(-1, "不存在的账号");
		MimeMessageDescription mmd = new MimeMessageDescription();
		mmd.setReceAccount(h.getEmail());
		mmd.setReceAccountRemark(h.getName());
		mmd.setSubject("忘记密码-密码重置邮件");
		mmd.setContent(MessageFormat.format("亲忘记密码<a href=\"http://localhost:8080{0}/e/resetpw.jsp?id={1,number,#}\">重置密码</a>", request.getContextPath(), h.getId()));
		boolean res = MailUtil.send(mmd);
		if (res)
			return JsonResult.success(1, "");
		else
			return JsonResult.error(-2, "发送失败,请检查邮箱是否正常");
	}

	public void resetpw() {
		String repassword1 = request.getParameter("repassword1");
		String repassword2 = request.getParameter("repassword2");
		String forwardurl = request.getParameter("forwardurl");
		String errorurl = request.getParameter("errorurl");
		String id = request.getParameter("id");
		if (id == null || id == "")
			return;
		Huiyuan huiyuan = huiyuanSrv.load(new Integer(id));
		if (huiyuan == null) {
			request.setAttribute("errormsg", "<label class='error'>账户不成立</label>");
			forward(errorurl);
			return;
		}
		huiyuan.setPassword(repassword1);
		huiyuanSrv.update(huiyuan);
		request.getSession().setAttribute("huiyuan", huiyuan);
		forward(forwardurl);


	}



	@ResponseBody
	@PostMapping("/admin/huiyuan/modifypaypw")
	public JsonResult modifyPaypw() {

		String paypwd = request.getParameter("paypwd");
		String errorurl = request.getParameter("errorurl");
		String forwardurl = request.getParameter("forwardurl");
		String repassword1 = request.getParameter("repassword1");
		String id = request.getParameter("id");
		if (id == null || id == "")
			return JsonResult.error(-1, "编号不能为空");
		Huiyuan huiyuan = huiyuanSrv.load(new Integer(id));

		if (huiyuan == null)
			return JsonResult.error(-2, "不存在的账号信息");
		if (!huiyuan.getPaypwd().equals(paypwd))
			return JsonResult.error(-3, "原始支付密码不正确");
		huiyuan.setPaypwd(repassword1);
		huiyuanSrv.update(huiyuan);
		return JsonResult.success(1, "更新成功");
	}





	@ResponseBody
	@RequestMapping("/admin/huiyuan/exit")
	public JsonResult exit() {

		if (request.getSession().getAttribute("huiyuan") != null) {

			System.out.println("系统退出");
			request.getSession().removeAttribute("huiyuan");

		}

		return JsonResult.success(1, "成功退出");


	}

	@ResponseBody
	@PostMapping("/admin/huiyuan/login")
	private JsonResult login() {

		String accountname = request.getParameter("accountname");
		String password = request.getParameter("password");

		String filter = MessageFormat.format("where accountname=''{0}'' and password=''{1}''", accountname,password);
		Huiyuan huiyuan = (Huiyuan) huiyuanSrv.load(filter);
		if (huiyuan == null)
			return JsonResult.error(-1, "系统账户和密码不匹配");
		if (!huiyuan.getPassword().equals(password))
			return JsonResult.error(-2, "密码错误");
		huiyuan.setLogtimes(huiyuan.getLogtimes() + 1);

		huiyuanSrv.update(huiyuan);
		request.getSession().setAttribute("huiyuan",huiyuan);
		return JsonResult.success(1, "成功登陆", huiyuan);

	}

	@ResponseBody
	@PostMapping("/admin/huiyuan/save")
	public JsonResult save() {
		String accountname = request.getParameter("accountname");
		String password = request.getParameter("password");
		String name = request.getParameter("name");
		String idcardno = request.getParameter("idcardno");
		String email = request.getParameter("email");
		String mobile = request.getParameter("mobile");
		String address = request.getParameter("address");
		String touxiang = request.getParameter("touxiang");
		String sex = request.getParameter("sex");
		String des = request.getParameter("des");
		if (huiyuanSrv.isExist("where accountname='" + accountname + "'"))
			return JsonResult.error(-1, "用户名已经存在");
		Huiyuan huiyuan = new Huiyuan();
		huiyuan.setAccountname(accountname == null ? "" : accountname);
		huiyuan.setPassword(password == null ? "" : password);
		huiyuan.setPaypwd(huiyuan.getPassword());
		if (mobile != null)
			huiyuan.setMobile(mobile);
		else
			huiyuan.setMobile(accountname);
		if (address != null)
			huiyuan.setAddress(address);
		if (sex != null)
			huiyuan.setSex(sex);
		else
			huiyuan.setSex("男");
		huiyuan.setNickname(accountname);
		huiyuan.setName(name);
        huiyuan.setTypeid(1);
		huiyuan.setRegdate(new Date());
		huiyuan.setIdcardno(idcardno == null ? "" : idcardno);
		huiyuan.setLogtimes(0);
		if (touxiang != null)
			huiyuan.setTouxiang(touxiang);
		else
			huiyuan.setTouxiang("/upload/nopic.jpg");
		huiyuan.setEmail(email == null ? "" : email);
		huiyuan.setStatus(1);
		huiyuan.setYue(0.0);
		huiyuan.setDes(des == null ? "" : des);
		huiyuanSrv.save(huiyuan);
		return JsonResult.success(1, "注册成功");

	}

	@ResponseBody
	@PostMapping("/admin/huiyuan/delete")
	public JsonResult delete() {
		String[] ids = request.getParameterValues("ids");
		if (ids == null)
			return JsonResult.error(-1, "编号不能为空");
		String where = " where id in(" + String.join(",", ids) + ")";
		huiyuanSrv.delete(where);
		return JsonResult.success(1, "删除成功");
	}

	@ResponseBody
	@PostMapping("/admin/huiyuan/update")
	public JsonResult update() {
		String id = request.getParameter("id");
		if (id == null)
			return JsonResult.error(-1, "编号不能为空");
		Huiyuan huiyuan = huiyuanSrv.load(new Integer(id));
		if (huiyuan == null)
			return JsonResult.error(-2, "账号不存在");
		String accountname = request.getParameter("accountname");
		String nickname = request.getParameter("nickname");
		String touxiang = request.getParameter("touxiang");
		String email = request.getParameter("email");
		String mobile = request.getParameter("mobile");
		String sex = request.getParameter("sex");
		String address = request.getParameter("address");
		String name = request.getParameter("name");
		String idcardno = request.getParameter("idcardno");
		String des=request.getParameter("des");
		if (accountname != null)
			huiyuan.setAccountname(accountname);
		huiyuan.setNickname(nickname == null ? "" : nickname);
		huiyuan.setTouxiang(touxiang == null ? "" : touxiang);
		huiyuan.setEmail(email == null ? "" : email);
		huiyuan.setMobile(mobile == null ? "" : mobile);
		huiyuan.setIdcardno(idcardno == null ? "" : idcardno);
		huiyuan.setSex(sex == null ? "" : sex);
		huiyuan.setAddress(address == null ? "" : address);
		huiyuan.setName(name == null ? "" : name);
		huiyuan.setDes(des==null?"":des);
		huiyuanSrv.update(huiyuan);
		return JsonResult.success(1, "更新成功");

	}

	@ResponseBody
	@PostMapping("/admin/huiyuan/modifypw")
	public JsonResult modifyPw() {

		String password = request.getParameter("password");
		String repassword1 = request.getParameter("repassword1");
		String id = request.getParameter("id");
		if (id == null || id == "")
			return JsonResult.error(-1, "编号不存在");
		Huiyuan huiyuan = huiyuanSrv.load("where id=" + id);
		if (huiyuan == null)
			return JsonResult.error(-2, "不存在的账号");

		if (!huiyuan.getPassword().equals(password))
			return JsonResult.error(-3, "原始密码不正确");
		huiyuan.setPassword(repassword1);
		huiyuanSrv.update(huiyuan);
		return JsonResult.success(1, "成功修改");


	}


	@ResponseBody
	@PostMapping("/admin/huiyuan/load")
	public JsonResult load() {
		//
		String id = request.getParameter("id");
		if (id == null || id == "")
			return JsonResult.error(-1, "编号不存在");
		Huiyuan huiyuan = huiyuanSrv.load("where id=" + id);
		if (huiyuan == null)
			return JsonResult.error(-2, "不存在的账号");
		return JsonResult.success(1,"成功",huiyuan);

	}



	@ResponseBody
	@PostMapping("/admin/huiyuan/info")
	public JsonResult info() {
		//
		String id = request.getParameter("id");
		String accountname = request.getParameter("accountname");
		if (id == null && accountname == null)
			return JsonResult.error(-1, "参数不存在");

		Huiyuan huiyuan =null;
		if(id!=null&&id!=""){
		    huiyuan=huiyuanSrv.loadPlus(new Integer(id));
		  if (huiyuan == null)
			return JsonResult.error(-2, "不存在的账号");
		}
		if(accountname!=null&&accountname!=""){
			HashMap map = new HashMap();
			map.put("accountname",accountname);
			huiyuan=huiyuanSrv.loadPlus(map);
			if(huiyuan==null)
				return JsonResult.error(-2, "不存在的账号");
		}

		return JsonResult.success(1,"成功",huiyuan);

	}

	@ResponseBody
	@PostMapping("/admin/huiyuan/updatejb")
	public JsonResult updatejb() {
		String id = request.getParameter("id");
		String typeid=request.getParameter("typeid");

		if (id == null)
			return JsonResult.error(-1,"id不能味浓");
		Huiyuan huiyuan = huiyuanSrv.load(new Integer(id));
		if (huiyuan == null)
			return JsonResult.error(-2,"数据非法");

		if(typeid!=null)
			huiyuan.setTypeid(Integer.parseInt(typeid));
		else
			huiyuan.setTypeid(1);
		huiyuanSrv.update(huiyuan);
		return JsonResult.success(1,"设置成功");

	}


	@ResponseBody
	@PostMapping("/admin/huiyuan/list")
	public JsonResult list() {
		int pageindex = 1;
		int pagesize = 10;
		// 获取当前分页
		String accountname = request.getParameter("accountname");
		HashMap map = new HashMap();
		if (accountname != null)
			map.put("accountname",accountname);

		String currentpageindex = request.getParameter("currentpageindex");
		// 当前页面尺寸
		String currentpagesize = request.getParameter("pagesize");
		// 设置当前页
		if (currentpageindex != null)
			pageindex = new Integer(currentpageindex);
		// 设置当前页尺寸
		if (currentpagesize != null)
			pagesize = new Integer(currentpagesize);
		PageHelper.startPage(pageindex,pagesize);

		List<Huiyuan> listHuiyuan = huiyuanSrv.getEntityPlus(map);
		return JsonResult.success(1,"获取会员信息",new PageInfo<>(listHuiyuan));
	}

	
	

}

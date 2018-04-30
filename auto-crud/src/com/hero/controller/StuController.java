package com.hero.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.hero.service.StuService;
import com.hero.pojo.Stu;
import java.sql.Date;
import java.util.List;

public class StuController extends HttpServlet{
	private StuService service = new StuService();
	@Override
	protected void service(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		req.setCharacterEncoding("utf-8");
		resp.setContentType("text/html;charset=utf-8");
		 
		String method = req.getParameter("method");
		
		if("findAll".equals(method)) {
			this.findAll(req,resp);
		}else if("toAdd".equals(method)){
			this.toAdd(req,resp);
		}else if("add".equals(method)){
			this.add(req,resp);
		}else if("toUpdate".equals(method)){
			this.toUpdate(req,resp);
		}else if("update".equals(method)){
			this.update(req,resp);
		}else if("delete".equals(method)){
			this.delete(req,resp);
		}else{
			System.out.println("用户请求路径有误");
			resp.sendRedirect("404.jsp");
		}
		
		
		
	}



	private void delete(HttpServletRequest req, HttpServletResponse resp) {
		Object value = null;
		
		String sId = req.getParameter("sId");
		
		value = sId;
		
		
		
		Stu stu = new Stu();
		
		stu.setsId((Integer)value);
		
		
		
		service.delete(stu);
		try {
			resp.sendRedirect(req.getContextPath()+"/stuController?method=findAll");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	private void update(HttpServletRequest req, HttpServletResponse resp) {
		Stu stu = new Stu();
		Object value = null;
		
		
		String sId = req.getParameter("sId");
		value = sId;
		
		
		stu.setsId((Integer)value);
		
		
		
		String sName = req.getParameter("sName");
		value = sName;
		
		
		stu.setsName((String)value);
		
		
		
		String sSex = req.getParameter("sSex");
		value = sSex;
		
		
		stu.setsSex((String)value);
		
		
		service.update(stu);
		try {
			resp.sendRedirect(req.getContextPath()+"/stuController?method=findAll");
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	private void toUpdate(HttpServletRequest req, HttpServletResponse resp) {
		Object value = null;
		
		String sId = req.getParameter("sId");
		
		value = sId;
		
		Stu stu = new Stu();
		
		stu.setsId((Integer)value);
		
		
		
		stu = service.findOne(stu);
		req.setAttribute("stu",stu);
		try {
			req.getRequestDispatcher("/修改页面").forward(req, resp);
		} catch (ServletException | IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	private void add(HttpServletRequest req, HttpServletResponse resp) {
		Stu stu = new Stu();
		Object value = null;
		
		
		String sId = req.getParameter("sId");
		value = sId;
		
		
		stu.setsId((Integer)value);
		
		
		
		String sName = req.getParameter("sName");
		value = sName;
		
		
		stu.setsName((String)value);
		
		
		
		String sSex = req.getParameter("sSex");
		value = sSex;
		
		
		stu.setsSex((String)value);
		
		
		service.add(stu);
		try {
			resp.sendRedirect(req.getContextPath()+"/stuController?method=findAll");
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	private void toAdd(HttpServletRequest req, HttpServletResponse resp) {
		try {
			resp.sendRedirect(req.getContextPath()+"/添加页面");
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	private void findAll(HttpServletRequest req, HttpServletResponse resp) {
		List<Stu> stus = service.findAll();
		req.setAttribute("stus",stus);
		try {
			req.getRequestDispatcher("/查询页面").forward(req, resp);
		} catch (ServletException | IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}

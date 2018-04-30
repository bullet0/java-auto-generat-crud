package ${packagePath?lower_case};

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.text.SimpleDateFormat;
import ${baseClassPath?lower_case}.service.${tableName?cap_first}Service;
import ${baseClassPath?lower_case}.pojo.${tableName?cap_first};
import java.sql.Date;
import java.util.List;
import java.text.ParseException;

public class ${className?cap_first} extends HttpServlet{
	private ${tableName?cap_first}Service service = new ${tableName?cap_first}Service();
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
		
		String ${pkEntity.name} = req.getParameter("${pkEntity.name}");
		
		<#if pkEntity.type?lower_case == 'integer'>
		if(${pkEntity.name} != null){
			value = Integer.valueOf(${pkEntity.name});
		}
		<#elseif pkEntity.type?lower_case == 'double'>
		if(${pkEntity.name} != null)
			value = Double.valueOf(${pkEntity.name});
		}
		<#elseif pkEntity.type?lower_case == 'date'>
		if(${pkEntity.name} != null)
			SimpleDateFormat fmt = new SimpleDateFormat("yyyy-MM-dd");
			java.util.Date parse = fmt.parse(${pkEntity.name});
			value = new java.sql.Date( parse.getTime());
		}
		
		<#else>
		value = ${pkEntity.name};
		
		</#if>
		
		
		${tableName?cap_first} ${tableName?uncap_first} = new ${tableName?cap_first}();
		
		<#if pkEntity.type?lower_case == 'integer'>
		<#if pkEntity.state>
		${tableName?uncap_first}.set${pkEntity.name?cap_first}((Integer)value);
		<#else>
		${tableName?uncap_first}.set${pkEntity.name}((Integer)value);
		</#if>
		<#else>
		<#if pkEntity.state>
		${tableName?uncap_first}.set${pkEntity.name?cap_first}((${pkEntity.type?cap_first})value);
		<#else>
		${tableName?uncap_first}.set${pkEntity.name}((${pkEntity.type?cap_first})value);
		</#if>
		</#if>
		service.delete(${tableName?uncap_first});
		try {
			resp.sendRedirect(req.getContextPath()+"/${className?uncap_first}?method=findAll");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	private void update(HttpServletRequest req, HttpServletResponse resp) {
		${tableName?cap_first} ${tableName?uncap_first} = new ${tableName?cap_first}();
		Object value = null;
		
		<#if list??>
		<#list list as pj>
		
		String ${pj.name} = req.getParameter("${pj.name}");
		<#if pj.type?lower_case == 'integer'>
		if(${pj.name} != null){
			value = Integer.valueOf(${pj.name});
		}
		<#elseif pj.type?lower_case == 'double'>
		if(${pj.name} != null){
			value = Double.valueOf(${pj.name});
		}
		<#elseif pj.type?lower_case == 'date'>
		if(${pj.name} != null){
			SimpleDateFormat fmt = new SimpleDateFormat("yyyy-MM-dd");
			java.util.Date parse = null;
			try {
				parse = fmt.parse(${pj.name});
				value = new java.sql.Date( parse.getTime());
			} catch (ParseException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
		}
		<#else>
		value = ${pj.name};
		
		</#if>
		
		<#if pj.type?lower_case == 'integer'>
		<#if pj.state>
		${tableName?uncap_first}.set${pj.name?cap_first}((Integer)value);
		<#else>
		${tableName?uncap_first}.set${pj.name}((Integer)value);
		</#if>
		<#else>
		<#if pj.state>
		${tableName?uncap_first}.set${pj.name?cap_first}((${pj.type?cap_first})value);
		<#else>
		${tableName?uncap_first}.set${pj.name}((${pj.type?cap_first})value);
		</#if>
		</#if>
		
		</#list>
		</#if>
		service.update(${tableName?uncap_first});
		try {
			resp.sendRedirect(req.getContextPath()+"/${className?uncap_first}?method=findAll");
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	private void toUpdate(HttpServletRequest req, HttpServletResponse resp) {
		Object value = null;
		
		String ${pkEntity.name} = req.getParameter("${pkEntity.name}");
		
		<#if pkEntity.type?lower_case == 'integer'>
		if(${pkEntity.name} != null){
			value = Integer.valueOf(${pkEntity.name});
		}
		<#elseif pkEntity.type?lower_case == 'double'>
		if(${pkEntity.name} != null){
			value = Double.valueOf(${pkEntity.name});
		}
		<#elseif pkEntity.type?lower_case == 'date'>
		if(${pkEntity.name} != null){
			SimpleDateFormat fmt = new SimpleDateFormat("yyyy-MM-dd");
			java.util.Date parse = fmt.parse(${pkEntity.name});
			value = new java.sql.Date( parse.getTime());
		}
		
		<#else>
		value = ${pkEntity.name};
		</#if>
		
		${tableName?cap_first} ${tableName?uncap_first} = new ${tableName?cap_first}();
		
		<#if pkEntity.type?lower_case == 'integer'>
		<#if pkEntity.state>
		${tableName?uncap_first}.set${pkEntity.name?cap_first}((Integer)value);
		<#else>
		${tableName?uncap_first}.set${pkEntity.name}((Integer)value);
		</#if>
		<#else>
		<#if pkEntity.state>
		${tableName?uncap_first}.set${pkEntity.name?cap_first}((${pkEntity.type?cap_first})value);
		<#else>
		${tableName?uncap_first}.set${pkEntity.name}((${pkEntity.type?cap_first})value);
		</#if>
		</#if>
		
		${tableName?uncap_first} = service.findOne(${tableName?uncap_first});
		req.setAttribute("${tableName?uncap_first}",${tableName?uncap_first});
		try {
			req.getRequestDispatcher("/修改页面").forward(req, resp);
		} catch (ServletException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	private void add(HttpServletRequest req, HttpServletResponse resp) {
		${tableName?cap_first} ${tableName?uncap_first} = new ${tableName?cap_first}();
		Object value = null;
		
		<#if list??>
		<#list list as pj>
		String ${pj.name} = req.getParameter("${pj.name}");
		<#if pj.type?lower_case == 'integer'>
		if(${pj.name} != null){
			value = Integer.valueOf(${pj.name});
		}
		<#elseif pj.type?lower_case == 'double'>
		if(${pj.name} != null){
			value = Double.valueOf(${pj.name});
		}
		<#elseif pj.type?lower_case == 'date'>
		if(${pj.name} != null){
			SimpleDateFormat fmt = new SimpleDateFormat("yyyy-MM-dd");
			java.util.Date parse;
			try {
				parse = parse = fmt.parse(${pj.name});
				value = new java.sql.Date( parse.getTime());
			} catch (ParseException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
		}
		<#else>
		value = ${pj.name};
		
		</#if>
		
		<#if pj.type?lower_case == 'integer'>
		<#if pj.state>
		${tableName?uncap_first}.set${pj.name?cap_first}((Integer)value);
		<#else>
		${tableName?uncap_first}.set${pj.name}((Integer)value);
		</#if>
		<#else>
		<#if pj.state>
		${tableName?uncap_first}.set${pj.name?cap_first}((${pj.type?cap_first})value);
		<#else>
		${tableName?uncap_first}.set${pj.name}((${pj.type?cap_first})value);
		</#if>
		</#if>
		
		
		</#list>
		</#if>
		service.add(${tableName?uncap_first});
		try {
			resp.sendRedirect(req.getContextPath()+"/${className?uncap_first}?method=findAll");
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
		List<${tableName?cap_first}> ${tableName?uncap_first}s = service.findAll();
		req.setAttribute("${tableName?uncap_first}s",${tableName?uncap_first}s);
		try {
			req.getRequestDispatcher("/查询页面").forward(req, resp);
		} catch (ServletException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}

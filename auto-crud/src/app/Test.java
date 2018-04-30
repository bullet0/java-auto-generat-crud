package app;

import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;

import freemarker.template.Configuration;
import freemarker.template.Template;

public class Test {
	private static Element rootElement;
	private static Connection connection;
	
	private static String url;
	private static String driverClass;
	private static String username;
	private static String password;
	
	private static void loadDriver() throws Exception {
		// 获取node节点中，子节点的元素名称为dataSource的元素节点。  
        Element dataSource = rootElement.element("dataSource");  
        // 获取dataSource元素节点中，子节点为url的元素节点(可以看到只能获取第一个url元素节点)  
        Element urlELement = dataSource.element("url");  
        url = urlELement.getText();
        System.out.println(dataSource.getName() + "----" + url); 
        
        Element driverClassELement = dataSource.element("driverClass");  
        driverClass = driverClassELement.getText();
        System.out.println(dataSource.getName() + "----" + driverClass);  
        
        Element usernameELement = dataSource.element("username"); 
        username = usernameELement.getText();
        System.out.println(dataSource.getName() + "----" + username);  
        
        Element passwordELement = dataSource.element("password");
        password = passwordELement.getText();
        System.out.println(dataSource.getName() + "----" + password);  
        
        Class.forName(driverClass);
        connection = DriverManager.getConnection(url,username,password);
    }
	
	private static void scanTable() throws Exception {
		Element tables = rootElement.element("tables"); 
		List<Element> tableElements = tables.elements("table");
		for (Element tableElement : tableElements) {
			//声明一个变量用来保存主键对象
			Entity pkEntity = null;
			
			String packageName = tableElement.element("package").getText();
			String tbName = tableElement.element("tableName").getText();
			
			//从url中获取数据库名
			String dbName = url.substring(url.lastIndexOf("/")+1, url.indexOf("?"));
			//获取主键列
			DatabaseMetaData dbMetaData = connection.getMetaData();
			ResultSet primaryKeys = dbMetaData.getPrimaryKeys(dbName, null, tbName);
			primaryKeys.next();
			//主键的名字
			String pk = primaryKeys.getString("COLUMN_NAME");
			
			
			Statement stm = connection.createStatement();
			
			ResultSet rs = stm.executeQuery("select * from "+tbName);
			
			ResultSetMetaData metaData = rs.getMetaData();
			List<Entity> list = new ArrayList<>();
			List<Entity> snakeCase = new ArrayList<>();
			for(int i = 0;i<metaData.getColumnCount();i++) {
				//这里需要将表中的字段类型和名字都保存一下
				//int = 4  
				//varchar = 12  
				//date = 91  
				//double = 8 
				int columnType = metaData.getColumnType(i+1);
				String type = null;
				if(columnType == 4) {
					type = "int";
				}else if(columnType == 12) {
					type = "String";
				}else if(columnType == 91) {
					type = "Date";
				}else if(columnType == 8) {
					type = "Double";
				}
				
				
				
				String camalNaming = toCamalNaming(metaData.getColumnName(i+1));
				Entity entity = new Entity(type,camalNaming);
				Entity snakeCaseEntity = new Entity(type,metaData.getColumnName(i+1));
				if(camalNaming != null && camalNaming.length()>1 && Character.isUpperCase(camalNaming.charAt(1))) {
					entity.setState(false);
				}
				if(pk.equals(metaData.getColumnName(i+1))) {
					//说明是主键
					pkEntity = entity;
				}
				list.add(entity);
				snakeCase.add(snakeCaseEntity);
			}
			
			
			createJavaFile(packageName,toCamalNaming(tbName),list,pkEntity,snakeCase);
			
		}
		
	}

	
	
	private static void createJavaFile(String packageName, String tbName, List<Entity> list, Entity pkEntity, List<Entity> snakeCase) throws Exception {
		createPoJOJavaFile(packageName,tbName,list);
		createControllerJavaFile(packageName,tbName,list,pkEntity);
		createServiceJavaFile(packageName,tbName);
		createDaoJavaFile(packageName,tbName,list,pkEntity,snakeCase);
	}

	private static void createPoJOJavaFile(String packageName, String tbName, List<Entity> list) throws Exception {
		// TODO Auto-generated method stub
		Configuration config = new Configuration(Configuration.VERSION_2_3_23);
		config.setDirectoryForTemplateLoading(new File("templates"));
		
		//freemarker的数据就是一个map结构的对象
		Map<String, Object> dataMap = new HashMap<>();
		
		dataMap.put("baseClassPath", packageName.replaceAll("/", "\\."));
		dataMap.put("packagePath", packageName.replaceAll("/", "\\.") + ".pojo");
		dataMap.put("tableName", toUpperCase(tbName));
		dataMap.put("className", toUpperCase(tbName));
		dataMap.put("list", list);
		
		
		
		Template template = config.getTemplate("Pojo.ftl","utf-8");
		
		File file = new File("src/"+packageName+"/pojo/");
		if(!file.exists()) {
			file.mkdirs();
		}
		FileOutputStream out = new FileOutputStream(new File(file,toUpperCase(tbName)+".java"));
		OutputStreamWriter output = new OutputStreamWriter(out);
		
		template.process(dataMap, output);
		
		output.flush();
		output.close();
	}

	private static void createControllerJavaFile(String packageName, String tbName, List<Entity> list, Entity pkEntity) throws Exception {
		// TODO Auto-generated method stub
		Configuration config = new Configuration(Configuration.VERSION_2_3_23);
		config.setDirectoryForTemplateLoading(new File("templates"));
		
		//freemarker的数据就是一个map结构的对象
		Map<String, Object> dataMap = new HashMap<>();
		
		dataMap.put("baseClassPath", packageName.replaceAll("/", "\\."));
		dataMap.put("packagePath", packageName.replaceAll("/", "\\.") + ".controller");
		dataMap.put("tableName", toUpperCase(tbName));
		dataMap.put("className", toUpperCase(tbName)+"Controller");
		dataMap.put("pkEntity",pkEntity);
		dataMap.put("list",list);
		
		Template template = config.getTemplate("Controller.ftl","utf-8");
		
		File file = new File("src/"+packageName+"/controller/");
		if(!file.exists()) {
			file.mkdirs();
		}
		FileOutputStream out = new FileOutputStream(new File(file,toUpperCase(tbName)+"Controller.java"));
		OutputStreamWriter output = new OutputStreamWriter(out);
		
		template.process(dataMap, output);
		
		output.flush();
		output.close();
	}
	
	private static void createServiceJavaFile(String packageName, String tbName) throws Exception {
		// TODO Auto-generated method stub
		Configuration config = new Configuration(Configuration.VERSION_2_3_23);
		config.setDirectoryForTemplateLoading(new File("templates"));
		
		//freemarker的数据就是一个map结构的对象
		Map<String, Object> dataMap = new HashMap<>();
		
		dataMap.put("baseClassPath", packageName.replaceAll("/", "\\."));
		dataMap.put("packagePath", packageName.replaceAll("/", "\\.") + ".service");
		dataMap.put("tableName", toUpperCase(tbName));
		dataMap.put("className", toUpperCase(tbName)+"Service");
		
		
		Template template = config.getTemplate("Service.ftl","utf-8");
		
		File file = new File("src/"+packageName+"/service/");
		if(!file.exists()) {
			file.mkdirs();
		}
		FileOutputStream out = new FileOutputStream(new File(file,toUpperCase(tbName)+"Service.java"));
		OutputStreamWriter output = new OutputStreamWriter(out);
		
		template.process(dataMap, output);
		
		output.flush();
		output.close();
	}
	
	private static void createDaoJavaFile(String packageName, String tbName, List<Entity> list, Entity pkEntity, List<Entity> snakeCase) throws Exception {
		Configuration config = new Configuration(Configuration.VERSION_2_3_23);
		config.setDirectoryForTemplateLoading(new File("templates"));
		
		//freemarker的数据就是一个map结构的对象
		Map<String, Object> dataMap = new HashMap<>();
		
		dataMap.put("baseClassPath", packageName.replaceAll("/", "\\."));
		dataMap.put("packagePath", packageName.replaceAll("/", "\\.") + ".dao");
		dataMap.put("tableName", toUpperCase(tbName));
		dataMap.put("className", toUpperCase(tbName)+"Dao");
		dataMap.put("list", list);
		dataMap.put("snakeCase", snakeCase);
		dataMap.put("pkEntity", pkEntity);
		dataMap.put("snakeCasePKName", toSnake(pkEntity.getName()));
		
		StringBuilder deleteSQL = new StringBuilder("delete from ");
		deleteSQL.append(tbName);
		deleteSQL.append(" where ");
		deleteSQL.append(toSnake(pkEntity.getName()));
		deleteSQL.append(" = ?");
		dataMap.put("deleteSQL", deleteSQL);
		System.out.println(deleteSQL);
		
		StringBuilder updateSQL = new StringBuilder("update ");
		updateSQL.append(tbName);
		updateSQL.append(" set ");
		for (Entity entity : snakeCase) {
			updateSQL.append(entity.getName());
			updateSQL.append("=?,");
		}
		updateSQL = new StringBuilder(updateSQL.substring(0, updateSQL.length()-1));
		updateSQL.append(" where ");
		updateSQL.append(toSnake(pkEntity.getName()));
		updateSQL.append(" = ?");
		dataMap.put("updateSQL", updateSQL);
		System.out.println(updateSQL);
		
		
		StringBuilder insertSQL = new StringBuilder("insert into ");
		insertSQL.append(tbName);
		insertSQL.append("(");
		for (Entity entity : snakeCase) {
			insertSQL.append(entity.getName());
			insertSQL.append(",");
		}
		insertSQL = new StringBuilder(insertSQL.substring(0, insertSQL.length()-1));
		insertSQL.append(") values (");
		for (Entity entity : snakeCase) {
			insertSQL.append("?,");
		}
		insertSQL = new StringBuilder(insertSQL.substring(0, insertSQL.length()-1));
		insertSQL.append(")");
		dataMap.put("insertSQL", insertSQL);
		System.out.println(insertSQL);
		
		
		dataMap.put("url", url);
		dataMap.put("driverClass",driverClass);
		dataMap.put("username", username);
		dataMap.put("password", password);
		
		Template template = config.getTemplate("Dao.ftl","utf-8");
		
		File file = new File("src/"+packageName+"/dao/");
		if(!file.exists()) {
			file.mkdirs();
		}
		FileOutputStream out = new FileOutputStream(new File(file,toUpperCase(tbName)+"Dao.java"));
		OutputStreamWriter output = new OutputStreamWriter(out);
		
		template.process(dataMap, output);
		
		output.flush();
		output.close();
		
	}

	

	public static void main(String[] args) throws Exception {
		
		
		loadDriver();
		
		scanTable();
		
		
	}
	
	//首字母转大写
	public static String toUpperCase(String str) {  
	    return str.substring(0, 1).toUpperCase() + str.substring(1);  
	}  
	//驼峰命名
	public static String toCamalNaming(String str) {  
		StringBuilder sb = new StringBuilder();
	    for (int i = 0; i < str.length(); i++) {
			if(str.charAt(i) == '_') {
				sb.append(Character.toUpperCase(str.charAt(i+1)));
				i++;
			}else {
				sb.append(str.charAt(i));
			}
		}
		
		return sb.toString();  
	}
	//蛇形命名
	private static Object toSnake(String string) {
		StringBuilder sb = new StringBuilder();
	    for (int i = 0; i < string.length(); i++) {
			if(Character.isUpperCase(string.charAt(i))) {
				sb.append("_");
				sb.append(string.charAt(i));
			}else {
				sb.append(string.charAt(i));
			}
		}
		
		return sb.toString();  
	}
	static {
		
		try {
			// 创建saxReader对象  
	        SAXReader reader = new SAXReader();  
	        // 通过read方法读取一个文件 转换成Document对象  
	        Document document = reader.read(new File("src/config.xml"));
			//获取根节点元素对象  
			rootElement = document.getRootElement(); 
		} catch (DocumentException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}  
	}
}

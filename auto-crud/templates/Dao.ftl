package ${packagePath?lower_case};

import ${baseClassPath?lower_case}.pojo.${tableName?cap_first};
import java.sql.Date;
import java.util.List;
import java.util.ArrayList;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class ${className?cap_first} {
	public Connection getConnection() {
		Connection connection = null;
		try {
			Class.forName("${driverClass}");
			connection = DriverManager.getConnection("${url}","${username}","${password}");
		} catch (ClassNotFoundException  e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return connection;
	}

	public void close(Connection conn,Statement stm,ResultSet rs) {
		if(rs != null) {
			try {
				rs.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		if(stm != null) {
			try {
				stm.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		if(conn != null) {
			try {
				conn.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}

	public void delete(${tableName?cap_first} ${tableName?uncap_first}) {
		Connection conn = this.getConnection();
		PreparedStatement ps = null;
		try {
			conn.setAutoCommit(false);
			ps = conn.prepareStatement("${deleteSQL}");
			
			<#if pkEntity.state>
			ps.setInt(1, ${tableName?uncap_first}.get${pkEntity.name?cap_first}());
			<#else>
			ps.setInt(1, ${tableName?uncap_first}.get${pkEntity.name}());
			</#if>
			ps.executeUpdate();
			conn.commit();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			this.close(conn,ps,null);
		}
	}

	public void update(${tableName?cap_first} ${tableName?uncap_first}) {
		Connection conn = this.getConnection();
		PreparedStatement ps = null;
		try {
			conn.setAutoCommit(false);
			ps = conn.prepareStatement("${updateSQL}");
			<#list list as l>
			<#if l.state>
			ps.setObject(${l_index+1}, ${tableName?uncap_first}.get${l.name?cap_first}());
			<#else>
			ps.setObject(${l_index+1}, ${tableName?uncap_first}.get${l.name}());
			</#if>
			<#if !l_has_next>
			<#if pkEntity.state>
			ps.setObject(${l_index+2}, ${tableName?uncap_first}.get${pkEntity.name?cap_first}());
			<#else>
			ps.setObject(${l_index+2}, ${tableName?uncap_first}.get${pkEntity.name}());
			</#if>
			</#if>
			</#list>
			ps.executeUpdate();
			conn.commit();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			this.close(conn,ps,null);
		}
	}

	public ${tableName?cap_first} findOne(${tableName?cap_first} ${tableName?uncap_first}1) {
		Connection conn = this.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			conn.setAutoCommit(false);
			ps = conn.prepareStatement("select * from ${snaketableName} where ${snakeCasePKName}=?");
			
			<#if pkEntity.state>
			ps.setObject(1, ${tableName?uncap_first}1.get${pkEntity.name?cap_first}());
			<#else>
			ps.setObject(1, ${tableName?uncap_first}1.get${pkEntity.name}());
			</#if>
			
			rs = ps.executeQuery();
			conn.commit();
			${tableName?cap_first} ${tableName?uncap_first} = null;
			while (rs.next()) {
				${tableName?uncap_first} = new ${tableName?cap_first}();
				<#list list as l>
				<#if l.type?lower_case == 'integer'>
				<#if l.state>
				${tableName?uncap_first}.set${l.name?cap_first}(rs.getInt("${snakeCase[l_index].name}"));
				<#else>
				${tableName?uncap_first}.set${l.name}(rs.getInt("${snakeCase[l_index].name}"));
				</#if>
				<#else>
				<#if l.state>
				${tableName?uncap_first}.set${l.name?cap_first}(rs.get${l.type?cap_first}("${snakeCase[l_index].name}"));
				<#else>
				${tableName?uncap_first}.set${l.name}(rs.get${l.type?cap_first}("${snakeCase[l_index].name}"));
				</#if>
				</#if>
				</#list>
			}
			return ${tableName?uncap_first};
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			this.close(conn,ps,rs);
		}
		return null;
	}

	public List<${tableName?cap_first}> findAll() {
		Connection conn = this.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		List<${tableName}> list = new ArrayList<${tableName}>();
		try {
			conn.setAutoCommit(false);
			ps = conn.prepareStatement("select * from ${snaketableName}");
			rs = ps.executeQuery();
			conn.commit();
			while (rs.next()) {
				${tableName?cap_first} ${tableName?uncap_first} = new ${tableName?cap_first}();
				<#list list as l>
				
				<#if l.type?lower_case == 'integer'>
				<#if l.state>
				${tableName?uncap_first}.set${l.name?cap_first}(rs.getInt("${snakeCase[l_index].name}"));
				<#else>
				${tableName?uncap_first}.set${l.name}(rs.getInt("${snakeCase[l_index].name}"));
				</#if>
				<#else>
				<#if l.state>
				${tableName?uncap_first}.set${l.name?cap_first}(rs.get${l.type?cap_first}("${snakeCase[l_index].name}"));
				<#else>
				${tableName?uncap_first}.set${l.name}(rs.get${l.type?cap_first}("${snakeCase[l_index].name}"));
				</#if>
				</#if>
				</#list>
				list.add(${tableName?uncap_first});
			}
			return list;
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			this.close(conn,ps,rs);
		}
		return null;
	}
	
	public void add(${tableName?cap_first} ${tableName?uncap_first}) {
		Connection conn = this.getConnection();
		PreparedStatement ps = null;
		try {
			conn.setAutoCommit(false);
			ps = conn.prepareStatement("${insertSQL}");
			<#list list as l>
			<#if l.name?lower_case == pkEntity.name?lower_case>
			ps.setObject(${l_index+1},null);
			<#else>
			<#if l.state>
			ps.setObject(${l_index+1}, ${tableName?uncap_first}.get${l.name?cap_first}());
			<#else>
			ps.setObject(${l_index+1}, ${tableName?uncap_first}.get${l.name}());
			</#if>
			</#if>
			</#list>
			ps.executeUpdate();
			conn.commit();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			this.close(conn,ps,null);
		}
	}
}

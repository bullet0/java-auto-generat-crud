package ${packagePath?lower_case};

import ${baseClassPath?lower_case}.pojo.${tableName?cap_first};
import java.sql.Date;
import java.util.List;

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
			Class.forName("${url}");
			connection = DriverManager.getConnection("${driverClass}","${username}","${password}");
		} catch (ClassNotFoundException | SQLException e) {
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
			ps = conn.prepareStatement("delete from ${tableName?upper_case} where ${pkEntity.name}=?");
			
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
			
			
			
			ps.executeUpdate();
			conn.commit();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			this.close(conn,ps,null);
		}
	}

	public Stu findOne(${tableName?cap_first} ${tableName?uncap_first}) {
		return null;
	}

	public List<Stu> findAll() {
		return null;
	}
	
	public void add(${tableName?cap_first} ${tableName?uncap_first}) {
		Connection conn = this.getConnection();
		PreparedStatement ps = null;
		try {
			conn.setAutoCommit(false);
			
			
			
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

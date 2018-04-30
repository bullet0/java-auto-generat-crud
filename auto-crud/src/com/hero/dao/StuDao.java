package com.hero.dao;

import com.hero.pojo.Stu;
import java.sql.Date;
import java.util.List;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class StuDao {
	public Connection getConnection() {
		Connection connection = null;
		try {
			Class.forName("jdbc:mysql:///my_lol?useUnicode=true&characterEncoding=utf8&useSSL=false&serverTimezone=Hongkong");
			connection = DriverManager.getConnection("com.mysql.cj.jdbc.Driver","root","123456");
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

	public void delete(Stu stu) {
		Connection conn = this.getConnection();
		PreparedStatement ps = null;
		try {
			conn.setAutoCommit(false);
			ps = conn.prepareStatement("delete from STU where sId=?");
			
			ps.setInt(1, stu.getsId());
			ps.executeUpdate();
			conn.commit();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			this.close(conn,ps,null);
		}
	}

	public void update(Stu stu) {
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

	public Stu findOne(Stu stu) {
		return null;
	}

	public List<Stu> findAll() {
		return null;
	}
	
	public void add(Stu stu) {
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

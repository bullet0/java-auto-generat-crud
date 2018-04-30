package com.hero.service;

import com.hero.dao.StuDao;
import com.hero.pojo.Stu;
import java.util.List;

public class StuService {
	private StuDao dao = new StuDao();
	
	public void delete(Stu stu) {
		dao.delete(stu);
	}

	public void update(Stu stu) {
		dao.update(stu);
	}

	public Stu findOne(Stu stu) {
		return dao.findOne(stu);
	}

	public void add(Stu stu) {
		dao.add(stu);
	}

	public List<Stu> findAll() {
		return dao.findAll();
	}
}

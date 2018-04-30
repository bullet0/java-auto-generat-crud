package ${packagePath?lower_case};

import ${baseClassPath?lower_case}.dao.${tableName?cap_first}Dao;
import ${baseClassPath?lower_case}.pojo.${tableName?cap_first};
import java.util.List;

public class ${className?cap_first} {
	private ${tableName?cap_first}Dao dao = new ${tableName?cap_first}Dao();
	
	public void delete(${tableName?cap_first} ${tableName?uncap_first}) {
		dao.delete(${tableName?uncap_first});
	}

	public void update(${tableName?cap_first} ${tableName?uncap_first}) {
		dao.update(${tableName?uncap_first});
	}

	public ${tableName?cap_first} findOne(${tableName?cap_first} ${tableName?uncap_first}) {
		return dao.findOne(${tableName?uncap_first});
	}

	public void add(${tableName?cap_first} ${tableName?uncap_first}) {
		dao.add(${tableName?uncap_first});
	}

	public List<${tableName?cap_first}> findAll() {
		return dao.findAll();
	}
}

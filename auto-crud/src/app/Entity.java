package app;

public class Entity {
	private String type;
	private String name;
	//生成set  get 方法的标志，因为sId 生成的 set 方应为 setsId  ，首字母不大写
	//标志为true，首字母就大写，默认首字母大写
	private boolean state = true;
	
	public Entity(String type, String name) {
		this.type = type;
		this.name = name;
	}

	/**
	 * @return the type
	 */
	public String getType() {
		return type;
	}

	/**
	 * @param type the type to set
	 */
	public void setType(String type) {
		this.type = type;
	}

	/**
	 * @return the name
	 */
	public String getName() {
		return name;
	}

	/**
	 * @param name the name to set
	 */
	public void setName(String name) {
		this.name = name;
	}

	/**
	 * @return the state
	 */
	public boolean isState() {
		return state;
	}

	/**
	 * @param state the state to set
	 */
	public void setState(boolean state) {
		this.state = state;
	}

	
	
	
	
	
	
	
}

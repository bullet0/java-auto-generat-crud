package ${packagePath?lower_case};

import java.sql.Date;

public class ${className?cap_first}{

<#if list??>
	<#list list as pj>
	private ${pj.type} ${pj.name};
	</#list>
</#if>


<#if list??>
	<#list list as pj>
	
	<#if pj.state>
	
	<#if pj.type?lower_case == 'boolean'>
	
	public ${pj.type} is${pj.name?cap_first}() {
		return ${pj.name};
	}

	public void set${pj.name?cap_first}(${pj.type} ${pj.name}) {
		this.${pj.name} = ${pj.name};
	}
	
	<#else>
	
	public ${pj.type} get${pj.name?cap_first}() {
		return ${pj.name};
	}

	public void set${pj.name?cap_first}(${pj.type} ${pj.name}) {
		this.${pj.name} = ${pj.name};
	}
	
	</#if>
	
	
	<#else>
	
	<#if pj.type?lower_case == 'boolean'>
	
	public ${pj.type} is${pj.name}() {
		return ${pj.name};
	}

	public void set${pj.name}(${pj.type} ${pj.name}) {
		this.${pj.name} = ${pj.name};
	}
	
	<#else>
	
	public ${pj.type} get${pj.name}() {
		return ${pj.name};
	}

	public void set${pj.name}(${pj.type} ${pj.name}) {
		this.${pj.name} = ${pj.name};
	}
	
	</#if>
	
	</#if>	
	
	
	</#list>
</#if>	

}










# java-auto-generat-crud
java自动生成CRUD（单表）
修改src下config.xml,运行src下app下的App.java中的main方法即可自动生成CRUD
 
命名规范：
数据库字段  使用蛇形命名，小写
实体类      生成的为驼峰命名
现支持数据库字段为varchar，int，double，date，此外一律默认为String，如datetime会对应为String类型
 
目前为0.0.1版本，生成CRUD基于servlet

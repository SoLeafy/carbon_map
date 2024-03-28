package servlet.impl;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class FileDAO {
	@Autowired
	private SqlSessionTemplate session;

	public void cleanTable() {
		session.update("file.cleanTable");
	}

	public int uploadFile(List<Map<String, Object>> list) {
		return session.insert("file.uploadFile", list);
	}
	
	public void refreshMv() {
		session.update("file.refreshMv");
	}
	
	public void refreshMvSgg() {
		session.update("file.refreshMvSgg");
	}
	
	

}

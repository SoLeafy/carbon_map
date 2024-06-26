package servlet.impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("TestDAO")
public class TestDAO extends EgovComAbstractDAO {
	
	@Autowired
	private SqlSessionTemplate session;

	public List<Map<String, Object>> getSdList() {
		return session.selectList("test.sdList");
	}
	
	
	
}
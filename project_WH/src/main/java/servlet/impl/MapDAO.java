package servlet.impl;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("MapDAO")
public class MapDAO extends EgovComAbstractDAO {

	@Autowired
	private SqlSessionTemplate session;

	public List<Map<String, Object>> getSdList() {
		return session.selectList("map.sdList");
	}
	
	public List<Map<String, Object>> getSggList(String sd) {
		return session.selectList("map.sggList", sd);
	}
	
	public Map<String, Object> getExtent(int sd) {
		return session.selectOne("map.getExtent", sd);
	}
}

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
	
	public Map<String, Object> getSdExtent(int sd) {
		return session.selectOne("map.getSdExtent", sd);
	}
	
	public Map<String, Object> getSggExtent(int sgg) {
		return session.selectOne("map.getSggExtent", sgg);
	}
	
	public List<Map<String, Object>> getSdData() {
		return session.selectList("map.getSdData");
	}
	
	public List<Map<String, Object>> getSggData(int sd) {
		return session.selectList("map.getSggData", sd);
	}
}

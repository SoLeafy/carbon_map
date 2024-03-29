package servlet.service;

import java.util.List;
import java.util.Map;

public interface MapService {
	List<Map<String, Object>> getSdList();
	
	List<Map<String, Object>> getSggList(String sd);
	
	Map<String, Object> getSdExtent(int sd);
	Map<String, Object> getSggExtent(int sgg);
	
	List<Map<String, Object>> getSdData();

	List<Map<String, Object>> getSggData(int sd);
}

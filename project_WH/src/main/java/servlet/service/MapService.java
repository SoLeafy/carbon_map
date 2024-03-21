package servlet.service;

import java.util.List;
import java.util.Map;

public interface MapService {
	List<Map<String, Object>> getSdList();
	
	List<Map<String, Object>> getSggList(String sd);
	
	Map<String, Object> getExtent(int sd);
}

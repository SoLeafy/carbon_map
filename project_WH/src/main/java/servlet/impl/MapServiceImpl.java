package servlet.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import servlet.service.MapService;

@Service("MapService")
public class MapServiceImpl extends EgovAbstractServiceImpl implements MapService {
	
	@Resource(name="MapDAO")
	private MapDAO mapDAO;

	@Override
	public List<Map<String, Object>> getSdList() {
		return mapDAO.getSdList();
	}

	@Override
	public List<Map<String, Object>> getSggList(String sd) {
		return mapDAO.getSggList(sd);
	}

	@Override
	public Map<String, Object> getExtent(int sd) {
		return mapDAO.getExtent(sd);
	}
	
	

}

package servlet.impl;

import java.util.HashMap;
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
	public Map<String, Object> getSdExtent(int sd) {
		return mapDAO.getSdExtent(sd);
	}

	@Override
	public Map<String, Object> getSggExtent(int sgg) {
		return mapDAO.getSggExtent(sgg);
	}

	@Override
	public List<Map<String, Object>> getSdData() {
		return mapDAO.getSdData();
	}

	@Override
	public List<Map<String, Object>> getSggData(int sd) {
		return mapDAO.getSggData(sd);
	}

	@Override
	public List<Map<String, Object>> getDggLegend(int opt, int div) { // 
		List<Map<String, Object>> dgg = null;
		switch (opt) {
		case 0: // 전국
			dgg = mapDAO.getDggSd();
			break;
		case 1: // 시도
			dgg = mapDAO.getDggSgg(div);
			break;
		case 2: // 시군구
			dgg = mapDAO.getDggBjd(div);
			break;
		default:
			break;
		}
		return dgg;
	}

	@Override
	public List<Map<String, Object>> getNbLegend(int opt, int div) {
		List<Map<String, Object>> nb = null;
		switch (opt) {
		case 0: // 전국
			nb = mapDAO.getNbSd();
			break;
		case 1: // 시도
			nb = mapDAO.getNbSgg(div);
			break;
		case 2: // 시군구
			nb = mapDAO.getNbBjd(div);
			break;
		default:
			break;
		}
		
		return nb;
	}

}

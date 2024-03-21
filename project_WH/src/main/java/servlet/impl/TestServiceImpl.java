package servlet.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import servlet.service.TestService;

@Service("TestService")
public class TestServiceImpl extends EgovAbstractServiceImpl implements TestService {

	@Resource(name="TestDAO")
	private TestDAO testDAO;

	@Override
	public List<Map<String, Object>> getSdList() {
		return testDAO.getSdList();
	}
}
package servlet.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import servlet.service.TestService;

@Service("TestService")
public class TestServiceImpl extends EgovAbstractServiceImpl implements TestService {

	@Resource(name="TestDAO")
	private TestDAO testDAO;
}
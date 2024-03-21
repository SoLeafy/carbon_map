package servlet.controller;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import servlet.service.TestService;
import servlet.util.APIInfo;

@Controller
public class TestController {
	
	@Resource(name = "TestService")
	private TestService testService;
	
	@Autowired
	private APIInfo apiInfo;
	
	@RequestMapping(value= "/test.do", method = RequestMethod.GET)
	public String test(Model model) {
		
		model.addAttribute("apiKey", apiInfo.getApiKey());
		model.addAttribute("apiDomain", apiInfo.getApiDomain());
		
		return "main/testBackup";
	}
	
	@RequestMapping(value = "/txtInput.do", method = RequestMethod.GET)
	public String txtInput() {
		
		return "main/txtInput";
	}
	
	
}
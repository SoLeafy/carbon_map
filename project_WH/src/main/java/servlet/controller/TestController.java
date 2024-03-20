package servlet.controller;

import java.io.IOException;

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
	
	@RequestMapping(value = "/map.do", method = RequestMethod.GET)
	public String map(Model model) {
		
		model.addAttribute("apiKey", apiInfo.getApiKey());
		model.addAttribute("apiDomain", apiInfo.getApiDomain());
		
		return "main/map";
	}
	
	@RequestMapping(value = "/txtInput.do", method = RequestMethod.GET)
	public String txtInput() {
		
		return "main/txtInput";
	}
	
	@RequestMapping(value = "/uploadTxt.do", method = RequestMethod.POST)
	public String uploadTxt(@RequestParam("file") MultipartFile file) throws IOException {
		
		System.out.println(file.getContentType());
		// System.out.println(file.getContentType().equals("text/plain"));
		
		if(file.getContentType().equals("text/plain")) {
			System.out.println(file.getOriginalFilename());
			System.out.println(file.getBytes());
			return "redirect:/txtInput.do";
		} else {
			return "redirect:/txtInput.do";
		}
		
	}
}
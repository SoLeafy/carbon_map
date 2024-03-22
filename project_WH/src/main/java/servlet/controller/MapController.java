package servlet.controller;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import servlet.service.FileService;
import servlet.service.MapService;
import servlet.util.APIInfo;
import servlet.util.Util;

@Controller
public class MapController {
	
	@Resource(name="MapService")
	private MapService mapService;
	
	@Resource(name="FileService")
	private FileService fileService;
	
	@Autowired
	private Util util;
	
	@Autowired
	private APIInfo apiInfo;

	@RequestMapping(value = "/map.do", method = RequestMethod.GET)
	public String map(Model model) {
		
		List<Map<String, Object>> sdList = mapService.getSdList();
		//List<Map<String, Object>> sggList = mapService.getSggList();
		
		model.addAttribute("apiKey", apiInfo.getApiKey());
		model.addAttribute("apiDomain", apiInfo.getApiDomain());
		
		model.addAttribute("sdList", sdList);
		//model.addAttribute("sggList", sggList);
		
		return "main/map";
	}
	
	@ResponseBody
	@RequestMapping(value = "/sdSelect.do", method = RequestMethod.POST, produces = "application/json; charset=UTF-8")
	public String sdSelect(@RequestParam(value="sd") String sd) {
		List<Map<String, Object>> sggList = mapService.getSggList(sd);
		Map<String, Object> sdExtent = mapService.getSdExtent(Util.str2int(sd));
		
		JSONObject json = new JSONObject();
		json.put("sggList", sggList);
		json.put("sdExtent", sdExtent);
		
		
		return json.toString();
	}
	
	@ResponseBody
	@RequestMapping(value="/sggSelect.do", method=RequestMethod.POST, produces = "application/json; charset=UTF-8")
	public String sggSelect(@RequestParam(value="sgg") String sgg) {
		
		Map<String, Object> sggExtent = mapService.getSggExtent(Util.str2int(sgg));
		
		JSONObject json = new JSONObject();
		json.put("sggExtent", sggExtent);
		
		
		return json.toString();
	}
	
	// 파일 업로드
	@ResponseBody
	@RequestMapping(value = "/uploadTxt.do", method = RequestMethod.POST)
	public String uploadTxt(MultipartHttpServletRequest request) throws IOException {
		MultipartFile file = request.getFile("file");
		int result = 0;
		
		if(Util.isValidTxtFile(file)) {
			System.out.println(file.getName());
			System.out.println(file.getSize());
			System.out.println(file.getContentType());
			System.out.println(file.getOriginalFilename());
			
			int startTime = (int) System.currentTimeMillis();
			//result = fileService.uploadFile(file);
			int endTime = (int) System.currentTimeMillis();
			int processingTime = (endTime - startTime)/60000;
			//System.out.println("처리 시간(분): " + (processingTime));
			
			JSONObject json = new JSONObject();
			json.put("result", result);
			json.put("processingTime", processingTime);
			
			//return json.toString();
			
		} else {
			//return String.valueOf(result);
		}
		return "ghj";
	}
}

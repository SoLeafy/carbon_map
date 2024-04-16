package servlet.controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.collections.map.HashedMap;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
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
		
//		// 
//	      //최대값, 최소값, 범례   
//	      Map<String, BigDecimal> data = mapService.bum(sggcd);
//	      
//	      BigDecimal max = new BigDecimal(String.valueOf(data.get("max")));
//	      BigDecimal min = new BigDecimal(String.valueOf(data.get("min")));
//	      BigDecimal interval = new BigDecimal(String.valueOf(data.get("interval")));
//	      
//	      Map<String, BigDecimal> legend = new HashedMap();
//	      
//	      for (int i = 0; i < 5; i++) {
//	            BigDecimal rangeStart = data.get("max").add(interval.multiply(new BigDecimal(i)));
//	            BigDecimal rangeEnd = data.get("min").add(interval.multiply(new BigDecimal(i + 1)));
//	          legend.put(i + "start", rangeStart);
//	          legend.put(i + "end", rangeEnd);
//	      };
		
		
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
	//public String uploadTxt(MultipartHttpServletRequest request) throws IOException {
	public String uploadTxt(@RequestParam("file") MultipartFile file) throws IOException {
		//System.out.println(file);
		int result = 0;
		
		if(Util.isValidTxtFile(file)) {
			//System.out.println(file.getName());
			//System.out.println(file.getSize());
			//System.out.println(file.getContentType());
			//System.out.println(file.getOriginalFilename());
			
			long startTime = System.currentTimeMillis();
			result = fileService.uploadFile(file);
			long endTime = System.currentTimeMillis();
			long timeElapsed = endTime - startTime;
			//System.out.println("처리 시간(분): " + (processingTime));
			
			JSONObject json = new JSONObject();
			json.put("result", result);
			double processingTime = (double) timeElapsed / 1000;
			json.put("timeElapsed", processingTime);
			
			return json.toString();
			
		} else {
			return String.valueOf(result);
		}
	}
	
	// 통계 페이지
	@GetMapping("/statistics.do")
	public String stat(Model model) {
		List<Map<String, Object>> sdList = mapService.getSdList();
		model.addAttribute("sdList", sdList);
		return "main/stats";
	}
	
}

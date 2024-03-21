package servlet.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import servlet.service.MapService;
import servlet.util.APIInfo;
import servlet.util.Util;

@Controller
public class MapController {
	
	@Resource(name="MapService")
	private MapService mapService;
	
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
	@RequestMapping(value = "/sggSelect.do", method = RequestMethod.POST, produces = "application/json; charset=UTF-8")
	public String sggSelect(@RequestParam(value="sd") String sd) {
		List<Map<String, Object>> sggList = mapService.getSggList(sd);
		Map<String, Object> sdExtent = mapService.getExtent(Util.str2int(sd));
		
		JSONObject json = new JSONObject();
		json.put("sggList", sggList);
		json.put("sdExtent", sdExtent);
		
		
		return json.toString();
	}
	
	// 파일 업로드
	@RequestMapping(value = "/uploadTxt.do", method = RequestMethod.POST)
	public @ResponseBody String uploadTxt(@RequestParam("file") MultipartFile file) throws IOException {
		
		if(Util.isValidTxtFile(file)) {
			System.out.println(file.getName());
			System.out.println(file.getSize());
			System.out.println(file.getContentType());
			System.out.println(file.getOriginalFilename());
			
			List<Map<String, Object>> list = new ArrayList<Map<String,Object>>();
			Map<String, Object> map = new HashMap<String, Object>();
			InputStreamReader isr = new InputStreamReader(file.getInputStream());
			BufferedReader br = new BufferedReader(isr);
			String line = null;
			while((line = br.readLine()) != null) {
				String[] lineArr = line.split("\\|");
				map.put("usagedate", lineArr[0]); // 사용년월
				map.put("landloc", lineArr[1]); // 대지 위치
				map.put("drmlandloc", lineArr[2]); // 도로명 대지 위치
				map.put("ssgcd", lineArr[3]); // 시군구 코드
				map.put("bjdcd", lineArr[4]); // 법정동 코드
				map.put("landclasscd", lineArr[5]); // 대지 구분 코드
				map.put("bun", lineArr[6]); // 번
				map.put("ji", lineArr[7]); // 지
				map.put("sjnum", lineArr[8]); // 새주소 일련번호
				map.put("sjrdcd", lineArr[9]); // 새주소 도로 코드
				map.put("sjagbgcd", lineArr[10]); // 새주소 지상지하 코드
				map.put("sjbonbeon", lineArr[11]); // 새주소 본번
				map.put("sgbubeon", lineArr[12]); // 새주소 부번
				map.put("usage", lineArr[13]); // 사용량(kWh)
				
				list.add(map);
			}
			System.out.println("종료: " + list);
			br.close();
			isr.close();
			
			return "";
		} else {
			return "";
		}
		
	}
}

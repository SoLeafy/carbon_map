package servlet.controller;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import servlet.service.MapService;
import servlet.util.Util;

@RestController
public class RESTFulController {
	
	@Resource(name="MapService")
	private MapService mapService;
	
	@RequestMapping(value="/chartSd.do", method=RequestMethod.POST)
	public List<Map<String, Object>> sdChart() {
		
		List<Map<String, Object>> sdData = mapService.getSdData();
		
		return sdData;
	}
	
	@PostMapping(value="/chartSgg.do")
	public List<Map<String, Object>> getSggData(@RequestParam("sd") String sd) {
		
		List<Map<String, Object>> sggData = mapService.getSggData(Util.str2int(sd));
		
		return sggData;
	}
	
	// 범례
	@PostMapping("/dggLegend.do")
	public List<Map<String,Object>> dgg(@RequestParam("opt") String opt, @RequestParam("div") String div) {
		int optNum = Util.str2int(opt);
		int divNum = Util.str2int(div);
		List<Map<String, Object>> legend = mapService.getDggLegend(optNum, divNum);
		return legend;
	}
	
	@PostMapping("/nbLegend.do")
	public List<Map<String,Object>> nb(@RequestParam("opt") String opt, @RequestParam("div") String div) {
		int optNum = Util.str2int(opt);
		int divNum = Util.str2int(div);
		List<Map<String, Object>> legend = mapService.getNbLegend(optNum, divNum);
		return legend;
	}
}

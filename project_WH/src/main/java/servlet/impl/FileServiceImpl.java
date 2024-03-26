package servlet.impl;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import servlet.service.FileService;

@Service("FileService")
public class FileServiceImpl extends EgovAbstractServiceImpl implements FileService {
	
	@Autowired
	private FileDAO fileDAO;

	@Override
	public int uploadFile(MultipartFile file) {
		fileDAO.cleanTable();
		int processedLine = 0;
		int result = 0;
		List<Map<String, Object>> list = new ArrayList<Map<String,Object>>();
		try {
			InputStreamReader isr = new InputStreamReader(file.getInputStream());
			BufferedReader br = new BufferedReader(isr);
			String line = null;
			int count = 0;
			while((line = br.readLine()) != null) {
				Map<String, Object> map = new HashMap<String, Object>();
				String[] lineArr = line.split("\\|");
				if(count == 20000) {
					//db저장
					result = fileDAO.uploadFile(list);
					list.clear();
					count = 0;
				}
				// map.put("usagedate", lineArr[0]); // 사용년월
				// map.put("landloc", lineArr[1]); // 대지 위치
				// map.put("drmlandloc", lineArr[2]); // 도로명 대지 위치
				map.put("sggcd", lineArr[3]); // 시군구 코드
				map.put("bjdcd", lineArr[4]); // 법정동 코드
				// map.put("landclasscd", lineArr[5]); // 대지 구분 코드
				// map.put("bun", lineArr[6]); // 번
				// map.put("ji", lineArr[7]); // 지
				// map.put("sjnum", lineArr[8]); // 새주소 일련번호
				// map.put("sjrdcd", lineArr[9]); // 새주소 도로 코드
				// map.put("sjagbgcd", lineArr[10]); // 새주소 지상지하 코드
				// map.put("sjbonbeon", lineArr[11]); // 새주소 본번
				// map.put("sgbubeon", lineArr[12]); // 새주소 부번
				map.put("usage", lineArr[13]); // 사용량(kWh)
				
				list.add(map);
				count++;
				processedLine++;
				
			}
			
			//System.out.println("종료: " + list);
			br.close();
			isr.close();
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			if(list.size() > 0) {
				//db저장
				result = fileDAO.uploadFile(list);
				//System.out.println("저장 결과: " + result);
				//System.out.println("처리된 라인: " + processedLine);
			}
			fileDAO.refreshMv();
		}
		return processedLine;
	}
}

package servlet.util;

import java.util.Objects;

import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

@Component
public class Util {

	public static int str2int(String str) {
		try {
			return Integer.parseInt(str);
		} catch (Exception e) {
			return 0;
		}
	}
	
	public static boolean isValidTxtFile(MultipartFile file) {
		return Objects.equals(file.getContentType(), "text/plain");
	}
}

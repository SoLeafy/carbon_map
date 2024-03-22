package servlet.service;

import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartFile;

public interface FileService {

	int uploadFile(MultipartFile file);

}

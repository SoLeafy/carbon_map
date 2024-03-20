<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>txtUpload</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script type="text/javascript">
/* $(document).on("change", "input[type='file']", function(){

	let file_path = $(this).val();
	let reg = /(.*?)\.(txt)$/;

  // 허용되지 않은 확장자일 경우

	if (file_path != "" && (file_path.match(reg) == null || reg.test(file_path) == false)) {
		if ($.browser.msie) { // ie 일때 
			$(this).replaceWith($(this).clone(true));
		} else {
			$(this).val("");
		}
		alert("텍스트 파일만 업로드 가능합니다.");
	}
}); */
</script>

</head>
<body>
<h2>File Upload</h2>
<form id="uploadForm" action="./uploadTxt.do" method="post" name="txtForm" enctype="multipart/form-data">
	<input type="file" id="txtFile" name="file" accept="text/plain">
	<button>Upload File</button>
</form>
</body>
</html>
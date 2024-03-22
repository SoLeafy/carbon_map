<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>map</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script type="text/javascript" src="resources/js/ol.js"></script>
<link rel="stylesheet" href="resources/css/ol.css" type="text/css">
<!-- <script type="text/javascript" src="resources/js/mapTest.js"></script> -->
<!-- OpenLayer 링크 6.15.1 -->
<!-- <script
   src="https://cdn.rawgit.com/openlayers/openlayers.github.io/master/en/v6.15.1/build/ol.js"></script>
<link rel="stylesheet"
   href="https://cdn.jsdelivr.net/npm/ol@v6.15.1/ol.css"> -->

<style type="text/css">
.container {
	/* max-width: 1000px; */
	margin: 0 auto;
	display: flex;
	flex-direction: column;
	min-height: 100vh;
}
.mycontainer {
}
aside {
	width: 200px;
	background-color: pink;
}
article {

}
.map {
	height: 600px;
	width: 80%;
}
#ddWrapper {
	display: flex;
}
</style>
<script type="text/javascript" src="resources/js/app.js"></script>
<script type="text/javascript">
$(function() {
	
})
</script>
<script type="text/javascript">
// ready
$( document ).ready(function() {
	// 맵 객체 생성
	let map = new ol.Map({ // OpenLayer의 맵 객체를 생성한다.
	    target: 'map', // 맵 객체를 연결하기 위한 target으로 <div>의 id값을 지정해준다.
	    layers: [ // 지도에서 사용 할 레이어의 목록을 정의하는 공간이다.
	      new ol.layer.Tile({
	        source: new ol.source.OSM({
	          // url: 'https://maps.wikimedia.org/osm-intl/{z}/{x}/{y}.png' // vworld의 지도를 가져온다.
	          url: 'http://api.vworld.kr/req/wmts/1.0.0/${apiKey}/Base/{z}/{y}/{x}.png'
	        })
	      })
	    ],
	    view: new ol.View({ // 지도가 보여 줄 중심좌표, 축소, 확대 등을 설정한다. 보통은 줌, 중심좌표를 설정하는 경우가 많다.
	      center: ol.proj.fromLonLat([128.4, 35.7]),
	      zoom: 7, 
	      enableRotation: false // alt+shift+드래그 회전 막기
	    })
	});
	
	// 시도 타일 레이어
	var sdWms = new ol.layer.Tile({
		source : new ol.source.TileWMS({
			url : 'http://localhost/geoserver/cite/wms?service=WMS', // 1. 레이어 URL
			params : {
				'VERSION' : '1.1.0', // 2. 버전
				'LAYERS' : 'cite:tl_sd', // 3. 작업공간:레이어 명
				'BBOX' : [1.3873946E7, 3906626.5, 1.4428045E7, 4670269.5], 
				'SRS' : 'EPSG:3857', // SRID
				'FORMAT' : 'image/png', // 포맷
				'CQL_FILTER' : 'sd_cd=11'
			},
			serverType : 'geoserver',
		}), 
		opacity: 0.4
	});
	
	// 시군구 타일 레이어
	var sggWms = new ol.layer.Tile({
		source : new ol.source.TileWMS({
			url : 'http://localhost/geoserver/cite/wms?service=WMS', // 1. 레이어 URL
			params : {
				'VERSION' : '1.1.0', // 2. 버전
				'LAYERS' : 'cite:tl_sgg', // 3. 작업공간:레이어 명
				'BBOX' : [1.3873946E7, 3906626.5, 1.4428045E7, 4670269.5], 
				'SRS' : 'EPSG:3857', // SRID
				'FORMAT' : 'image/png', // 포맷
				'CQL_FILTER' : 'sgg_cd=11620'
			},
			serverType : 'geoserver',
		}),
		opacity: 0.6
	});
	
	// 법정동 타일 레이어
	var bjdWms = new ol.layer.Tile({
		source : new ol.source.TileWMS({
			url : 'http://localhost/geoserver/cite/wms?service=WMS', // 1. 레이어 URL
			params : {
				'VERSION' : '1.1.0', // 2. 버전
				'LAYERS' : 'cite:tl_bjd', // 3. 작업공간:레이어 명
				'BBOX' : [1.3873946E7, 3906626.5, 1.4428045E7, 4670269.5], 
				'SRS' : 'EPSG:3857', // SRID
				'FORMAT' : 'image/png', // 포맷
				'CQL_FILTER' : 'bjd_cd=11620101'
			},
			serverType : 'geoserver',
		}),
		opacity: 0.8
	});
	
	
	// 시도 드롭다운 변화 -----------------------------------------------------------------------
	$("#sd").on('change', function() {
		let sd = $("#sd option:checked").val(); // 시도 코드
		let sggDd = document.querySelector("#sgg"); // 시군구 드롭다운
		let sggOpt = `<option value="0">시/군/구 선택</option>`; // 시군구 Option html String
		
		let sgg = $("#sgg option:checked").val(); // 시군구 코드
		
		// 드롭다운 변경 시 레이어 모두 제거
		map.removeLayer(sdWms);
		map.removeLayer(sggWms);
		map.removeLayer(bjdWms);
		
		if(parseInt(sd) !== 0) {
			// 시도 코드에 해당하는 레이어 CQL_FILTER
			sdWms = new ol.layer.Tile({
				source : new ol.source.TileWMS({
					url : 'http://localhost/geoserver/cite/wms?service=WMS', // 1. 레이어 URL
					params : {
						'VERSION' : '1.1.0', // 2. 버전
						'LAYERS' : 'cite:tl_sd', // 3. 작업공간:레이어 명
						'BBOX' : [1.3873946E7, 3906626.5, 1.4428045E7, 4670269.5], 
						'SRS' : 'EPSG:3857', // SRID
						'FORMAT' : 'image/png', // 포맷
						'CQL_FILTER' : 'sd_cd=' + sd
					},
					serverType : 'geoserver',
				}), 
				opacity: 0.4
			});
			
			// 시도 CQL_FILTER 레이어 추가
			map.addLayer(sdWms);
			
			// 시도 선택 시 시군구 드롭다운 옵션 받아오기 (db)
			$.ajax({
				url: "./sdSelect.do",
				type: "post",
				dataType: "json",
				data: {sd: sd},
				success: function(data) {
					let sggList = data.sggList;
					// OL) view.fit()을 위한 
					let sdExtent = data.sdExtent;
					console.log([sdExtent.xmin, sdExtent.ymin, sdExtent.xmax, sdExtent.ymax]);
					map.getView().fit([sdExtent.xmin, sdExtent.ymin, sdExtent.xmax, sdExtent.ymax], {duration : 300}); // xmin, ymin, xmax, ymax 순이었다
					
					sggDd.innerHTML = "";
					
					for(let i = 0; i < sggList.length;i++) {
						sggOpt += "<option value=\'"+sggList[i].sgg_cd+"\'>"+sggList[i].sgg_nm+"</option>";
					}
					
					sggDd.innerHTML = sggOpt;
				}, 
				error: function(error) {
					alert("통신실패: " + error);
				}
			});
			
		} else {
			sggDd.innerHTML = `<option value="0">시/군/구 선택</option>`;
		}
		
	});
	
	// 시군구 드롭다운 변경 시
	$("#sgg").on("change", function() {
		console.log($("#sgg option:checked").text());
		let sgg = $("#sgg option:checked").val();
		let sggDd = document.querySelector("#sgg");
		
		map.removeLayer(sggWms);
		
		if(Number(sgg) !== 0) {
			sggWms = new ol.layer.Tile({
				source : new ol.source.TileWMS({
					url : 'http://localhost/geoserver/cite/wms?service=WMS', // 1. 레이어 URL
					params : {
						'VERSION' : '1.1.0', // 2. 버전
						'LAYERS' : 'cite:tl_sgg', // 3. 작업공간:레이어 명
						'BBOX' : [1.3873946E7, 3906626.5, 1.4428045E7, 4670269.5], 
						'SRS' : 'EPSG:3857', // SRID
						'FORMAT' : 'image/png', // 포맷
						'CQL_FILTER' : 'sgg_cd='+sgg
					},
					serverType : 'geoserver',
				}),
				opacity: 0.6
			});
			
			map.addLayer(sggWms);
			
			$.ajax({
				url: "./sggSelect.do",
				type: "post",
				dataType: "json",
				data: {sgg: sgg},
				success: function(data) {
					// 시군구에 맞추기
					let sggExtent = data.sggExtent;
					let sggExArr = [sggExtent.xmin, sggExtent.ymin, sggExtent.xmax, sggExtent.ymax];
					console.log([sggExtent.xmin, sggExtent.ymin, sggExtent.xmax, sggExtent.ymax]);
					console.log(sggExArr[2] === undefined);
					if(!sggExArr.some(e => e === undefined)) {
						map.getView().fit(sggExArr, {duration : 300});
						//some으로 disabled 속성 주려했지만 아닌것같아서 제거
						//console.log($("#sgg option[value*=\'"+sgg+"\']"));
						//$("#sgg option[value*=\'"+sgg+"\']").prop('disabled',true);
					}
				},
				error: function() {}
				
			})
		}
	})
	
	// 파일 업로드
	$("#uploadBtn").click(function() {
		alert("clicked!");
		let formData = new FormData();
		let inputFile = $("input[name='file']");
		let files = inputFile[0].files;
		console.log(files);
		
		for(let i = 0; i < files.length; i++) {
			formData.append("upFile", files[i]);
		}
		console.log(formData);
		
		/* $.ajax({
			url: "/uploadTxt.do", 
			enctype: "multipart/form-data", 
			type: "post", 
			//dataType: "json", 
			data: formData, 
			processData: false, 
			contentType: false, 
			success: function(data) {
				alert("통신 성공: " + data);
			}, 
			error: function(error) {
				alert("통신 실패: " + error);
			}
		}); */
	});
	
	
	//map.addLayer(sdWms);
	//map.addLayer(sggWms); // 맵 객체에 레이어를 추가
	//map.addLayer(bjdWms); // 맵에 법정동 레이어 추가
	
});
</script>
</head>
<body>
	<header>
	헤더
	</header>
	<div class="container">
		<div class="mycontainer">
		<aside class="sidebar">
		사이드바
		</aside>
		<main class="mainContainer">
		<!-- 탄소지도 -->
			<div id="map" class="map"></div>
			<!-- 드롭다운 -->
			<!-- <form name="locForm" action="./sggSelect.do"> -->
			<div id="ddWrapper">
			<div id="sdDropdown">
				<select name="sd" id="sd">
					<option value="0">시/도 선택</option>
					<c:forEach items="${sdList }" var="sd">
					<option value="${sd.sd_cd }">${sd.sd_nm }</option>
					</c:forEach>
				</select>
			</div>
			<div id="sggDropdown">
				<select name="sgg" id="sgg">
					<option value="0">시/군/구 선택</option>
				</select>
			</div>
			</div>
			<!-- </form> -->
		<!-- 데이터 삽입 -->
			<div>
				<div id="uploadForm">
					<input type="file" id="txtFile" name="file" accept="text/plain" placeholder="txt 파일 업로드">
					<button id="uploadBtn">파일 업로드</button>
				</div>
			</div>
			<article>
			</article>
		</main>
		</div>
	</div>
	<footer>
	푸터
	</footer>
</body>
</html>
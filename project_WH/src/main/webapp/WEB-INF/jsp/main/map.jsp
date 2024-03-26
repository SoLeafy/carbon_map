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
<link rel="stylesheet" href="resources/css/styles.css" type="text/css">
<!-- <script type="text/javascript" src="resources/js/mapTest.js"></script> -->
<!-- OpenLayer 링크 6.15.1 -->
<!-- <script
   src="https://cdn.rawgit.com/openlayers/openlayers.github.io/master/en/v6.15.1/build/ol.js"></script>
<link rel="stylesheet"
   href="https://cdn.jsdelivr.net/npm/ol@v6.15.1/ol.css"> -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
<!-- fontawesome -->
<script src="https://kit.fontawesome.com/53f2b43024.js" crossorigin="anonymous"></script>
<script type="text/javascript" src="resources/js/app.js"></script>
<style>
header{
	height: 60px;
}
.container1 {
	display: flex;
	width: 100%;
}
.mycontainer {
	display: flex;
	width: 100%;
}
.mainContainer {
	width: 100%;
}
#ddWrapper {
	display: flex;
	flex-direction: column;
}
</style>
<script type="text/javascript">
// ready
$( document ).ready(function() {
	// 토스트
	let toastBox = document.getElementById('toastBox');
	//let loadingMsg = '로딩 중';
	let successMsg = '<i class="fa-solid fa-circle-check"></i> 파일 업로드 성공';
	let failMsg = '<i class="fa-solid fa-circle-xmark"></i> 파일 업로드 실패';
	let loadingToast = $("#loadingToast");
	loadingToast.hide();
	
	function showResultToast(msg) {
		let toast = document.createElement('div');
		toast.classList.add('toast');
		toast.innerHTML = msg;
		toastBox.appendChild(toast);
		
		if(msg.includes('실패')) {
			toast.classList.add('fail');
		}
		if(msg.includes('성공')) {
			toast.classList.add('success');
		}
		
		setTimeout(() => {
			toast.remove();
		}, 3000);
	}
	
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
	let sdWms = new ol.layer.Tile({
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
	let sggWms = new ol.layer.Tile({
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
	let bjdWms = new ol.layer.Tile({
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
	
	let dtSggLayer;
	let dtSdLayer;
	
	
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
			// map.addLayer(sdWms); // 데이터 레이어로 하려고
			
			// 시도 선택 시 시군구 드롭다운 옵션 받아오기 (db)
			$.ajax({
				url: "./sdSelect.do",
				type: "post",
				dataType: "json",
				data: {sd: sd},
				global: false, 
				success: function(data) {
					let sggList = data.sggList;
					// OL) view.fit()을 위한 
					let sdExtent = data.sdExtent;
					console.log([sdExtent.xmin, sdExtent.ymin, sdExtent.xmax, sdExtent.ymax]);
					map.getView().fit([sdExtent.xmin, sdExtent.ymin, sdExtent.xmax, sdExtent.ymax], {duration : 500}); // xmin, ymin, xmax, ymax 순이었다
					
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
			
			//map.addLayer(sggWms); // 데이터 레이어로 깔려고 주석
			
			$.ajax({
				url: "./sggSelect.do",
				type: "post",
				dataType: "json",
				data: {sgg: sgg},
				global: false, 
				success: function(data) {
					// 시군구에 맞추기
					let sggExtent = data.sggExtent;
					let sggExArr = [sggExtent.xmin, sggExtent.ymin, sggExtent.xmax, sggExtent.ymax];
					console.log([sggExtent.xmin, sggExtent.ymin, sggExtent.xmax, sggExtent.ymax]);
					console.log(sggExArr[2] === undefined);
					// map.getView().setCenter(pt); <- 이걸로 센터 이동
					if(!sggExArr.some(e => e === undefined)) {
						map.getView().fit(sggExArr, {duration : 500});
						//some으로 disabled 속성 주려했지만 아닌것같아서 제거
						//console.log($("#sgg option[value*=\'"+sgg+"\']"));
						//$("#sgg option[value*=\'"+sgg+"\']").prop('disabled',true);
					}
				},
				error: function() {}
				
			})
		}
	})
	
	// 레이어 검색 ----------------------------------------------------------------------
	$("#searchBtn").on('click', function() {
		//map.getLayers()
		
		if ($("#sgg option:checked").val() != 0) {
			//console.log($("#sgg option:checked").val());
			map.removeLayer(dtSdLayer);
			map.removeLayer(dtSggLayer);
			
			let sgg = $("#sgg option:checked").val(); // 시군구 코드
			
			dtSggLayer = new ol.layer.Tile({
				source : new ol.source.TileWMS({
					url : 'http://172.30.1.65:8080/geoserver/ljs/wms?service=WMS', // 1. 레이어 URL
					params : {
						'VERSION' : '1.1.0', // 2. 버전
						'LAYERS' : 'ljs:mvdtbjd', // 3. 작업공간:레이어 명
						'BBOX' : [1.3873946E7, 3906626.5, 1.4428045E7, 4670269.5], 
						'SRS' : 'EPSG:3857', // SRID
						'FORMAT' : 'image/png', // 포맷
						'CQL_FILTER' : "bjdcd LIKE '" + sgg + "%'"
					},
					serverType : 'geoserver',
				}),
				opacity: 0.6
			});
			
			map.addLayer(dtSggLayer);
		
		} else if ($("#sd option:checked").val() != 0) {
			map.removeLayer(dtSdLayer);
			map.removeLayer(dtSggLayer);
			
			let sd = $("#sd option:checked").val(); // 시도 코드
			 
			dtSdLayer = new ol.layer.Tile({
				source : new ol.source.TileWMS({
					url : 'http://172.30.1.65:8080/geoserver/ljs/wms?service=WMS', // 1. 레이어 URL
					params : {
						'VERSION' : '1.1.0', // 2. 버전
						'LAYERS' : 'ljs:mvdtbjd', // 3. 작업공간:레이어 명
						'BBOX' : [1.3873946E7, 3906626.5, 1.4428045E7, 4670269.5], 
						'SRS' : 'EPSG:3857', // SRID
						'FORMAT' : 'image/png', // 포맷
						'CQL_FILTER' : "bjdcd LIKE '" + sd + "%'"
					},
					serverType : 'geoserver',
				}),
				opacity: 0.6
			});
			
			map.addLayer(dtSdLayer);
		} else {
			alert("지역 정보를 선택하세요.");
		}
		
	});
	
	
	
	
	$(document).ajaxStart(function () {
      console.log("ajax start");
      /* let toastElList = [].slice.call(document.querySelectorAll('.toast'))
      let toastList = toastElList.map(function (toastEl) {
        return new bootstrap.Toast(toastEl)
      })
      toastList.forEach(toast => toast.show()); */
      loadingToast.show();
   });
   
  /*  $(document).ajaxStop(function () {
      alert("ajax stop");
   }); */
	
	// 파일 업로드
	$("#uploadBtn").on("click", function() {
		//alert("clicked!");
		let fileName = $('#file').val();
		let extension = fileName.substring(fileName.lastIndexOf('.') + 1).toLowerCase();
		
		/* progress 정보 */
		/* let bar = $('.bar');
		let percent = $('.percent');
		let status = $('#status'); */
		
		if (extension == 'txt') {
			$.ajax({
				/* xhr: function() {
					let xhr = new window.XMLHttpRequest();
					xhr.upload.addEventListener("progress", function(event) {
						if (event.lengthComputable) {
							let percentComplete = Math.floor((event.loaded/event.total) * 100) ;
							//percentComplete = parseInt(percentComplete * 100);
							let percentVal = percentComplete + '%';
							//$('#progressbar').html(percentComplete + '%');
							//$('#progressbar').width(percentComplete + '%');
							bar.width(percentVal);
							percent.html(percentVal);
						}
					}, false);
					return xhr;
				}, */
				url: "/uploadTxt.do", 
				enctype: "multipart/form-data", 
				type: "post", 
				//dataType: "json", 
				data: new FormData($('#uploadForm')[0]), 
				cache: false, 
				processData: false, 
				contentType: false, 
				success: function(data) {
					let result = JSON.parse(data);
					console.log(result);
					showResultToast(successMsg + '(' + result.result + ' lines)<br>경과 시간: ' + result.timeElapsed + '초');
					loadingToast.remove();
				}, 
				error: function(error) {
					alert("통신 실패: " + error);
					showResultToast(failMsg);
					loadingToast.remove();
				}
			});
		} else if (!extension) {
			return false; // 파일이 비어있다든지..?
		} else {
			alert("지원하지 않는 파일");
		}
		
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
	<div class="container1">
		<div class="mycontainer">
		<!-- 토스트 -->
		<div id="toastBox">
			<div class="toast" id="loadingToast"><i class="fa-solid fa-circle-arrow-up"></i> 업로드 진행 중...</div>
		</div>
		<aside class="sidebar">
		사이드바
		<!-- 드롭다운 -->
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
				<div>
					<button id="searchBtn">검색</button>
				</div>
			</div>
		<!-- 데이터 삽입 -->
			<div>
				<form id="uploadForm">
					<input type="file" id="file" name="file" accept="text/plain" placeholder="txt 파일 업로드" required>
					<button type="button" id="uploadBtn">파일 업로드</button>
				</form>
			</div>
		</aside>
		<main class="mainContainer">
			<!-- 탄소지도 -->
			<div id="map" class="map"></div>
			<article>
			</article>
		</main>
		</div>
		
		
		<!-- progress Modal -->
		<!-- <div class="modal fade" id="pleaseWaitDialog" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" data-backdrop="static">
		    <div class="modal-dialog">
		        <div class="modal-content">
		            <div class="modal-header">
		                <h3>Upload processing...</h3>
		            </div>
		            <div class="modal-body">
		                 progress , bar, percent를 표시할 div 생성한다. 
		                <div class="progress">
		                    <div class="bar"></div>
		                    <div class="percent">0%</div>
		                </div>
		                <div id="status"></div>
		            </div>
		        </div>
		    </div>
		</div> -->
	</div>
	<footer>
	푸터
	</footer>
</body>
</html>
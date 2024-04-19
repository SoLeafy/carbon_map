<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>map</title>
<!-- 프로젝트 resource -->
<link rel="stylesheet" href="resources/css/styles.css" type="text/css">
<script type="text/javascript" src="resources/js/app.js"></script>
<!-- <script type="text/javascript" src="resources/js/script.js"></script> -->
<!-- jquery -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="https://code.jquery.com/ui/1.13.2/jquery-ui.js"></script>
<!-- OpenLayers 5.3 버전 -->
<!-- <script type="text/javascript" src="resources/js/ol.js"></script> -->
<!-- <link rel="stylesheet" href="resources/css/ol.css" type="text/css"> -->
<!-- OpenLayers 링크 6.15.1 -->
<script
   src="https://cdn.rawgit.com/openlayers/openlayers.github.io/master/en/v6.15.1/build/ol.js"></script>
<link rel="stylesheet"
   href="https://cdn.jsdelivr.net/npm/ol@v6.15.1/ol.css">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
<!-- fontawesome -->
<script src="https://kit.fontawesome.com/53f2b43024.js" crossorigin="anonymous"></script>
<!-- 구글차트 -->
<!--Load the AJAX API-->
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script type="text/javascript">
// ready --------------------------------------------------------------------
$( document ).ready(function() {
	//토스트
	let toastBox = document.getElementById('toastBox');
	//let loadingMsg = '로딩 중';
	let successMsg = '<i class="fa-solid fa-circle-check"></i> 파일 업로드 성공';
	let failMsg = '<i class="fa-solid fa-circle-xmark"></i> 파일 업로드 실패';
	let loadingToast = $("#loadingToast");
	// '업로드 중' 토스트 가리기
	loadingToast.hide();
	// 업로드 시작되면 토스트 보이기
	$(document).ajaxStart(function () {
      console.log("ajax start");
      loadingToast.show();
   });
	
	// 맵, 레이어 선언 ----------------------------------------------------------------------------
	// 맵 객체의 base map tile
	let baseMapSource = new ol.source.XYZ({
        // url: 'https://maps.wikimedia.org/osm-intl/{z}/{x}/{y}.png' // vworld의 지도를 가져온다.
        url: 'http://api.vworld.kr/req/wmts/1.0.0/${apiKey}/Base/{z}/{y}/{x}.png'
      });
	let baseMap = new ol.layer.Tile({
        source: baseMapSource,
        properties: { name: 'basemap' },
	      });
	let view = new ol.View({ // 지도가 보여 줄 중심좌표, 축소, 확대 등을 설정한다. 보통은 줌, 중심좌표를 설정하는 경우가 많다.
	      center: ol.proj.fromLonLat([128.4, 35.7]),
	      zoom: 7, 
	      enableRotation: false // alt+shift+드래그 회전 막기
	    });
	
	// 맵 객체 생성
	let map = new ol.Map({ // OpenLayer의 맵 객체를 생성한다.
	    target: 'map', // 맵 객체를 연결하기 위한 target으로 <div>의 id값을 지정해준다.
	    layers: [ // 지도에서 사용 할 레이어의 목록을 정의하는 공간이다.
	    	baseMap,
	    ],
	    view: view,
	});
	
	// 레이어 정의
	let dtSggLayer = new ol.layer.Tile({
		source : new ol.source.TileWMS({
			//url : 'http://172.30.1.65:8080/geoserver/ljs/wms?service=WMS', // 1. 레이어 URL
			url : 'http://localhost/geoserver/ljs/wms?service=WMS', // 1. 레이어 URL
			params : {
				'VERSION' : '1.1.0', // 2. 버전
				'LAYERS' : 'ljs:c5_gradedbjd', // 3. 작업공간:레이어 명
				//'BBOX' : [1.3873946E7, 3906626.5, 1.4428045E7, 4670269.5],
				'BBOX' : [1.4053287E7, 3921838.5, 1.4422936E7, 4641660.5], 
				'SRS' : 'EPSG:3857', // SRID
				'FORMAT' : 'image/png' // 포맷
			},
			serverType : 'geoserver',
		}),
		properties: { name : 'sgg' }, 
		opacity: 0.4
	});
	
	let dtSdLayer = new ol.layer.Tile({
		source : new ol.source.TileWMS({
			//url : 'http://172.30.1.65:8080/geoserver/ljs/wms?service=WMS', // 1. 레이어 URL
			url : 'http://localhost/geoserver/ljs/wms?service=WMS', // 1. 레이어 URL
			params : {
				'VERSION' : '1.1.0', // 2. 버전
				'LAYERS' : 'ljs:c5_gradedsgg', // 3. 작업공간:레이어 명
				'BBOX' : [1.3871489329746835E7, 3910407.083927817, 1.46800091844669E7, 4666488.829376992], 
				'SRS' : 'EPSG:3857', // SRID
				'FORMAT' : 'image/png' // 포맷
			},
			serverType : 'geoserver',
		}),
		properties: { name : 'sd' }, 
		opacity: 0.4
	});
	
	let dtLayer = new ol.layer.Tile({
		source : new ol.source.TileWMS({
			//url : 'http://172.30.1.65:8080/geoserver/ljs/wms?service=WMS', // 1. 레이어 URL
			url : 'http://localhost/geoserver/ljs/wms?service=WMS', // 1. 레이어 URL
			params : {
				'VERSION' : '1.1.0', // 2. 버전
				'LAYERS' : 'ljs:c5_gradedsd', // 3. 작업공간:레이어 명
				'BBOX' : [1.3871489341071218E7, 3910407.083927817, 1.4680011171788167E7, 4666488.829376997], 
				'SRS' : 'EPSG:3857', // SRID
				'FORMAT' : 'image/png' // 포맷
			},
			serverType : 'geoserver',
		}),
		properties: { name : 'all' }, 
		opacity: 0.4
	});
	
	// 페이지 옮기기 --------------------------------------------------
	/* function selectPage(sectionToShow, selectedMenu) {
		let selection = document.querySelector(selectionToShow);
		let ddToErase = []; // selection 제외한 드롭다운
		let menu = document.querySelector(selectedMenu);
		let menuToUnselect = []; // 선택된 menu 제외한 메뉴
	} */
	
	// 파일 메뉴 클릭
	$("#fileLink").on('click', function() {
		selectPage("#fileSection", "#fileLink");
	});
	
	// 지도 메뉴 클릭
	$("#mapLink").on('click', function() {
		selectPage("#layerDd", "#mapLink");
	});
	
	// 통계 메뉴 클릭
	$('#statsLink').on('click', function() {
		selectPage("#chartDd", "#statsLink");
	});
	
	// 시도 드롭다운 변화 -----------------------------------------------------------------------
	$("#sd").on('change', function() {
		map.getOverlays().clear();
		let sd = $("#sd option:checked").val(); // 시도 코드
		let sggDd = document.querySelector("#sgg"); // 시군구 드롭다운
		let sggOpt = `<option value="0">시/군/구 선택</option>`; // 시군구 Option html String
		
		let sgg = $("#sgg option:checked").val(); // 시군구 코드
		
		if(parseInt(sd) > 1) {
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
					//console.log([sdExtent.xmin, sdExtent.ymin, sdExtent.xmax, sdExtent.ymax]);
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
			
		} else if (Number(sd) === 1) {
			sggDd.innerHTML = `<option value="0">시/군/구 선택</option>`;
			map.getView().fit([1.3873946E7, 3906626.5, 1.4428045E7, 4670269.5], {duration: 500});
			/* map.getView().setCenter(ol.proj.fromLonLat([128.4, 35.7]));
			map.getView().setZoom(7); */
		} else {
			sggDd.innerHTML = `<option value="0">시/군/구 선택</option>`;
		}
		
	});
	
	// 시군구 드롭다운 변경 시
	$("#sgg").on("change", function() {
		console.log($("#sgg option:checked").text());
		let sgg = $("#sgg option:checked").val();
		let sggDd = document.querySelector("#sgg");
		
		if(Number(sgg) !== 0) {
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
			});
		}
	});
	
	// 레이어 검색 ----------------------------------------------------------------------
	$("#searchBtn").on('click', function() {
		let target = document.querySelector("#legendDiv");
		target.innerHTML = '';
		map.getOverlays().clear();
		let layerArr = map.getAllLayers().filter(layer => layer.get('name') != 'basemap');
		layerArr.forEach(layer => map.removeLayer(layer));
		
		let sgg = $("#sgg option:checked").val();
		let sd = $("#sd option:checked").val();
		let legendOpt = $('#legend option:checked').val();
		
		if (sgg != 0) { // 시군구 셀렉
			dtSggLayer.getSource().updateParams({'CQL_FILTER' : "bjdcd LIKE '" + sgg + "%'"});
			makeLegend(legendOpt, layerArr, 2, sgg);
			map.addLayer(dtSggLayer);
		} else if (sd == 1) { // 전국
			makeLegend(legendOpt, layerArr, 0, sd);
			map.addLayer(dtLayer);
		} else if (sd != 0) { // 시도 셀렉
			dtSdLayer.getSource().updateParams({'CQL_FILTER' : "sgg_cd LIKE '" + sd + "%'"});
			makeLegend(legendOpt, layerArr, 1, sd);
			map.addLayer(dtSdLayer);
		} else {
			alert("지역 정보를 선택하세요.");
		}
		
	});

	// overlay
	const container = document.getElementById('popup');
	const content = document.getElementById('popup-content');
	const closer = document.getElementById('popup-closer');
	
	const overlay = new ol.Overlay({
		element: container,
		autoPan: {
			animation: {
				duration: 250,
			},
		},
	});
	
	closer.onclick = function() {
		overlay.setPosition(undefined);
		closer.blur();
		return false;
	};
	
	// wms GetFeatureInfo -----------------------------------------------------
	// 클릭한 지점에 Overlay
	map.on('singleclick', async function(e) { // async 없으면 await 때문에 안됨... (블로그에는 화살표함수로 async 없던데 왤까)
		map.getOverlays().clear();
		
		const coordinate = e.coordinate; // 클릭한 지도 좌표
		
		// WMS properties의 name이 sgg인 레이어 추출
		const wmsLayer = map.getAllLayers().filter(layer => layer.get('name') === 'sgg')[0];
		// WMS 레이어의 Source 호출
		const source = wmsLayer.getSource();
		const url = source.getFeatureInfoUrl(e.coordinate, map.getView().getResolution(), 'EPSG:3857', {
			QUERY_LAYERS: 'ljs:c5_gradedbjd', 
			INFO_FORMAT: 'application/json'
		});
		
		// GetFeatureInfo URL이 유효할 경우
		if (url) {
			//console.log(fetch(url.toString(), {method: 'GET'}).catch(e => alert(e.message))); // Promise 객체
			const request = await fetch(url.toString(), { method: 'GET' }).catch(err => alert(err.message));
			//console.log(request);
			
			// 응답이 유효할 경우
			if(request) {
				// 응답이 정상일 경우
				if(request.ok) {
					const json = await request.json();
					
					// 객체가 하나도 없을 경우
					if (json.features.length === 0) {
						overlay.setPosition(undefined);
					} else {
						// GeoJSON에서 Feature를 생성
						const feature = new ol.format.GeoJSON().readFeature(json.features[0]);
						
						// 생성한 Feature로 VectorSource 생성
						const vector = new ol.source.Vector({ features: [feature] });
						//console.log(typeof feature.get('totusage'));
						
						content.innerHTML = '<p style="font-weight: bold">' + feature.get('bjd_nm') + '</p>사용량: <code>' + feature.get('totusage').toLocaleString('ko-KR') + 'kWh</code>';
						
						//overlay.setPosition(ol.extent.getCenter(vector.getExtent())); // 오버레이 센터 좌표에 띄우기
						overlay.setPosition(coordinate);
					}
				} else {
					alert(request.status);
				}
			}
		}
		
		map.addOverlay(overlay);
	});
	
	
	// 파일 업로드
	$("#uploadBtn").on("click", function() {
		let fileName = $('#file').val();
		let extension = fileName.substring(fileName.lastIndexOf('.') + 1).toLowerCase();
		
		if (extension == 'txt') {
			$.ajax({
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
			return false;
		} else {
			alert("지원하지 않는 파일");
		}
		
		$('#file').val() = '';
		
	});
   
   // 통계 검색 버튼
   $("#chartBtn").on("click", function() {
	   let chartOpt = $("#chartSd").val();
	   document.querySelector("#dataTable").innerHTML = '';
	   let target = document.querySelector("#legendDiv");
		target.innerHTML = '';
	   
	   if (Number(chartOpt) === 0) {
		   return false; // 그냥해봄
	   } else {
		   if (Number(chartOpt) === 1) {
			   // 전국(시도별)
			   $.ajax({
				   url: "/chartSd.do",
				   type: "post",
				   dataType: "json",
				   global: false, 
				   //data: {},
				   success: function(result) {
					   let serverData = result;
					   // console.log(data);
						// Load the Visualization API and the corechart package.
					      google.charts.load('current', {'packages':['corechart']});

					      // Set a callback to run when the Google Visualization API is loaded.
					      google.charts.setOnLoadCallback(drawChart);

					      // Callback that creates and populates a data table,
					      // instantiates the pie chart, passes in the data and
					      // draws it.
					      function drawChart() {
					    	  
					    	  let rows = [];
					    	  result.forEach(e => {
					    		  	let arr = new Array();
					    		  	arr.push(e.sd_nm);
					    		  	arr.push(e.totusage);
					    		  	rows.push(arr);
					    		  });
					    	  console.log(rows);

					        // Create the data table.
					        let data = new google.visualization.DataTable();
					        data.addColumn('string', '시도');
					        data.addColumn('number', 'kWh');
					        data.addRows(rows);

					        // Set chart options
					        let options = {'title':'시도별 사용량',
					                       'width':800,
					                       'height':100 + 40 * rows.length};

					        // Instantiate and draw our chart, passing in some options.
					        let chart = new google.visualization.BarChart(document.getElementById('chart_div'));
					        chart.draw(data, options);
					      }
					      
					      makeTable('시도', serverData);
					   
				   },
				   error: function(err) {
					   console.log(err);
				   }
			   });
		   } else {
			   // 시도(시군구별)
			   $.ajax({
				   url: "/chartSgg.do",
				   type: "post",
				   dataType: "json",
				   data: {sd : chartOpt}, 
				   global: false, 
				   success: function(result) {
					   
					   let serverData = result;
						// Load the Visualization API and the corechart package.
					      google.charts.load('current', {'packages':['corechart']});

					      // Set a callback to run when the Google Visualization API is loaded.
					      google.charts.setOnLoadCallback(drawChart);

					      // Callback that creates and populates a data table,
					      // instantiates the pie chart, passes in the data and
					      // draws it.
					      function drawChart() {
					    	  
					    	  let rows = [];
				    		  serverData.forEach(e => {
					    		  	let arr = new Array();
					    		  	arr.push(e.sgg_nm);
					    		  	arr.push(e.totusage);
					    		  	rows.push(arr);
					    		  });
					    	  console.log(rows);

					        // Create the data table.
					        let data = new google.visualization.DataTable();
					        data.addColumn('string', '시군구');
					        data.addColumn('number', 'kWh');
					        data.addRows(rows);

					        // Set chart options
					        let options = {'title':'시군구별 사용량',
					                       'width':800,
					                       'height': 100 + 40 * rows.length};

					        // Instantiate and draw our chart, passing in some options.
					        let chart = new google.visualization.BarChart(document.getElementById('chart_div'));
					        chart.draw(data, options);
					      }
					      
					      makeTable('시군구', serverData);
				   },
				   error: function(err) {
					   console.log(err);
				   }
			   });
		   }
	   }
   });
   
   /* // 범례 테이블 드래그ㅡㅡ
   $("#legend").draggable({ containment:"#map", scroll: false }); */
   
	
});
</script>
</head>
<body>
	<header>
		<h3 class="px-3">C5 지도</h3>
	</header>
	<div class="container1">
		<div class="mycontainer">
		
		<aside>
		<div class="menu">
			<div class="menuLink selectedMenu" id="fileLink">
				<div class="menuIcon">
				<i class="fa-solid fa-file-arrow-up"></i>
				</div>
				파일
			</div>
			<div class="menuLink" id="mapLink">
				<div class="menuIcon">
				<i class="fa-solid fa-map"></i>
				</div>
				지도
			</div>
			<div class="menuLink" id="statsLink">
				<div class="menuIcon">
				<i class="fa-solid fa-square-poll-horizontal"></i>
				</div>
				통계
			</div>
		</div>
		<div class="sidebar p-2" id="sidebar">
		<!-- 데이터 삽입 -->
			<div class="ddWrapper" id="fileSection">
				<form id="uploadForm">
					<input type="file" id="file" name="file" class='form-control' accept="text/plain" placeholder="txt 파일 업로드" required>
					<div class="btnWrapper">
					<button type="button" id="uploadBtn" class="btn">파일 업로드</button>
					</div>
				</form>
			</div>
		<!-- 드롭다운 -->
			<div class="ddWrapper" id="layerDd" style="display:none;">
				<div id="sdDropdown">
					<select name="sd" id="sd" class="form-select">
						<option value="0">시/도 선택</option>
						<option value="1">전국</option>
						<c:forEach items="${sdList }" var="sd">
						<option value="${sd.sd_cd }">${sd.sd_nm }</option>
						</c:forEach>
					</select>
				</div>
				<div id="sggDropdown">
					<select name="sgg" id="sgg" class="form-select">
						<option value="0">시/군/구 선택</option>
					</select>
				</div>
				<div id="legendDropdown">
					<select name="legend" id="legend" class="form-select">
						<option value="1">등간격</option>
						<option value="2">내추럴 브레이크</option>
					</select>
				</div>
				<div class="btnWrapper">
					<button id="searchBtn" class="btn">지도 검색</button>
				</div>
			</div>
		<!-- 통계 -->
			<div id="chartDd" class="ddWrapper" style="display:none;">
				<select id="chartSd" class="form-select">
					<option value="0">시/도 선택</option>
					<option value="1">전국</option>
					<c:forEach items="${sdList }" var="sd">
					<option value="${sd.sd_cd }">${sd.sd_nm }</option>
					</c:forEach>
				</select>
				<div class="btnWrapper">
					<button id="chartBtn" class="btn" data-bs-toggle="modal" data-bs-target="#dataModal">통계 검색</button>			
				</div>
			</div>
			</div>
		</aside>
		<main class="mainContainer">
			<!-- popup overlay -->
			<div id="popup" class="ol-popup">
		      <a href="#" id="popup-closer" class="ol-popup-closer"></a>
		      <div id="popup-content"></div>
		    </div>
		    
			<!-- 탄소지도 -->
			<div id="wrapper">
				<div id="map" class="map"></div>
					<!-- 범례 위치 -->
					<div id="legendDiv" class="rounded legendDiv"></div>
				
				<!-- 모달 -->
				<!-- Modal -->
				<div class="modal fade" id="dataModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
				  <div class="modal-dialog modal-xl modal-dialog-scrollable">
				    <div class="modal-content">
				      <div class="modal-header">
				        <h5 class="modal-title" id="exampleModalLabel">통계</h5>
				        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
				      </div>
				      <div class="modal-body">
				        <!-- 차트 -->
						<!--Div that will hold the pie chart-->
						<div id="chart">
				   			<div id="chart_div"></div>
				   			<div id="dataTable"></div>
						</div>
				      </div>
				      <!-- <div class="modal-footer">
				      </div> -->
				    </div>
				  </div>
				</div>
				
			</div>
		</main>
		<!-- 토스트 -->
		<div id="toastBox">
			<div class="toast1" id="loadingToast"><i class="fa-solid fa-circle-arrow-up"></i> 업로드 진행 중...</div>
		</div>
		
		</div>
	</div>
	<!-- <footer>
	푸터
	</footer> -->
</body>
</html>
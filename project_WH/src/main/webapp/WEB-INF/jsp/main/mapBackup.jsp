<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
<script
   src="https://cdn.rawgit.com/openlayers/openlayers.github.io/master/en/v6.15.1/build/ol.js"></script>
<link rel="stylesheet"
   href="https://cdn.jsdelivr.net/npm/ol@v6.15.1/ol.css">
<style type="text/css">
.map {
	height: 1060px;
	width: 100%;
}
</style>
<script type="text/javascript">
$( document ).ready(function() {
	let map = new ol.Map({ // OpenLayer의 맵 객체를 생성한다.
	    target: 'map', // 맵 객체를 연결하기 위한 target으로 <div>의 id값을 지정해준다.
	    layers: [ // 지도에서 사용 할 레이어의 목록을 정희하는 공간이다.
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
	
	/* //request=GetMap&width=557&height=768&styles=
	var wms = new ol.layer.Tile({
		source : new ol.source.TileWMS({
			url : 'http://localhost/geoserver/cite/wms?service=WMS', // 1. 레이어 URL
			params : {
				'VERSION' : '1.1.0', // 2. 버전
				'LAYERS' : 'cite:tl_bjd', // 3. 작업공간:레이어 명
				'BBOX' : [1.3873946E7, 3906626.5, 1.4428045E7, 4670269.5], 
				'SRS' : 'EPSG:3857', // SRID
				'FORMAT' : 'image/png' // 포맷
			},
			serverType : 'geoserver',
		})
	});
	
	map.addLayer(wms); // 맵 객체에 레이어를 추가함 */
	
	//request=GetMap&width=557&height=768&styles=
	var wms = new ol.layer.Tile({
		source : new ol.source.TileWMS({
			url : 'http://localhost/geoserver/cite/wms?service=WMS', // 1. 레이어 URL
			params : {
				'VERSION' : '1.1.0', // 2. 버전
				'LAYERS' : 'cite:tl_bjd', // 3. 작업공간:레이어 명
				'BBOX' : [1.3873946E7, 3906626.5, 1.4428045E7, 4670269.5], 
				'SRS' : 'EPSG:3857', // SRID
				'FORMAT' : 'image/png' // 포맷
			},
			serverType : 'geoserver',
		})
	});
	
	map.addLayer(wms); // 맵 객체에 레이어를 추가함
	
	var wms2 = new ol.layer.Tile({
		source : new ol.source.TileWMS({
			url : 'http://localhost/geoserver/cite/wms?service=WMS', // 1. 레이어 URL
			params : {
				'VERSION' : '1.1.0', // 2. 버전
				'LAYERS' : 'cite:tl_sgg', // 3. 작업공간:레이어 명
				'BBOX' : [1.3873946E7, 3906626.5, 1.4428045E7, 4670269.5], 
				'SRS' : 'EPSG:3857', // SRID
				'FORMAT' : 'image/png' // 포맷
			},
			serverType : 'geoserver',
		})
	});
	
	map.addLayer(wms2); // 맵 객체에 레이어를 추가함
	
	var wms3 = new ol.layer.Tile({
		source : new ol.source.TileWMS({
			url : 'http://localhost/geoserver/cite/wms?service=WMS', // 1. 레이어 URL
			params : {
				'VERSION' : '1.1.0', // 2. 버전
				'LAYERS' : 'cite:tl_sd', // 3. 작업공간:레이어 명
				'BBOX' : [1.3873946E7, 3906626.5, 1.4428045E7, 4670269.5], 
				'SRS' : 'EPSG:3857', // SRID
				'FORMAT' : 'image/png' // 포맷
			},
			serverType : 'geoserver',
		})
	});
	
	map.addLayer(wms3); // 맵 객체에 레이어를 추가함
});
</script>
</head>
<body>
<main>
<article>
	<div id="map" class="map"></div>
</article>
</main>
</body>
</html>
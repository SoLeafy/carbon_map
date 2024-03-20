<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>   
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta name="viewport" content="width=device-width,initial-scale=1.0">
	<title>브이월드 오픈API</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"> 
<title>2DMap</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="https://map.vworld.kr/js/map/OpenLayers-2.13/OpenLayers-2.13.js"></script>
<script src="https://map.vworld.kr/js/apis.do?type=Base&apiKey=${apiKey}&domain=${apiDomain}"></script>
<script type="text/javascript" src="resources/js/ol.js"></script>
<link rel="stylesheet" href="resources/css/ol.css" type="text/css">
<script>
var map;
var mapBounds = new OpenLayers.Bounds(123 , 32, 134 , 43);
var mapMinZoom = 7;
var mapMaxZoom = 19;

// avoid pink tiles
OpenLayers.IMAGE_RELOAD_ATTEMPTS = 3;
OpenLayers.Util.onImageLoadErrorColor = "transparent";

function init(){
var options = {
	controls: [],
	projection: new OpenLayers.Projection("EPSG:900913"),
	displayProjection: new OpenLayers.Projection("EPSG:4326"),
	units: "m",
	controls : [],
	numZoomLevels:21,
	maxResolution: 156543.0339,
	maxExtent: new OpenLayers.Bounds(-20037508.34, -20037508.34, 20037508.34, 20037508.34)
	};
map = new OpenLayers.Map('map', options);

var options = {serviceVersion : "",
	layername: "",
	isBaseLayer: false,
	opacity : 1,
	type: 'png',
	transitionEffect: 'resize',
	tileSize: new OpenLayers.Size(256,256),
	min_level : 7,
	max_level : 18,
	buffer:0};
//======================================
//1. 배경지도 추가하기
vBase = new vworld.Layers.Base('VBASE');
if (vBase != null){map.addLayer(vBase);}
//2. 영상지도 추가하기
vSAT = new vworld.Layers.Satellite('VSAT');
if (vSAT != null) {map.addLayer(vSAT);};
//3. 하이브리드지도 추가하기
vHybrid = new vworld.Layers.Hybrid('VHYBRID');
if (vHybrid != null) {map.addLayer(vHybrid);} 
//6. White지도 추가하기
vWhite = new vworld.Layers.White('VWHITE');
if (vWhite != null){map.addLayer(vWhite);}
//5. Midnight지도 추가하기
vMidnight = new vworld.Layers.Midnight('VMIDNIGHT');
if (vMidnight != null){map.addLayer(vMidnight);}
//===========================================

var switcherControl = new OpenLayers.Control.LayerSwitcher();
map.addControl(switcherControl);
switcherControl.maximizeControl();

map.zoomToExtent( mapBounds.transform(map.displayProjection, map.projection ) );
map.zoomTo(11);
	
map.addControl(new OpenLayers.Control.PanZoomBar());
//map.addControl(new OpenLayers.Control.MousePosition());
map.addControl(new OpenLayers.Control.Navigation());
//map.addControl(new OpenLayers.Control.MouseDefaults()); //2.12 No Support
map.addControl(new OpenLayers.Control.Attribution({separator:" "}))
}
function deleteLayerByName(name){
for (var i=0, len=map.layers.length; i<len; i++) {
	var layer = map.layers[i];
	if (layer.name == name) {
		map.removeLayer(layer);
		//return layer;
		break;
	}
}
}

let serviceUrl = "http://localhost/geoserver/cite/wms?";

let wmsTest = new OpenLayers.Layer.WMS(
		"Main", 
		serviceUrl, 
		{
			layers: '법정읍/면/동,행정읍/면/동,건물', 
			styles: '법정읍/면/동,행정읍/면/동,건물', 
			format: 'image/png', 
			version: '1.1.0', 
			CRS: 'EPSG:3857'
		}, 
		{
			singleTile: false, 
			transitionEffect: 'resize'
		}
		);
map.addLayer(wmsTest);
map.setBaseLayer(wmsTest);
map.zoomToMaxExtent();

/* var wms = new ol.layer.Tile({
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

$( document ).ready(function() {
	
	
	/* let map2 = new ol.Map({ // OpenLayer의 맵 객체를 생성한다.
	    target: 'map', // 맵 객체를 연결하기 위한 target으로 <div>의 id값을 지정해준다.
	    layers: [ // 지도에서 사용 할 레이어의 목록을 정희하는 공간이다.
	      new ol.layer.Tile({
	        source: new ol.source.OSM({
	          url: 'https://maps.wikimedia.org/osm-intl/{z}/{x}/{y}.png' // vworld의 지도를 가져온다.
	        })
	      })
	    ],
	    view: new ol.View({ // 지도가 보여 줄 중심좌표, 축소, 확대 등을 설정한다. 보통은 줌, 중심좌표를 설정하는 경우가 많다.
	      center: ol.proj.fromLonLat([128.4, 35.7]),
	      zoom: 7
	    })
	}); */
	
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
});





</script>
<style>
.olControlAttribution {
right: 20px;
}

.olControlLayerSwitcher {
right: 20px;
top: 20px;
}
</style>
</head>
<body onload="init()">
<div id="map" style="height: 600px;"></div>
<div>
	<button type="button"
onclick="javascript:deleteLayerByName('VHYBRID');" name="rpg_1">레이어삭제하기</button>
</div>		   
</body>
</html>
function showResultToast(msg) {
	let toast = document.createElement('div');
	toast.classList.add('toast1');
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
function makeLegend(legendOpt, layerArr, district, divNum) { // dist - 0: 전국, 1: 시도, 2: 시군구
	let target = document.querySelector("#legendDiv");
	target.innerHTML = '';
	
	let table = `
		<table id="legendTable" class="table">
			<thead style="text-align: center">
				<tr>
					<th>색상</th>
					<th>범위(kWh)</th>
				</tr>
			</thead>
			<tbody>
				{{__row__}}
			</tbody>
		</table>
	`;
	const rowsArr = [];

	if(legendOpt == 1) { // 등간격
		layerArr.forEach(layer => {
			layer.getSource().updateParams({'STYLES' : "황사dgg_grade"});
		});
		// 범례 가져와
		$.ajax({
			url: "/dggLegend.do",
			type: "post",
			dataType: "json",
			data: {opt : district, div: divNum},
			global: false, 
			success: function(data) {
				//console.log(data);
				for(let i = 0; i < 5; i++) {
					let row = `
						<tr>
							<td class="{{__color__}}"></td>
							<td>{{__val__}}</td>
						</tr>
					`;
					let colorCode = i + 1;
					let rowData = data[i].start.toLocaleString('ko-KR') + " ~ " + data[i].end.toLocaleString('ko-KR');
					row = row.replace("{{__color__}}", "dggColor"+colorCode);
					row = row.replace("{{__val__}}", rowData);
					rowsArr.push(row);
				}
				table = table.replace("{{__row__}}", rowsArr.join(''));
				target.innerHTML = table;
			},
			error: function(err) {
				console.log(err);
			}
		});
	} else if (legendOpt == 2) { // 내추럴 브레이크
		layerArr.forEach(layer => {
			layer.getSource().updateParams({'STYLES' : "grade"});
		});
		// 범례 가져와
		$.ajax({
			url: "/nbLegend.do",
			type: "post",
			dataType: "json",
			data: {opt : district, div: divNum},
			global: false, 
			success: function(data) {
				//console.log(data);
				for(let i = 0; i < 5; i++) {
					let row = `
						<tr>
							<td class="{{__color__}}"></td>
							<td>{{__val__}}</td>
						</tr>
					`;
					let colorCode = i + 1;
					let rowData = data[i].start.toLocaleString('ko-KR') + " ~ " + data[i].end.toLocaleString('ko-KR');
					row = row.replace("{{__color__}}", "nbColor"+colorCode);
					row = row.replace("{{__val__}}", rowData);
					rowsArr.push(row);
				}
				table = table.replace("{{__row__}}", rowsArr.join(''));
				target.innerHTML = table;
			},
			error: function(err) {
				console.log(err);
			}
		});
	}
}

function makeTable(district, serverData) {
   	  let template = `
   		  <table class='table table-hover'>
   		    <thead>
   		        <tr>
   		            <th>{{__district__}}별</th>
   		            <th>소비량(kWh)</th>
   		        </tr>
   		    </thead>
   		    <tbody>
   		        {{__rows__}}
   		    </tbody>
   		</table>
   	  `;
   	  template = template.replace('{{__district__}}', district);
   	  
   	  const tempArr = [];
   	  
   	  for(let i = 0; i < serverData.length; i++) {
   		  let rowTemplate = `
	    		<tr>
   		            <td>{{__district__}}</td>
   		            <td>{{__usage__}}</td>
   		        </tr>
	    	  `;
	      
	      let names = district == '시군구' ? serverData[i].sgg_nm : serverData[i].sd_nm;
	      rowTemplate = rowTemplate.replace('{{__district__}}', names);
   		  rowTemplate = rowTemplate.replace('{{__usage__}}', serverData[i].totusage.toLocaleString('ko-KR'));
   		  tempArr.push(rowTemplate);
   	  }
   	  
   	  template = template.replace('{{__rows__}}', tempArr.join(''));
   	  document.querySelector("#dataTable").innerHTML = template;
}

// 페이지 옮기기 --------------------------------------------------
	function selectPage(selectionToShow, selectedMenu) {
		let selection = document.querySelector(selectionToShow);
		// selection 제외한 드롭다운
		let ddToErase = Array.from(document.getElementsByClassName("ddWrapper")).filter(e => !e.isSameNode(selection));
		let menu = document.querySelector(selectedMenu);
		// 선택된 menu 제외한 메뉴
		let menuToUnselect = Array.from(document.getElementsByClassName("menuLink")).filter(e => !e.isSameNode(menu));
		selection.style.display = 'block';
		menu.classList.add('selectedMenu');
		ddToErase.forEach(e => e.style.display = 'none');
		menuToUnselect.forEach(e => e.classList.remove('selectedMenu'));
	}
	
	

/*let toastElList = [].slice.call(document.querySelectorAll('.toast'))
let toastList = toastElList.map(function (toastEl) {
  return new bootstrap.Toast(toastEl, option)
})
toastList.forEach(toast => toast.show());*/
/*const toastTrigger = document.getElementById('liveToastBtn')
const toastLiveExample = document.getElementById('liveToast')

if (toastTrigger) {
  const toastBootstrap = bootstrap.Toast.getOrCreateInstance(toastLiveExample)
  toastTrigger.addEventListener('click', () => {
    toastBootstrap.show()
  })
}*/
/*$(function() {
	let toastBox = document.getElementById('toastBox');
	let loadingMsg = '로딩 중';
	let successMsg = '파일 업로드 성공';
	let failMsg = '파일 업로드 실패';
	
	function showToast(msg) {
		let toast = document.createElement('div');
		toast.classList.add('toast');
		toast.innerHTML = msg;
		toastBox.appendChild(toast);
	}
});*/
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
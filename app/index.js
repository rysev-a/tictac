window.onload = ()=> {
  console.log('start');
  var el = document.getElementById('app')
  setTimeout(function () {
    el.innerHTML = 'loading ok'
  }, 1000);
  
}

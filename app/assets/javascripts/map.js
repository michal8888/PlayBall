  function initMapOn(latSelected, lngSelected) {
    var myLatLng = {lat: latSelected, lng: lngSelected};

    var map = new google.maps.Map(document.getElementById('map'), {
      zoom: 12,
      center: myLatLng
    });

    var marker = new google.maps.Marker({
      position: myLatLng,
      map: map,
      title: 'Hello World!'
    });
  }

window.onload = function(){
  var long = parseFloat($("#inputLongitude").val());
  var lat = parseFloat($("#inputLatitude").val());
  setTimeout(function(){
    initMapOn(lat, long);
  }, 50)
}
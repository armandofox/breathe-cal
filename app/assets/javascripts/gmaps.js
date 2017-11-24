// This example adds a search box to a map, using the Google Place Autocomplete
// feature. People can enter geographical searches. The search box will return a
// pick list containing a mix of places and predicted search terms.

// This example requires the Places library. Include the libraries=places
// parameter when you first load the API. For example:
// <script src="https://maps.googleapis.com/maps/api/js?key=YOUR_API_KEY&libraries=places">
var fetchedMarkers = {};

function initAutocomplete() {
  
  var labelNum = 0;
  
  function point2LatLng(point, map) {
    var topRight = map.getProjection().fromLatLngToPoint(map.getBounds().getNorthEast());
    var bottomLeft = map.getProjection().fromLatLngToPoint(map.getBounds().getSouthWest());
    var scale = Math.pow(2, map.getZoom());
    var worldPoint = new google.maps.Point(point.x / scale + bottomLeft.x, point.y / scale + topRight.y);
    return map.getProjection().fromPointToLatLng(worldPoint);
  }
  
  // Responsible for populating the markers on the map with the 'GET markers' request, which invokes markers#show
  function fetchMarkers(){
    deleteMarkers();
    labelNum = 0;
    var bounds = map.getBounds();
    var NECorner = bounds.getNorthEast();
    var SWCorner = bounds.getSouthWest();
    $.ajax({
      type: "GET",
      contentType: "application/json; charset=utf-8",
      url: "/markers",
      data: {bounds :{uplat:NECorner.lat(),downlat:SWCorner.lat(),rightlong:NECorner.lng(),leftlong:SWCorner.lng()}},
      success: function(data){
        for(var i=0;i<data.length; i++){
          var id = data[i].id;
          if (true){
            var location = {};
            location.lat = parseFloat(data[i].lat);
            location.lng = parseFloat(data[i].lng);
            labelNum += 1;
            var marker = new google.maps.Marker({
                  label: labelNum.toString(),
                  position: location,
                  map: map,
                  draggable: false,
                  });
            var newContent = createContentString(data[i]);      
            marker.info = new google.maps.InfoWindow();
            marker.info.setContent(newContent[0]);
            google.maps.event.addListener(marker, 'click', function(){
              this.info.open(map, this);
            });
            markers.push(marker);
          }
        }
      }
    })
  }
  // Map initialization
  var map = new google.maps.Map(document.getElementById('map'), {
    center: {
      lat: 37.8716,
      lng: -122.2727
    },
    zoom: 13,
    mapTypeId: 'roadmap'
  });
  var geocoder = new google.maps.Geocoder();
  // Resize trigger
  google.maps.event.addDomListener(window, "resize", function() {
    var center = map.getCenter();
    google.maps.event.trigger(map, "resize");
    map.setCenter(center); 
    }
  );
  // Setting css attributes
  $('#marker-cta').css('cursor','pointer');
  $('#left-col').css('height', (window.innerHeight).toString());
  $('#right-col').css('height', (window.innerHeight).toString());
  $('#detail-box').css('height', (window.innerHeight - 50 - 50 - 50 - 50).toString());
  $('#detail-box-mask').css('height', (window.innerHeight - 50 - 50 - 50 - 50).toString());
  
  // Create the search box and link it to the UI element.
  var input = document.getElementById('pac-input');
  var searchBox = new google.maps.places.SearchBox(input);
  map.controls[google.maps.ControlPosition.TOP_LEFT].push(input);
  
  var markerEnabler = document.getElementById('marker-cta');
  map.controls[google.maps.ControlPosition.LEFT_TOP].push(markerEnabler);

  // Bias the SearchBox results towards current map's viewport
  map.addListener('bounds_changed', function() {searchBox.setBounds(map.getBounds()); });

  google.maps.event.addListener(map, 'dragend', function(){ fetchMarkers(); })

  var markers = [];

  searchBox.addListener('places_changed', function() {
      var places = searchBox.getPlaces();
      if (places.length === 0) {
        return;
    }
    markers.forEach(
      function(marker) {
        marker.setMap(null);
    });
    markers = [];

    var bounds = new google.maps.LatLngBounds();
    // Place = google's best reccommended city
    place = places[0];
    if (!place.geometry) {
        console.log("Returned place contains no geometry");
        return;
      }
      var icon = {
        url: place.icon,
        size: new google.maps.Size(71, 71),
        origin: new google.maps.Point(0, 0),
        anchor: new google.maps.Point(17, 34),
        scaledSize: new google.maps.Size(25, 25)
      };
      // POST the city data
      $.ajax({
        type: "POST",
        contentType: "application/json; charset=utf-8",
        url: "city_data",
        data: JSON.stringify({geo: place.geometry.location, name: place.name}),
        success: function(data){
          $("#city-info").text(JSON.stringify(data));
        }
      });
      
      markers.push(new google.maps.Marker({
        map: map,
        icon: icon,
        title: place.name,
        position: place.geometry.location
      }));

      if (place.geometry.viewport) {
        bounds.union(place.geometry.viewport);
      }
      else {
        bounds.extend(place.geometry.location);
      }
    map.fitBounds(bounds);
    fetchMarkers();
  });
  
  var canMark = false;
 
  // Runs when user places marker
  $("#marker-cta").click(function(){
    if (recentMarker === null){
      map.setOptions({ draggableCursor :"url(https://maps.google.com/mapfiles/ms/micons/red-dot.png), auto"});
      $("#marker-cta").css("cursor", "url(https://maps.google.com/mapfiles/ms/micons/red-dot.png), auto");
      canMark = true;  
    } else {
      canMark = false;
    }
    $("#marker-cta span").text("Click map to place marker")
  });
  
  // function click_marker_cta(){
  //   // We can add a marker
  //   if (recentMarker === null){
  //     map.setOptions({ draggableCursor :"url(https://maps.google.com/mapfiles/ms/micons/red-dot.png), auto"});
  //     $("#marker-cta").css("cursor", "url(https://maps.google.com/mapfiles/ms/micons/red-dot.png), auto");
  //     canMark = true;  
  //   // We can't add a marker
  //   } else {
  //     canMark = false;
  //   }
  // }
 
  // // If user clicks to put a marker down
  // $("#marker-cta").click( function(){ 
  //     click_marker_cta();
  //     $("#marker-cta span").text("Click map to place marker")
  //   }
  // );

  // Waits for user to click on the map and place their allergen
  google.maps.event.addListener(map, 'click', function(event) {
    if (canMark){
      var x = event.pixel.x + 16;
      var y = event.pixel.y + 32;
      var point = {};
      point.x = x;
      point.y = y;
      var latlng = point2LatLng(point, map);
      placeMarker(latlng);
      canMark = false;
      map.setOptions({ draggableCursor :"auto"});
      $("#marker-cta").css("cursor", "pointer");
      $("#marker-cta span").text("Click here to add an allergen");
    }
  });
  
  var recentMarker = null;
  
  // Create string to display in infowindow
  function createContentString(data){
    var title = data.title;
    var attributes = ["cat", "bees", "perfume", "oak", "peanut", "gluten", "dog", "dust", "smoke", "mold"];
    var leftContentString = "";
    var rightContentString = "";
    for(var i=0; i<attributes.length/2; i++){
      if (data[attributes[i]]){
        leftContentString += attributes[i] + "<br>";  
      }
    }
    for(i=attributes.length/2; i<attributes.length; i++){
      if (data[attributes[i]]){
        rightContentString += attributes[i] + "<br>";  
      }
    }
    var contentString ="<div id='wrap'>" + 
                      "<form id='markerDetails' action='delete' method='POST'>"+
                      "Allergens at " + title + "<br>" +
                      "<div id='left_col'>" + 
                      leftContentString + 
                      "</div>" + 
                      "<div id='right_col'>" + 
                      rightContentString +
                      "</div>" + 
                      "<input type='button' value='Delete'>"+
                      "</form>" +
                      "</div>";
    var content = $(contentString);
    return content;
  }
  
  // Called when a user clicks to place a marker
  function placeMarker(location) {
    labelNum += 1;
    // Create new mmaps marker object
    var marker = new google.maps.Marker({
      label: labelNum.toString() ,
      position: location,
      map: map,
      draggable: true,
    })
    
    // Create form to display to user so they can add an allergen
    var contentString = $(
      "<div id='wrap'>" + 
      "<form id='markerForm' action='markers' method='POST'>"+
      "Title <input type='text' name='title'> <br>" + 
      "<div id='left_col'>" + 
      "<input type = 'checkbox' name='cat' value='true'> Cats <br>"+
      "<input type = 'checkbox' name='bees' value='true'> Bees <br>"+
      "<input type = 'checkbox' name='perfume' value='true'> Perfume <br>"+
      "<input type = 'checkbox' name='oak' value='true'> Oak <br>"+
      "<input type = 'checkbox' name='peanut' value='true'> Peanut <br>"+
      "</div>" +
      "<div id='right_col'>" + 
      "<input type = 'checkbox' name='gluten' value='true'> Gluten <br>"+
      "<input type = 'checkbox' name='dog' value='true'> Dogs <br>"+
      "<input type = 'checkbox' name='dust' value='true'> Dust <br>"+
      "<input type = 'checkbox' name='smoke' value='true'> Smoke <br>"+
      "<input type = 'checkbox' name='mold' value='true'> Mold <br>"+
      "</div>" +
      "<input type='submit' value='Submit'>"+
      "</form>" +
      "</div>"
    );
    
    // Display the form above to the user in an infowindow
    var infowindow = new google.maps.InfoWindow();
    infowindow.open(map,marker);
    infowindow.setContent(contentString[0]);
    marker.infowindow = infowindow;
    google.maps.event.addListener(marker, 'click', function(){
      marker.infowindow.open(map,marker);
    });
    
    recentMarker = marker;
    
    // Close the window and remove the created marker if the user exits
    var listenerHandle = google.maps.event.addListener(infowindow, 'closeclick', function(){
      labelNum -=1;
      recentMarker.setMap(null);
      recentMarker = null;
    });
    
    // disallow marker spawn if its already here. this means i need the UniqueID 
    // Close the create allergen menu on form submission, POST marker object
    $(document).on('submit', '#markerForm', function(e){
      e.preventDefault();
      infowindow.close();
      var postData = $(this).serializeArray();
      postData.push({name: "lat", value: location.lat()});
      postData.push({name: "lng", value: location.lng()});
      // Populate an array we pass into the POST request
      var convData = {};
      $(postData).each(function(index, obj){
        convData[obj.name] = obj.value;
      })
      
      $.ajax({
        type: "POST",
        contentType: "application/json; charset=utf-8",
        url: "/markers",
        data: JSON.stringify({marker: convData}),
        success: function(d){
          fetchedMarkers[d.id] = true;
          var newContent = createContentString(d);
          recentMarker.infowindow.setContent(newContent[0]);
          recentMarker.infowindow.open(map,recentMarker);
          recentMarker.draggable = false;
          recentMarker = null;
          google.maps.event.removeEventListener(listenerHandle);
          markers.push(recentMarker);
        }
      })
      return false;
    });
    
    $(document).on('button', '#markerDetails', function(e){
      e.preventDefault();
      infowindow.close();
      var postData = $(this).serializeArray();
      postData.push({name: "title", value: data.title});
      // Populate an array we pass into the POST request
      var convData = {};
      $(postData).each(function(index, obj){
        convData[obj.name] = obj.value;
      })
      
      $.ajax({
        type: "POST",
        contentType: "application/json; charset=utf-8",
        url: "/delete",
        data: JSON.stringify({marker: convData}), //what does this do?
        success: function(d){ //what is d?
          /*fetchedMarkers[d.id] = true;
          var newContent = createContentString(d);
          recentMarker.infowindow.setContent(newContent[0]);
          recentMarker.infowindow.open(map,recentMarker);
          recentMarker.draggable = false;
          recentMarker = null;
          google.maps.event.removeEventListener(listenerHandle);
          markers.push(recentMarker);*/
          //THE BELOW CODE HAS BEEN COMMENTED OUT, BUT WAS MY ATTEMPT AT FINDING A MARKER AND REMOVING IT
          //recentMarker = //Marker.find(conditions => {title => title});
          //markers.pop(recentMarker)
        }
      })
      return false;
    });
  }
  
  //  
  function setMapOnAll(map) {
    for (var i = 0; i < markers.length; i++) {
      markers[i].setMap(map);
    }
  }
  
  // Clears all markers
  function clearMarkers() {
    setMapOnAll(null);
  }

  // Delete all markeres
  function deleteMarkers() {
    clearMarkers();
    markers = [];
  }
}

$(document).ready(initAutocomplete);
$(document).on('page:load', initAutocomplete);
$(document).on('page:change', initAutocomplete);







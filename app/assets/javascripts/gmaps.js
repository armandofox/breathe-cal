// This example requires the Places library. Include the libraries=places
// parameter when you first load the API. For example:
// <script src="https://maps.googleapis.com/maps/api/js?key=YOUR_API_KEY&libraries=places">
  
    var map = null;
    var geocoder = null;
    var markers = [];
    var recentMarker = null;
  
<<<<<<< HEAD
    // Loads the map and page attributes
    function loadMap() {
        // Initialize map, set css attributes, search boxes, and buttons
        $('#marker-cta').css('cursor','pointer');
        $('#left-col').css('height', (window.innerHeight).toString());
        $('#right-col').css('height', (window.innerHeight).toString());
        $('#detail-box').css('height', (window.innerHeight - 50 - 50 - 50 - 50).toString());
        $('#detail-box-mask').css('height', (window.innerHeight - 50 - 50 - 50 - 50).toString());
      
        map = new google.maps.Map(document.getElementById('map'), {
            // TODO: Set location to user's current location
            center: {
                lat: 37.8716,
                lng: -122.2727
            },
            zoom: 13,
            mapTypeId: 'roadmap'
        });
        geocoder = new google.maps.Geocoder();
    
        var input = document.getElementById('pac-input');
        var searchBox = new google.maps.places.SearchBox(input);
        map.controls[google.maps.ControlPosition.TOP_LEFT].push(input);
=======
  function point2LatLng(point, map) {
    var topRight = map.getProjection().fromLatLngToPoint(map.getBounds().getNorthEast());
    var bottomLeft = map.getProjection().fromLatLngToPoint(map.getBounds().getSouthWest());
    var scale = Math.pow(2, map.getZoom());
    var worldPoint = new google.maps.Point(point.x / scale + bottomLeft.x, point.y / scale + topRight.y);
    return map.getProjection().fromPointToLatLng(worldPoint);
  }
  
  function fetchMarkers(){
    deleteMarkers();
    labelNum = 0;
    var bounds = map.getBounds();
    var NECorner = bounds.getNorthEast();
    var SWCorner = bounds.getSouthWest();
    $.ajax({
      type: "GET",
      contentType: "application/json; charset=utf-8",
      url: "markers",
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
  
  
  var map = new google.maps.Map(document.getElementById('map'), {
    center: {
      lat: 37.8716,
      lng: -122.2727
    },
    zoom: 13,
    mapTypeId: 'roadmap'
  });
  
  var geocoder = new google.maps.Geocoder();
  
  google.maps.event.addDomListener(window, "resize", function() {
   var center = map.getCenter();
   google.maps.event.trigger(map, "resize");
   map.setCenter(center); 
  });
  
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


  // Bias the SearchBox results towards current map's viewport.
  map.addListener('bounds_changed', function() {
    searchBox.setBounds(map.getBounds());
  });

  google.maps.event.addListener(map, 'dragend', function(){
    fetchMarkers();
  })

  var markers = [];

  searchBox.addListener('places_changed', function() {
    var places = searchBox.getPlaces();


    if (places.length === 0) {
      return;
    }

    markers.forEach(function(marker) {
      marker.setMap(null);
    });
    markers = [];

    var bounds = new google.maps.LatLngBounds();
    // place = google's best reccommended city
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
      
      // TODO mapsearch_data = {geo: place.geometry.location, name:place.name}

      $.ajax({
        type: "POST",
        contentType: "application/json; charset=utf-8",
        url: "map_search",
        data: JSON.stringify({geo: place.geometry.location, name: place.name}),
        success: function(data){
          $("#city-info").text(JSON.stringify(data));
          console.log(place);
          
        }
      });
>>>>>>> [not working] in the process of map_search modification. redirect currently does not work
      
        var markerEnabler = document.getElementById('marker-cta');
        map.controls[google.maps.ControlPosition.LEFT_TOP].push(markerEnabler);
      
        // Set listeners
        google.maps.event.addDomListener(window, "resize", function() {
            var center = map.getCenter();
            google.maps.event.trigger(map, "resize");
            map.setCenter(center); 
        });
      
        map.addListener('bounds_changed', function() {
            searchBox.setBounds(map.getBounds());
            fetchMarkers();
        });
      
        google.maps.event.addListener(map, 'dragend', function(){ 
            fetchMarkers();
        })
    
        searchBox.addListener('places_changed', function() {
            var places = searchBox.getPlaces();
            if (places.length === 0) {
                return;
            } // Remove all markers from map before changing bounds
            deleteMarkers();
            var bounds = new google.maps.LatLngBounds();
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
            if (place.geometry.viewport) {
                bounds.union(place.geometry.viewport);
            } else {
                bounds.extend(place.geometry.location);
            }
            map.fitBounds(bounds);
            fetchMarkers();
        });
        
        canMark = false
        
        $("#marker-cta").click(function(){
            // TODO: Figure out the recentmarker relevance; when would a user actually not be able to mark? 
            if (recentMarker === null){
                map.setOptions({ draggableCursor :"url(https://maps.google.com/mapfiles/ms/micons/red-dot.png), auto"});
                $("#marker-cta").css("cursor", "url(https://maps.google.com/mapfiles/ms/micons/red-dot.png), auto");
                canMark = true;
                google.maps.event.addListener(map, 'click', function(event) {
                    if (canMark) {
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
            } else {
                canMark = false;
            }
            $("#marker-cta span").text("Click map to place marker")
        });
    }
        
    //     $("#marker-cta").click(function() {
    //         if (recentMarker === null) {
    //             map.setOptions({ draggableCursor :"url(https://maps.google.com/mapfiles/ms/micons/red-dot.png), auto"});
    //             $("#marker-cta").css("cursor", "url(https://maps.google.com/mapfiles/ms/micons/red-dot.png), auto");
    //             $("#marker-cta span").text("Click map to place marker")
    //             clickToPlace = google.maps.event.addListener(map, 'click', function(event) {
    //                 var x = event.pixel.x + 16;
    //                 var y = event.pixel.y + 32;
    //                 var point = {};
    //                 point.x = x;
    //                 point.y = y;
    //                 var latlng = point2LatLng(point, map);
    //                 placeMarker(latlng);
    //                 canMark = false;
    //                 map.setOptions({ draggableCursor :"auto"});
    //                 $("#marker-cta").css("cursor", "pointer");
    //                 $("#marker-cta span").text("Click here to add an allergen");
    //                 google.maps.event.removeListener(clickToPlace)
    //             });
    //         }
    //     });
    // }
  
    // Helper function to converta point to lat and long
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
        var bounds = map.getBounds();
        var NECorner = bounds.getNorthEast();
        var SWCorner = bounds.getSouthWest();
        $.ajax({
            type: "GET",
            contentType: "application/json; charset=utf-8",
            url: "/markers",
            data: {bounds :{uplat:NECorner.lat(),downlat:SWCorner.lat(),rightlong:NECorner.lng(),leftlong:SWCorner.lng()}},
            success: function(data) {
                for (var i = 0; i < data.length; i++) {
                    var id = data[i].id;
                    if (true) {
                      var location = {};
                      location.lat = parseFloat(data[i].lat);
                      location.lng = parseFloat(data[i].lng);
                      var marker = new google.maps.Marker({
                            id: id,
                            position: location,
                            map: map,
                            draggable: false,
                      });
                      var newContent = createMarkerDetails(data[i]);      
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
    
    // Create string to display in infowindow
    function createMarkerDetails(data){
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
        var markerDetails ="<div id='wrap'>" + 
                        "<form id='markerDetails' action='delete' method='POST'>"+
                        "Allergens at " + title + "<br>" +
                        "<div id='left_col'>" + 
                        leftContentString + 
                        "</div>" + 
                        "<div id='right_col'>" + 
                        rightContentString +
                        "</div>" + 
                        // TODO: Add delete functionality 
                        // "<input type='button' value='Delete' onclick='removeMarker()'>"+
                        "<input type='button' value='Delete'>"+
                        "</form>" +
                        "</div>";
        var content = $(markerDetails);
        return content;
    }
    
    // Called when a user clicks to place a marker
    function placeMarker(location) {
      
        // Create the marker to display infowindow
        var marker = new google.maps.Marker({
            position: location,
            map: map,
            draggable: false,
        });
        recentMarker = marker;
      
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
      
        // Display the form above to the user in marker's infowindow, replacing the old infowindow
        var infowindow = new google.maps.InfoWindow();
        infowindow.open(map,marker);
        infowindow.setContent(contentString[0]);
        marker.infowindow = infowindow;
        google.maps.event.addListener(marker, 'click', function(){
            marker.infowindow.open(map, marker);
        });
      
        // Close the window and remove the created marker if the user exits
        var listenerHandle = google.maps.event.addListener(infowindow, 'closeclick', function(){
            // marker = infowindow.anchor
            // if (marker) {
            //     infowindow.anchor.setMap(null)
            // }
            // if (recentMarker) {
            //     recentMarker = null;
            // }
            if (recentMarker) {
                //infowindow.anchor.setMap(null)   //POTENTIAL REPLACEMENT
                recentMarker.setMap(null);
                // We keep this line because recentmarker should only be truthy if we are in the POST markers call to access the marker object and put the id in
                recentMarker = null;
            }
        });
      
        // POST Marker object on form submission
        $(document).on('submit', '#markerForm', function(e){
            e.preventDefault();
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
                url: "/markers/",
                data: JSON.stringify({marker: convData}),
                success: function(d){
                    if (recentMarker) {
                        var newContent = createMarkerDetails(d);
                        // TODO: Set marker id here to retrieve on click in case of deletion
                        recentMarker.infowindow.close()
                        recentMarker.infowindow.setContent(newContent[0]);
                        recentMarker.infowindow.open(map, recentMarker);
                        recentMarker.draggable = false;
                        // recentMarker.set('id', id);
                        markers.push(recentMarker);
                        recentMarker = null;
                        google.maps.event.removeListener(listenerHandle);
                    }
                }
            })
            return false;
        });
    }
    
    // Removes one marker, triggered from specific marker's infowindow's delete button
    function removeMarker() {
        marker = infowindow.anchor;
        id = marker.id;
        infowindow.close();
        // POSTS the marker id to the markers#destroy controller method
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "/delete/" + id,
            // data: JSON.stringify({id: id}),
            success: function(d){
                marker.setMap(null)
                recentMarker = null
                google.maps.event.removeEventListener(listenerHandle);
            }
        })
        return false;
    }
    
    // Shows all markers
    function setMapOnAll(map) {
        for (var i = 0; i < markers.length; i++) {
            marker = markers[i]
            marker.setMap(map);
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
  
  $(document).ready(loadMap);
  $(document).on('page:load', loadMap);
  $(document).on('page:change', loadMap);

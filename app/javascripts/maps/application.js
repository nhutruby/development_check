//MAPPING FUNCTIONS
var center = null;
var map = null;
var geocoder = null;
var addresses = null;
var mgr = null;
var all_markers = [];
var HEADER_HEIGHT = 18;
var CENTER_LAT = 45;
var CENTER_LNG = -95;
var DEFAULT_ZOOM = 4;
var SEARCH_MARKERS = [];
var GLOBALSEARCH= false;
var infoWindows = [];

function addToInfoWindows(item) {
  infoWindows.push(item);
}

function closeAllInfoWindows() {
  jQuery.each(infoWindows, function(index, item) {
    item.close();
  });
}

//TODO: remove code duplication with show_markers_on_page
function show_google_maps() {
  var myLatlng = new google.maps.LatLng(CENTER_LAT, CENTER_LNG);
  var zoom_value = DEFAULT_ZOOM;
  var myOptions = {
    zoom: zoom_value,
    center: myLatlng,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };
  map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
}

function show_markers_on_page(locations, showBaloons) {
  //don't show map if no locations
  if (locations.length === 0) {
    return;
  }

  var myLatlng = new google.maps.LatLng(CENTER_LAT, CENTER_LNG);
  var zoom_value = DEFAULT_ZOOM;
  if(locations.length === 1) {
    zoom_value = 16;
  }
  var myOptions = {
    zoom: zoom_value,
    center: myLatlng,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };
  map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);

  _show_markers(locations, showBaloons);
}

function _show_markers(locations, showBaloons) {
  var bounds = new google.maps.LatLngBounds();

  jQuery.each(locations, function(index, item) {
    var point = new google.maps.LatLng(item.lat, item.lng);
    //var newMarker = new CustomMarker(map, point, {"letter":(index+1), bgColor: item.organization_type.replace('#','')});
    var newMarker = createMarker(map, point, {"letter":(index+1), "bgColor": item.organization_type.replace('#','')});
    bounds.extend(point);

    if (showBaloons === true) {
      var html_content = null +
      "<div class='gmap-info'>" +
      "<h1>" + item.name + "</h1>" +
      "<h2>" + item.location_name + "</h2><br/>";
      if (item.logo && item.logo!=="") {html_content = html_content + "<img src='" + item.logo + "'/>";}
      if (item.address_line1!==null && item.address_line1 !== "") {html_content = html_content + "<p>" + item.address_line1 + "</p>";}
      if (item.address_line2!==null && item.address_line2 !== "") {html_content = html_content + "<p>" + item.address_line2 + "</p>";}
      if ((item.city!==null && item.city !=="") && (item.region!==null && item.region!=="") && (item.postal_code!==null && item.postal_code!=="")) {
        html_content = html_content + "<p>" + item.city + ", " + item.postal_code + " " + item.region + "</p>";
      }
      if(item.country!==null && item.country!=="") {html_content = html_content + "<p>" + item.country + "</p>";}
      html_content = html_content + "</div>";

      var iw = new google.maps.InfoWindow({
        content: html_content,
        pixelOffset: new google.maps.Size(5,0)
      });
      addToInfoWindows(iw);
      google.maps.event.addListener(newMarker, "click", function() {
        closeAllInfoWindows();
        iw.open(map, newMarker);
      });
    }
  });

  if(locations.length!==1) {map.fitBounds(bounds);}
  map.setCenter(bounds.getCenter());

  // var color;
  // mgr = new MarkerManager(map);
  // jQuery.each(locations, function() {
  //   var newIcon = MapIconMaker.createLabeledMarkerIcon({addStar: true,  primaryColor: this.organization_type});
  //   var marker = new GMarker(new GLatLng(this.lat, this.lng),{icon: newIcon});
  //   var name = this.name;
  //   var address = this.address;
  //   var popup_message = "<div class='map_popup'><h1>" + name + "</h1><br/>" + '<address>' + address + '</address></div>';
  //   GEvent.addListener(marker, "click", function() {
  //     marker.openInfoWindowHtml(popup_message);
  //   });
  //   map.setCenter(new GLatLng(this.lat, this.lng), DEFAULT_ZOOM);
  //   mgr.addMarker( marker, 2 );
  //   SEARCH_MARKERS[this.id] = {marker: marker, accuracy: this.accuracy};
  // });
  // mgr.refresh();
  //};
}

//2.22.10 Corey's attempt to fix the map marker redering issue.
// http://code.google.com/intl/uk-UA/apis/maps/documentation/javascript/reference.html#MarkerImage
// sample marker image
// http://chart.apis.google.com/chart?chst=d_map_pin_letter_withshadow&chld=A|ff0000|000000

function createMarker(map, latlng, opts) {
  var temp =  new google.maps.MarkerImage(iconUrl(opts), 
              // This marker is 40 pixels wide by 37 pixels tall
              new google.maps.Size(40,37),
              //The origin for this image is 0,0
              new google.maps.Point(0, 0), 
              //The anchor for this image is at the base of the point (0, 37)
              new google.maps.Point(11.5, 35));
  var marker = new google.maps.Marker(
  { 
    position: latlng, 
    map: map, 
    icon: temp 
  });
  return marker;
};

function iconUrl(opts) {
  var letter = "1";
  var bgColor = "ffffff";
  var fgColor = "000000";

  if(opts) {
    if(opts.letter)  {letter  = opts.letter;}
    if(opts.bgColor) {bgColor = opts.bgColor;}
    if(opts.fgColor) {fgColor = opts.fgColor;}
  }
  //  http://chart.apis.google.com/chart?chst=d_map_pin_letter_withshadow&chld=1|FFFFFF|000000
  var baseUrl = "http://chart.apis.google.com/chart?chst=d_map_pin_letter_withshadow";
  var markerIconUrl = baseUrl + "&chld=" + letter + "|" + bgColor + "|" + fgColor;
  return markerIconUrl;
}

function full_screen_map() {
  document_height = $(window).height();
  $('#map_canvas').css({'height':(document_height-HEADER_HEIGHT)+'px'});
  $(window).resize(function(){
    document_height = $(window).height();
    $('#map_canvas').css({'height':(document_height-HEADER_HEIGHT)+'px'});
  });
}

function init_locale_form() {
  $('#map_search_result p[data]').live('click', function() {
    var info = SEARCH_MARKERS[parseInt($(this).attr('data'))];
    map.setCenter(info.marker.getLatLng(), info.accuracy);
  });
  $('#map_search_result div.close').live('click', function() {
    $('#map_search_result').slideUp('fast');
    $('.paginator').slideUp('fast');
  });
  $('#locale_form').live('submit', function() {
    $.ajax({
      url:      '/maps/locate',
      type:     'GET',
      data:     {q : $("#q").val()},
      dataType: 'json',

      success: function(data, status, xhr) {
        
        _html = '<div class="close_holder"><div class="close">x</div></div>';
     
        $.each(data['data'], function(index, e) {
         // _html += '<li data="' + e.id +'">' + e.name + '</li>'
           _html += '<p data="' + e.id +'">'+ e.name +'</p>';
        });
        
        //_html += '</ul>'
        
        html = (data['data'].length > 0)?_html:ResetCounter();
        
        $('#map_search_result').html(html);
        
        $('#map_search_result').slideDown('slow');
       
        mgr.clearMarkers();
        
        _show_markers(data['data']);
        
        if(data['data'].length > 0){
      
          if(!GLOBALSEARCH){
            $('#map_search_result').pagination();
            GLOBALSEARCH=true;
          } else {
            $('#map_search_result').depagination();
            $('#map_search_result').pagination();
          }
        }
      },
      error: function(xhr, status, error) {
          alert('Error with map location.');
      }
    });
    return false;
  });

}


function show_markers_on_location_page(locations) {
  var myLatlng = new google.maps.LatLng(CENTER_LAT, CENTER_LNG);
  var myOptions = {
    zoom: 18,
    center: myLatlng,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };
  map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);

  _show_markers_location(locations);
}

function _show_markers_location(location) {
  var bounds = new google.maps.LatLngBounds();

  var point = new google.maps.LatLng(location.lat, location.lng);
  //var newMarker = new CustomMarker(map, point, {"letter":"", bgColor: location.organization_type.replace('#','')});
  var newMarker = createMarker(map, point, {"letter":"", "bgColor": location.organization_type.replace('#','')});
  bounds.extend(point);

  var html_content = null +
  "<div class='gmap-info'>" +
  "<h1>" + location.name + "</h1>" +
  "<h2>" + location.location_name + "</h2><br/>";
  if (location.address_line1!==null && location.address_line1!=="") {html_content = html_content + "<p>" + location.address_line1 + "</p>";}
  if (location.address_line2!==null && location.address_line2!=="") {html_content = html_content + "<p>" + location.address_line2 + "</p>";}
  if ((location.city!==null && location.city!=="") && (location.region!==null && location.region!=="") && (location.postal_code!==null && location.postal_code!=="")) {
    html_content = html_content + "<p>" + location.city + ", " + location.postal_code + " " + location.region + "</p>";
  }
  if(location.country!==null && location.country!=="") {html_content = html_content + "<p>" + location.country + "</p>";}
  html_content = html_content + "</div>";

  var iw = new google.maps.InfoWindow({
    content: html_content,
    pixelOffset: new google.maps.Size(5,0)
  });
  google.maps.event.addListener(newMarker, "click", function() {
    iw.open(map, newMarker);
  });

  map.setCenter(bounds.getCenter());
}

function ResetCounter(){
  ISEMPTY = false;
  return "No Result Found!";
}
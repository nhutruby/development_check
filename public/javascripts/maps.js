var center=null;var map=null;var geocoder=null;var addresses=null;var mgr=null;var all_markers=[];var HEADER_HEIGHT=18;var CENTER_LAT=45;var CENTER_LNG=-95;var DEFAULT_ZOOM=4;var SEARCH_MARKERS=[];var GLOBALSEARCH=false;var infoWindows=[];function addToInfoWindows(a){infoWindows.push(a)}function closeAllInfoWindows(){jQuery.each(infoWindows,function(a,b){b.close()})}function show_google_maps(){var b=new google.maps.LatLng(CENTER_LAT,CENTER_LNG);var c=DEFAULT_ZOOM;var a={zoom:c,center:b,mapTypeId:google.maps.MapTypeId.ROADMAP};map=new google.maps.Map(document.getElementById("map_canvas"),a)}function show_markers_on_page(a,e){if(a.length===0){return}var c=new google.maps.LatLng(CENTER_LAT,CENTER_LNG);var d=DEFAULT_ZOOM;if(a.length===1){d=16}var b={zoom:d,center:c,mapTypeId:google.maps.MapTypeId.ROADMAP};map=new google.maps.Map(document.getElementById("map_canvas"),b);_show_markers(a,e)}function _show_markers(a,c){var b=new google.maps.LatLngBounds();jQuery.each(a,function(g,h){var d=new google.maps.LatLng(h.lat,h.lng);var f=createMarker(map,d,{letter:(g+1),bgColor:h.organization_type.replace("#","")});b.extend(d);if(c===true){var i=null+"<div class='gmap-info'><h1>"+h.name+"</h1><h2>"+h.location_name+"</h2><br/>";if(h.logo&&h.logo!==""){i=i+"<img src='"+h.logo+"'/>"}if(h.address_line1!==null&&h.address_line1!==""){i=i+"<p>"+h.address_line1+"</p>"}if(h.address_line2!==null&&h.address_line2!==""){i=i+"<p>"+h.address_line2+"</p>"}if((h.city!==null&&h.city!=="")&&(h.region!==null&&h.region!=="")&&(h.postal_code!==null&&h.postal_code!=="")){i=i+"<p>"+h.city+", "+h.postal_code+" "+h.region+"</p>"}if(h.country!==null&&h.country!==""){i=i+"<p>"+h.country+"</p>"}i=i+"</div>";var e=new google.maps.InfoWindow({content:i,pixelOffset:new google.maps.Size(5,0)});addToInfoWindows(e);google.maps.event.addListener(f,"click",function(){closeAllInfoWindows();e.open(map,f)})}});if(a.length!==1){map.fitBounds(b)}map.setCenter(b.getCenter())}function createMarker(d,e,c){var b=new google.maps.MarkerImage(iconUrl(c),new google.maps.Size(40,37),new google.maps.Point(0,0),new google.maps.Point(11.5,35));var a=new google.maps.Marker({position:e,map:d,icon:b});return a}function iconUrl(d){var c="1";var e="ffffff";var f="000000";if(d){if(d.letter){c=d.letter}if(d.bgColor){e=d.bgColor}if(d.fgColor){f=d.fgColor}}var b="http://chart.apis.google.com/chart?chst=d_map_pin_letter_withshadow";var a=b+"&chld="+c+"|"+e+"|"+f;return a}function full_screen_map(){document_height=$(window).height();$("#map_canvas").css({height:(document_height-HEADER_HEIGHT)+"px"});$(window).resize(function(){document_height=$(window).height();$("#map_canvas").css({height:(document_height-HEADER_HEIGHT)+"px"})})}function init_locale_form(){$("#map_search_result p[data]").live("click",function(){var a=SEARCH_MARKERS[parseInt($(this).attr("data"))];map.setCenter(a.marker.getLatLng(),a.accuracy)});$("#map_search_result div.close").live("click",function(){$("#map_search_result").slideUp("fast");$(".paginator").slideUp("fast")});$("#locale_form").live("submit",function(){$.ajax({url:"/maps/locate",type:"GET",data:{q:$("#q").val()},dataType:"json",success:function(b,a,c){_html='<div class="close_holder"><div class="close">x</div></div>';$.each(b.data,function(d,f){_html+='<p data="'+f.id+'">'+f.name+"</p>"});html=(b.data.length>0)?_html:ResetCounter();$("#map_search_result").html(html);$("#map_search_result").slideDown("slow");mgr.clearMarkers();_show_markers(b.data);if(b.data.length>0){if(!GLOBALSEARCH){$("#map_search_result").pagination();GLOBALSEARCH=true}else{$("#map_search_result").depagination();$("#map_search_result").pagination()}}},error:function(c,a,b){alert("Error with map location.")}});return false})}function show_markers_on_location_page(a){var c=new google.maps.LatLng(CENTER_LAT,CENTER_LNG);var b={zoom:18,center:c,mapTypeId:google.maps.MapTypeId.ROADMAP};map=new google.maps.Map(document.getElementById("map_canvas"),b);_show_markers_location(a)}function _show_markers_location(b){var e=new google.maps.LatLngBounds();var a=new google.maps.LatLng(b.lat,b.lng);var d=createMarker(map,a,{letter:"",bgColor:b.organization_type.replace("#","")});e.extend(a);var f=null+"<div class='gmap-info'><h1>"+b.name+"</h1><h2>"+b.location_name+"</h2><br/>";if(b.address_line1!==null&&b.address_line1!==""){f=f+"<p>"+b.address_line1+"</p>"}if(b.address_line2!==null&&b.address_line2!==""){f=f+"<p>"+b.address_line2+"</p>"}if((b.city!==null&&b.city!=="")&&(b.region!==null&&b.region!=="")&&(b.postal_code!==null&&b.postal_code!=="")){f=f+"<p>"+b.city+", "+b.postal_code+" "+b.region+"</p>"}if(b.country!==null&&b.country!==""){f=f+"<p>"+b.country+"</p>"}f=f+"</div>";var c=new google.maps.InfoWindow({content:f,pixelOffset:new google.maps.Size(5,0)});google.maps.event.addListener(d,"click",function(){c.open(map,d)});map.setCenter(e.getCenter())}function ResetCounter(){ISEMPTY=false;return"No Result Found!"};
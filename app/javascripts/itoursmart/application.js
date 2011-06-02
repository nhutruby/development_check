// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready(function() {
  
  //FADING ALERT AND ERROR MESSAGES
  setTimeout(hideFlashMessages, 5000);

  if ($('#tweets').length) {
    setTimeout(updateTweets, 1);
  }

  if ($('#org_tweets').length) {
    setTimeout(updateOrgTweets, 1);
  }


  //FANCYBOX - Lightbox
  $("a.fancybox_inline").fancybox({
    'hideOnContentClick' : false,
    'hideOnOverlayClick' : false
	});

  $("a.fancybox_autoload").fancybox({'width': 640,'height': 400});
  $("a.fancybox_autoload").trigger("click");
  
  //ROTATING BANNERS
  $('#banner1').cycle({
    timeoutFn: function(currElement, nextElement, opts, isForward) {
    return parseInt($(currElement).attr('data-duration'), 10);
    },
    fx: 'turnDown'
  });

  $("#orgtext").trigger('click');

  //make sure the submit button is visible on page load
  $('#submit').show();

  //hide the submit button after click and show our loading message
  //#submit>a
  $("#submit>a, #submit input:submit").click(function() {
    $('#post_back_msg').show();
    $('#submit').hide();
  });
  
  //ADD CHILD
  $('a.add_child').live("click", function() {
    var association = $(this).attr('data-association');
    var template = $(this).prev().html();
    var regexp = new RegExp('new_' + association, 'g');
    var new_id = new Date().getTime();
    $(this).parent().before(template.replace(regexp, new_id));
    return false;
  });

  //REMOVE CHILD
  $('a.remove_child').live('click', function() {
    var hidden_field = $(this).prev('input[type=hidden]')[0];
    if(hidden_field) {
      hidden_field.value = '1';
    }
    $(this).parents('.fields:first').hide();
    return false;
  });
  
  //Display correct div for address
  $('#country').bind("change", function(){
    var country = $(this).val();
    if(country == "United States"){
      $('#core').show('slow');
      $('#us_form').show('slow');
      $('#canada_form').hide('slow');
      $('#other_form').hide('slow');
      $('#generic_form').hide('slow');
      }
    else if(country == "Canada"){
      $('#core').show('slow');
      $('#us_form').hide('slow');
      $('#canada_form').show('slow');
      $('#other_form').hide('slow');
      $('#generic_form').hide('slow');
      }
    else if(country == ""){
      $('#core').hide('slow');
      $('#us_form').hide('slow');
      $('#canada_form').hide('slow');
      $('#other_form').hide('slow');
      $('#generic_form').show('slow');
      }
    else {
      $('#core').show('slow');
      $('#us_form').hide('slow');
      $('#canada_form').hide('slow');
      $('#other_form').show('slow');
      $('#generic_form').hide('slow');
      }
  });

//
//  $('#country').change(function () {
//    $("#region, #postal_code").val("");
//  });

  $('#country').trigger("change");

  //TOGGLER LINKS HANDLER
  //will show/hide element defined in rel
  //eg.
  //1. plain haml
  //   %a.hidable{:href => "#", :rel => "#node_id"}
  //2. rails helper (will use +/- as text)
  //   hideable_link('#node_id')
  $('.hideable').click(function() {
    node = $(this).attr('rel');
    $(node).slideToggle('slow', 'easeInOutCirc');
    return false;
  });

//  $('#region').click(function() {
//    var selected_region = $(this).val();
//    $('#us_region').val(selected_region);
//  });
  
//  $('#region').trigger("click");
  //Mirror address input to actual attributes
  $("#us_region, #ca_region, #other_region").live('change', function() {
    var region = $(this).val();
      $('#region').val(region);
  });
  
  $("#us_postal_code, #ca_postal_code, #other_postal_code").live('change', function() {
    var region = $(this).val();
      $('#postal_code').val(region);
  });
  
  //Initialize US/CA region
  $(document).bind('initialize_regions', function() {
    var country = $("#country").val();
    var region  = $("#region").val();
    if(country == "United States"){
      $('#us_region').val( region );
    }
    else if(country == "Canada"){
      $('#ca_region').val( region );
    }
  });
  $(document).trigger('initialize_regions');

  $("#orgtext").trigger('click');
  $("#longorgtext").trigger('click');

  //Placeholder for inputs
  //Usage: input_tag :query, params[:query], :placeholder => "Enter query string"
  $('input').placeholder();
  //});


//??????????????
  $('#price_toggler1').click(function () {
      $("#simple1").hide();
      $("#simple2").show();
      return false;
  });

  $('#price_toggler2').click(function () {
      $('#retail_high').val(null);
      $('#price_high').val(null);
      $("#simple1").show();
      $("#simple2").hide();
      return false;
  });
  
//JQUERY-UI MODAL DIALOG HANDLER
//will show/hide modal dialog with element defined in rel
//%a.ui-modal-link{:rel => "#cancel-account-dialog", :href => "#"}
  $('a.ui-modal-link').click(function() {
    node  = $(this).attr('rel');
    title = $(this).attr('title');
    $(node).dialog({modal: true, title: title, width: 700});
    return false;
  });
  
//JS Timestamps
// = timeago(@organization.trial_ends_at)
  jQuery.timeago.settings.allowFuture = true;
  jQuery("abbr.timeago").timeago();
});

//CUSTOM FUNCTIONS

function hideFlashMessages() {
  $('p#flash_notice, p#flash_warning, p#flash_error').fadeOut(5000);
}

function updateTweets() {
  $.getScript("/pages/tweets.js");
  setTimeout(updateTweets, 30000000);
}

function submitWithAjax(){
  this.live("click", function() {
    $.ajax({type: "POST", url: $(this).attr("href"), dataType: "script"});
    return false;
  });
}

$(document).ready(function() {
  
  
  //CHARACTER COUNTER AND LIMITER (For organization description)
  $("#orgtext").live('keyup click ready', function() {
    var box = $(this).val();
    var main = box.length *100;
    var value = ((main / 255));
    var count = 255 - box.length;

    if(box.length <= 255) {
      $('#count').html(count);
      $('#bar').animate( {
        "width": value+'%'
      }
      ,
    1);}

    else {
      $(this).val($(this).val().substr(0,255));
    }
    return false;
  });

  $("#orgtext").trigger('click');

//Add WYSIWYG Editor for #longorgtext
  $('#longorgtext').wysiwyg({
    css: '/stylesheets/jquery_css/wysiwyg.css',
    loadCss: true,
    autoSave: true,
    initialContent: ""
  });

});
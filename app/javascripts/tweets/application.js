$(document).ready(function (){ 
  $("#marquee").marquee({ 
         yScroll: "top"                          // the position of the marquee initially scroll (can be  
                                                 // either "top" or "bottom") 
       , showSpeed: 850                          // the speed of to animate the initial dropdown of the messages 
       , scrollSpeed: 12                         // the speed of the scrolling (keep number low) 
       , pauseSpeed: 10000                        // the time to wait before showing the next message or  
                                                 // scrolling current message 
       , pauseOnHover: true                      // determine if we should pause on mouse hover 
       , loop: -1                                // determine how many times to loop through the marquees  
                                                 // (#'s < 0 = infinite) 
       , fxEasingShow: "swing"                   // the animition easing to use when showing a new marquee 
       , fxEasingScroll: "linear"                // the animition easing to use when showing a new marquee 
 
       // define the class statements 
       , cssShowing: "marquee-showing" 
 
       // event handlers 
       , init: null                              // callback that occurs when a marquee is initialized 
       , beforeshow: null                        // callback that occurs before message starts scrolling on screen 
       , show: null                              // callback that occurs when a new marquee message is displayed 
       , aftershow: null                         // callback that occurs after the message has scrolled 
  }); 
});
$(document).ready(function() {

 // See: http://docs.jquery.com/Tutorials:Introducing_$(document).ready()
  
//   var listTicker = function(options) {
   
//     var defaults = {
//         list: [],
//         startIndex:0,
//         interval: 3 * 1000,
//     }   
//     var options = $.extend(defaults, options);
       
//     var listTickerInner = function(index) {

//         if (options.list.length == 0) return;

//         if (!index || index < 0 || index > options.list.length) index = 0;

//         var value= options.list[index];

//         options.trickerPanel.fadeOut(function() {
//             $(this).html(value).fadeIn(3000)
//             $(this).html(value).fadeOut(3000);
//         });
        
//         var nextIndex = (index + 1) % options.list.length;

//         setTimeout(function() {
//             listTickerInner(nextIndex);
//         }, options.interval);

//     };
    
//     listTickerInner(options.startIndex);
// }
    
// var textlist = new Array("This is a million dollar idea! - Don Burk", "This is nice! - Monica Olinescu", "This .... fucking sucks! - David VanDusen", "This is NOT better than FoosBall... - Rosy Lee");

// $(function() {
//     listTicker({
//         list: textlist ,
//         startIndex:0,
//         trickerPanel: $('#quotePanel'),
//         interval: 5 * 1000,
//     });
// });

 $( "#loader" ).delay(2000).fadeOut(400, function(){
        $( "#your-page" ).fadeIn(400);
  }); 

  const path = document.querySelector('#wave');
const animation = document.querySelector('#moveTheWave');
const m = 0.512286623256592433;

function buildWave(w, h) {
  
  const a = h / 4;
  const y = h / 2;
  
  const pathData = [
    'M', w * 0, y + a / 2, 
    'c', 
      a * m, 0,
      -(1 - a) * m, -a, 
      a, -a,
    's', 
      -(1 - a) * m, a,
      a, a,
    's', 
      -(1 - a) * m, -a,
      a, -a,
    's', 
      -(1 - a) * m, a,
      a, a,
    's', 
      -(1 - a) * m, -a,
      a, -a,
    
    's', 
      -(1 - a) * m, a,
      a, a,
    's', 
      -(1 - a) * m, -a,
      a, -a,
    's', 
      -(1 - a) * m, a,
      a, a,
    's', 
      -(1 - a) * m, -a,
      a, -a,
    's', 
      -(1 - a) * m, a,
      a, a,
    's', 
      -(1 - a) * m, -a,
      a, -a,
    's', 
      -(1 - a) * m, a,
      a, a,
    's', 
      -(1 - a) * m, -a,
      a, -a,
    's', 
      -(1 - a) * m, a,
      a, a,
    's', 
      -(1 - a) * m, -a,
      a, -a
  ].join(' ');
  
  path.setAttribute('d', pathData);
}

buildWave(90, 60);

});





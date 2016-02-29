$(document).ready(function() {  
  var listTicker = function(options) {
   
    var defaults = {
        list: [],
        startIndex:0,
        interval: 3 * 1000,
    }   
    var options = $.extend(defaults, options);
       
    var listTickerInner = function(index) {

        if (options.list.length == 0) return;

        if (!index || index < 0 || index > options.list.length) index = 0;

        var value= options.list[index];

        options.trickerPanel.fadeOut(function() {
            $(this).html(value).fadeIn(3000)
            $(this).html(value).fadeOut(3000);
        });
        
        var nextIndex = (index + 1) % options.list.length;

        setTimeout(function() {
            listTickerInner(nextIndex);
        }, options.interval);

    };
    
    listTickerInner(options.startIndex);
}
    
var textlist = new Array("This is a million dollar idea!", "This is nice! I'm a happy camper.", "What the hell is this..", "This is NOT better than FoosBall...");

$(function() {
    listTicker({
        list: textlist ,
        startIndex:0,
        trickerPanel: $('#quotePanel'),
        interval: 5 * 1000,
    });
  });

var authorlist = new Array("-Don Burks", "- Monica Olinescu", "- David VanDusen", "- Rosy Lee");

$(function() {
    listTicker({
        list: authorlist ,
        startIndex:0,
        trickerPanel: $('#authorPanel'),
        interval: 5 * 1000,
    });
  });
});

// var imglist = new Array("1", "2", "3", "4");

// $(function() {
//     listTicker({
//         list: imglist ,
//         startIndex:0,
//         trickerPanel: $('#facePanel'),
//         interval: 5 * 1000,
//     });
//   });
// });


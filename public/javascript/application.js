$(document).ready(function() {

 // See: http://docs.jquery.com/Tutorials:Introducing_$(document).ready()
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
    
var textlist = new Array("This is a million dollar idea!- Don Burk", "This is nice! - Monica Olinescu", "This .... fucking sucks! - David VanDusen", "This is NOT better than FoosBall... - Rosy Lee");

$(function() {
    listTicker({
        list: textlist ,
        startIndex:0,
        trickerPanel: $('#quotePanel'),
        interval: 5 * 1000,
    });
}); 

});





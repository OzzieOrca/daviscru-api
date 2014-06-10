$(function(){
    $('a img[data-hover]').each(
        function(){
            $(this).parent().wrap('<div style="position: relative" class="' + $(this).attr("data-surrounding-class") + '" />');

            var imgHover = $('<img src="' + $(this).attr("data-hover") + '" style="position: absolute; left: 0; top: 0; z-index: 10; opacity: 0;"/>').attr("width", $(this).attr("width")).attr("height", $(this).attr("height"));
            $(this).parent().append(imgHover);

            var imgClick = $('<img src="' + $(this).attr("data-click") + '" style="position: absolute; left: 0; top: 0; z-index: 20; opacity: 0;"/>').attr("width", $(this).attr("width")).attr("height", $(this).attr("height"));
            $(this).parent().append(imgClick);

            imgClick.hover(
                function() {
                    imgHover.stop().animate({"opacity": "1"}, 200);
                },
                function() {
                    imgHover.stop().animate({"opacity": "0"}, 200);
                }
            );

            imgClick.mousedown(
                function() {
                    $(this).stop().animate({"opacity": "1"}, 100);
                }
            );
            imgClick.mouseup(
                function() {
                    $(this).stop().animate({"opacity": "0"}, 100);
                }
            );
            imgClick.mouseout(
                function() {
                    $(this).stop().animate({"opacity": "0"}, 100);
                }
            );
        }
    );

});
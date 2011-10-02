(function($) {
    $(function() {
        var i, left, top;
        for (i = 0; i < 50; i++) {
            left = Math.floor(Math.random() * 600.0);
            top = Math.floor(Math.random() * 50) + 200;
            $("<img />")
                .addClass("snowman")
                .css("left", left + "px")
                .css("top", top + "px")
                .attr("src", "images/snowman.png")
                .attr("data-tween-to", i % 2 ? "left" : "right")
                .bind("mouseover", function(e) {
                    var $this = $(this);
                    if ($this.attr("data-tween-to") === "left") {
                        $this.addClass("tween-left");
                    } else {
                        $this.addClass("tween-right");
                    }

                })
                .appendTo("#stage");
        }
    });
}(jQuery));

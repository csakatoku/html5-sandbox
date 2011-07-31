(function ($) {
    var tmpl = new EJS({ url: "/static/tmpl/message.ejs" });

    $(function() {
        var evtSrc = new EventSource("/eventsource");

        // Listen for messages/events on the EventSource
        evtSrc.onmessage = function(e) {
            addMessage("status", JSON.parse(e.data));
        };

        var events = ["checkin", "forward", "direct"];
        events.forEach(function(eventType) {
            evtSrc.addEventListener(eventType, function( e ) {
                addMessage(eventType, JSON.parse(e.data) );
            }, false);
        });
    });

    // Functions to display the messages
    function addMessage(type, data) {
        var content = tmpl.render({ data: data, type: type });
        $(content).insertAfter("#lastMsg");
    }
})(jQuery);

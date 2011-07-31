(function ($) {
    var message = document.createElement("div");
    message.classList.add("msg");

    $(function() {
        var timeline = document.getElementById( "timeline" );
        var lastMsg = document.getElementById( "lastMsg" );
        var evtSrc = new EventSource("/eventsource");

        // Listen for messages/events on the EventSource
        evtSrc.onmessage = function ( e ) {
            addMessage( "status", JSON.parse(e.data) );
        };

        evtSrc.addEventListener("checkin", function( e ) {
            addMessage( "checkin", JSON.parse(e.data) );
        }, false);

        evtSrc.addEventListener("forward", function( e ) {
            addMessage( "forward", JSON.parse(e.data) );
        }, false);

        evtSrc.addEventListener("direct", function( e ) {
            addMessage( "direct", JSON.parse(e.data) );
        }, false);
    });

    // Functions to display the messages
    function addMessage(type, data) {
        var msg = message.cloneNode(false);
        var content;

        msg.classList.add( type );
        content = "<b>☺ " + userStr( data.from ) + "</b>";
        if ( type === "forward" ) {
            content += " » by " + userStr( data.through );
        }
        content += "<br/>" + ( data.msg || "<em>currently at</em> " + data.place ) + "<br/>";
        content += "<i>¤ " + data.location + "</i>";
        msg.innerHTML = content;
        lastMsg = timeline.insertBefore( msg, lastMsg );
    }

    function userStr(name) {
        return "<a href='#"+ name +"'>"+ name +"</a>";
    }
})(jQuery);

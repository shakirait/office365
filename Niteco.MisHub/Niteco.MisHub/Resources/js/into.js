$("document").ready(function () {
    $p = jQuery.noConflict();
    $p("#fullscreenmode").on("click", function () {
        $p("#into-sitenav").hide();
    });
    $p("#exitfullscreenmode").on("click", function () {
        $p("#into-sitenav").show();
    });

    //open SharePoint Link list item in a new window
    var updateLinks = window.setInterval(function () {
        $p = jQuery.noConflict();
        if ($p("a.ms-draggable").length > 0) {
            $p("a.ms-draggable").each(function () {
                $p(this).attr('target', '_blank');
            });
            clearInterval(updateLinks);
        }
    }, 2000);
});

var waitForFinalEvent = (function () {
    var timers = {};
    return function (callback, ms, uniqueId) {
        if (!uniqueId) {
            uniqueId = "Don't call this twice without a uniqueId";
        }
        if (timers[uniqueId]) {
            clearTimeout(timers[uniqueId]);
        }
        timers[uniqueId] = setTimeout(callback, ms);
    };
})();
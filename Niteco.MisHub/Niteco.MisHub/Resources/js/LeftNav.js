//Declare namespace
var INTONav = INTONav || {};
//var $ = jQuery.noConflict();

$(document).ready(function () {

    var navigationHtml = "<div id=\"into-sitenav\" class=\"folded\"><ul id=\"nav-ul\"></ul></div>";
    $("#s4-workspace").append(navigationHtml);


    // Global Variables
    INTONav.navigation = "LeftNavigation";
    INTONav.appweburl = _spPageContextInfo.webAbsoluteUrl;
    INTONav.serverRequestPath = _spPageContextInfo.serverRequestPath;
    INTONav.currentPage = INTONav.appweburl.split(".sharepoint.com")[0] + ".sharepoint.com" + INTONav.serverRequestPath;

    INTONav.GetNavigationData = function () {
        console.log('Get Navigation Part 1');
        var executor;
        try {
            $.getScript(INTONav.appweburl + "/_layouts/15/" + "SP.RequestExecutor.js", function () {
                executor = new SP.RequestExecutor(INTONav.appweburl);
                executor.executeAsync({
                    url: INTONav.appweburl + "/_api/web/lists/getbytitle('" + INTONav.navigation + "')/items?$orderby=Order",
                    method: "GET",
                    headers: { "Accept": "application/json; odata=verbose" },
                    success: function (data) {
                        INTONav.GetNavigationData_Part2(data);
                    },
                    error: function (data) {
                    }
                });
            });
        }
        catch (error) {
            console.log(error.message);
        }
    }

    INTONav.GetNavigationData_Part2 = function (data) {
        console.log('Get Navigation Part 2');
        try {
            var isFolded = localStorage.getItem('nav');
            if (isFolded != null && isFolded != 'folded') {
                var $navbox = $p("#into-sitenav");
                var $contentbox = $p("#into-pagecontent");
                var $toptitlebox = $p(".ms-breadcrumb-box");
                var $topicon = $p("#siteIcon");

                $navbox.css("width", "200px");
                $contentbox.css("width", "calc(100% - 150px)");
                $contentbox.css("left", "150px");
                //$toptitlebox.css("padding-left", "150px");
                $topicon.css("padding-left", "150px");
                $navbox.removeClass("folded");
            }

            var tempData = JSON.parse(data.body);

            $("#nav-ul").append("<li class='nav-item' id='menu-control' onclick='INTONav.onClick()'><a><i class='fa fa-bars fa-2x'></i></a></li>");

            for (var i = 0; i < tempData.d.results.length; i++) {
                var className = tempData.d.results[i].ClassName != null ? "fa-" + tempData.d.results[i].ClassName : "";
                var standartIcon = tempData.d.results[i].Icon != null ? tempData.d.results[i].Icon.Url : "";
                var hoverIcon = tempData.d.results[i].HoverIcon != null ? tempData.d.results[i].HoverIcon.Url : "";

                if (tempData.d.results[i].NavigationURL.Url == INTONav.currentPage) {
                    var li = "<li class='nav-item current' id='" + tempData.d.results[i].Title.replace(/ /g, '') + "'><a href='" + tempData.d.results[i].NavigationURL.Url + "' standard-icon='" + standartIcon + "' hover-icon='" + hoverIcon + "' style='background-image:url(" + standartIcon + ");'><i class='fa " + className + " fa-2x'></i><div class='menu-text'>" + tempData.d.results[i].Title + "</div></a></li>";
                }
                else {
                    var li = "<li class='nav-item' id='" + tempData.d.results[i].Title.replace(/ /g, '') + "'><a href='" + tempData.d.results[i].NavigationURL.Url + "' standard-icon='" + standartIcon + "' hover-icon='" + hoverIcon + "' style='background-image:url(" + standartIcon + ");'><i class='fa " + className + " fa-2x'></i><div class='menu-text'>" + tempData.d.results[i].Title + "</div></a></li>";
                }
                console.log(li);
                $("#nav-ul").append(li);
            }

            //var link = '<link rel="stylesheet" type="text/css" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">'
            //$('head').append(link)

        }
        catch (error) {
            console.log(error.message);
        }
    };

    INTONav.onClick = function () {
        var $navbox = $p("#into-sitenav");
        var $contentbox = $p("#into-pagecontent");
        var $toptitlebox = $p(".ms-breadcrumb-box");
        var $topicon = $p("#siteIcon");

        if ($navbox.hasClass("folded")) {
            $navbox.css("width", "200px");
            $contentbox.css("width", "calc(100% - 150px)");
            $contentbox.css("left", "150px");
            //$toptitlebox.css("padding-left", "150px");
            $topicon.css("padding-left", "150px");
            $navbox.removeClass("folded");
            localStorage.setItem("nav", "");
        }
        else {
            $navbox.css("width", "60px");
            $contentbox.css("width", "calc(100%)");
            $contentbox.css("left", "0px");
            //$toptitlebox.css("padding-left", "0");
            $topicon.css("padding-left", "0");
            $navbox.addClass("folded");
            localStorage.setItem("nav", "folded");
        }
    };

    //setTimeout(INTONav.GetNavigationData(), 0);

    SP.SOD.executeFunc('sp.js', 'SP.ClientContext', INTONav.GetNavigationData());
    //SP.SOD.executeOrDelayUntilScriptLoaded(INTONav.GetNavigationData(), 'SP.js');
});
console.log('Navigation loaded');
//Declare namespace
var INTONav = INTONav || {};
var menuWidth = ''
var $p = jQuery.noConflict();
var duplicateCheck = [];

$p(document).ready(function () {
    // Global Variables
    INTONav.navigation = "LeftNavigation";
    INTONav.reportsCentre = "Power BI Reports";
    INTONav.configList = "PBI Report Configuration";
    INTONav.appweburl = _spPageContextInfo.webAbsoluteUrl;
    INTONav.serverRequestPath = _spPageContextInfo.serverRequestPath;
    INTONav.currentPage = INTONav.appweburl.split(".sharepoint.com")[0] + ".sharepoint.com" + INTONav.serverRequestPath;
    INTONav.currentPage = INTONav.currentPage.split(' ').join('%20');
    INTONav.reportURL = window.location.href.split('=')[1];
    INTONav.reportsCentreURL = INTONav.appweburl + "/Pages/ReportViewer.aspx?reportUrl=";
    INTONav.homePage = INTONav.appweburl + "/Pages/Home.aspx";
    INTONav.reportsCentrePage = INTONav.appweburl + "/Pages/Report Centre.aspx";
    INTONav.agentID = navigator.userAgent.toLowerCase().match(/(iphone|ipod|ipad)/);
    jQuery.getScript('../SiteAssets/OneSight/Webparts/Nav/navconfig.js', function () {
        INTONav.maxReportDisplayLimi = MaxDisplayItemLimit;
        INTONav.maxReportToRetrieve = MaxReportToRetrieve;
    });

    INTONav.GetNavigationData = function () {
        console.log('Get Navigation Part 1');
        $p = jQuery.noConflict();
        var executor;
        try {
            $p.getScript(INTONav.appweburl + "/_layouts/15/" + "SP.RequestExecutor.js", function () {
                executor = new SP.RequestExecutor(INTONav.appweburl);
                executor.executeAsync({
                    url: INTONav.appweburl + "/_api/web/lists/getbytitle('" + INTONav.navigation + "')/items?$orderby=Order0",
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
        $p = jQuery.noConflict();
        try {

            var tempData = JSON.parse(data.body);
            //$p("#nav-ul").append("<li class='nav-item' id='menu-control' onclick='INTONav.onClick()'><a><i class='fa fa-bars fa-2x'></i></a></li>");
            //$p("#nav-ul").append("<li class='nav-item' id='ReportsCentre' onmouseenter='INTONav.onMouseEnter()' onmouseleave='INTONav.onMouseLeave()'><a><i class='fa fa-files-o fa-2x'></i><div class='menu-text'>Reports Centre</div></a>");
            for (var i = 0; i < tempData.d.results.length; i++) {
                var className = tempData.d.results[i].ClassName != null ? tempData.d.results[i].ClassName : "";
                var standartIcon = tempData.d.results[i].Icon != null ? tempData.d.results[i].Icon.Url : "";
                var hoverIcon = tempData.d.results[i].HoverIcon != null ? tempData.d.results[i].HoverIcon.Url : "";

                if (tempData.d.results[i].NavigationURL.Url == INTONav.currentPage) {
                    var li = "<li class='nav-item current' id='" + tempData.d.results[i].Title.replace(/ /g, '') + "'><a href='" + tempData.d.results[i].NavigationURL.Url + "' standard-icon='" + standartIcon + "' hover-icon='" + hoverIcon + "' style='background-image:url(" + hoverIcon + ");'><i class='fa " + className + " fa-2x'></i><div class='menu-text'>" + tempData.d.results[i].Title + "</div></a></li>";
                }
                else {
                    var li = "<li class='nav-item' id='" + tempData.d.results[i].Title.replace(/ /g, '') + "'><a href='" + tempData.d.results[i].NavigationURL.Url + "' standard-icon='" + standartIcon + "' hover-icon='" + hoverIcon + "' style='background-image:url(" + standartIcon + ");'><i class='fa " + className + " fa-2x'></i><div class='menu-text'>" + tempData.d.results[i].Title + "</div></a></li>";
                }
                $p("#nav-ul").append(li);
            }

            $p(".nav-item").each(function () {
                var currentnav = $p(this);
                var currenticon = currentnav.find("i");
                var iconClassAssigned = currenticon.attr("class").split(/\s+/).length;

                if (iconClassAssigned < 3) {
                    var standardIconUrl = currentnav.find("a").attr("standard-icon");
                    var hoverIconUrl = currentnav.find("a").attr("hover-icon");

                    currentnav.on("mouseenter", function () {
                        currentnav.find("a").attr("style", "background-image:url(" + hoverIconUrl + ");");
                    }).on("mouseleave", function () {
                        if (!currentnav.hasClass("current")) {
                            currentnav.find("a").attr("style", "background-image:url(" + standardIconUrl + ");");
                        }
                    });
                }
            });

            var executor;
            try {
                $p.getScript(INTONav.appweburl + "/_layouts/15/" + "SP.RequestExecutor.js", function () {
                    executor = new SP.RequestExecutor(INTONav.appweburl);
                    executor.executeAsync({
                        url: INTONav.appweburl + "/_api/web/lists/getbytitle('" + INTONav.configList + "')/items?$orderby=SortOrder",
                        method: "GET",
                        headers: { "Accept": "application/json; odata=verbose" },
                        success: function (data) {
                            INTONav.GetNavigationData_Part3(data);
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
        catch (error) {
            console.log(error.message);
        }
    };

    INTONav.GetNavigationData_Part3 = function (data) {
        console.log('Get Navigation Part 3');
        duplicateCheck = []
        $p = jQuery.noConflict();
        try {
            var tempData = JSON.parse(data.body);
            //$p('#ReportsCentre').append('<ul id="inner-ul" style="display: none;" class="folded"></ul>');

            if (tempData.d.results.length > 0) {
                var title = tempData.d.results[0].Title != null ? tempData.d.results[0].Title : "";
                var li = "<li class='inner-nav first' id='" + title.replace(/ /g, '') + "'><a href='" + INTONav.homePage + "'><i class='fa fa-home fa-2x'></i><div class='inner-text'>" + title + "</div></a></li>";
                $p("#inner-ul").append(li);
                duplicateCheck.push('@' + title.trim().toLowerCase() + '@');
            }
            //
            var executor;
            try {
                $p.getScript(INTONav.appweburl + "/_layouts/15/" + "SP.RequestExecutor.js", function () {
                    executor = new SP.RequestExecutor(INTONav.appweburl);
                    executor.executeAsync({
                        url: INTONav.appweburl + "/_api/web/lists/getbytitle('" + INTONav.reportsCentre + "')/items?$orderby=SortOrder,URL&$top=" + INTONav.maxReportToRetrieve + "&$select=Title,SortOrder,URL",
                        method: "GET",
                        headers: { "Accept": "application/json; odata=verbose" },
                        success: function (data) {
                            INTONav.GetNavigationData_Part4(data);
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
        catch (error) {
            console.log(error.message);
        }
    };

    INTONav.GetNavigationData_Part4 = function (data) {
        console.log('Get Navigation Part 4');
        $p = jQuery.noConflict();
        try {
            var tempData = JSON.parse(data.body);
            var maxItemLimit = INTONav.maxReportDisplayLimit;
            var windowHeight = window.innerHeight;
            var items = (windowHeight - 84) / 60 - 3;
            for (var i = 0; i < tempData.d.results.length; i++) {
                var title = tempData.d.results[i].URL.Description != null ? tempData.d.results[i].URL.Description : "";
                if ($p.inArray('@' + title.trim().toLowerCase() + '@', duplicateCheck) < 0) {
                    var url = tempData.d.results[i].URL.Url;
                    if (tempData.d.results[i].URL.Url.indexOf("ReportViewer.aspx?reportUrl=") >= 0) {
                        url = tempData.d.results[i].URL.Url.split("ReportViewer.aspx?reportUrl=")[1];
                    }

                    if (url == INTONav.reportURL) {
                        var li = "<li class='inner-nav current' id='" + tempData.d.results[i].ID + "'><a href='" + INTONav.reportsCentreURL + url + "'><div class='inner-text'>" + title + "</div></a></li>";
                    }
                    else {
                        var li = "<li class='inner-nav' id='" + tempData.d.results[i].ID + "'><a href='" + INTONav.reportsCentreURL + url + "'><div class='inner-text'>" + title + "</div></a></li>";
                    }
                    $p("#inner-ul").append(li);
                    duplicateCheck.push('@' + title.trim().toLowerCase() + '@');
                }

                if (duplicateCheck.length + 1 == maxItemLimit) {
                    break;
                }
            }

            var li = "<li class='inner-nav' id='reportCentrePage'><a href='" + INTONav.reportsCentrePage + "'><div class='inner-text'>More Reports...</div></a></li>";
            $p("#inner-ul").append(li);
        }
        catch (error) {
            console.log(error.message);
        }
    };

    INTONav.onClick = function () {
        $p = jQuery.noConflict();
        var $navbox = $p("#into-sitenav");
        var $contentbox = $p("#into-pagecontent");
        var $toptitlebox = $p(".ms-breadcrumb-box");
        var $topicon = $p("#siteIcon");
        var $innernav = $p("#inner-ul");

        if ($navbox.hasClass("folded")) {
            $navbox.css("width", "200px");
            $contentbox.css("width", "calc(100% - 150px)");
            $contentbox.css("left", "150px");
            //$toptitlebox.css("padding-left", "150px");
            $topicon.css("padding-left", "150px");
            $navbox.removeClass("folded");
            localStorage.setItem("nav", "");
            $innernav.removeClass("folded");
            menuWidth = '200px';
        }
        else {
            $navbox.css("width", "60px");
            $contentbox.css("width", "calc(100%)");
            $contentbox.css("left", "0px");
            //$toptitlebox.css("padding-left", "0");
            $topicon.css("padding-left", "0");
            $navbox.addClass("folded");
            localStorage.setItem("nav", "folded");
            $innernav.addClass("folded");
            if (INTONav.agentID) {
                menuWidth = '250px';
            }
            else {
                menuWidth = '0px';
            }
        }
        $innernav.hide();
    };

    INTONav.mobileClick = function () {
        $p = jQuery.noConflict();
        if (INTONav.agentID) {
            if ($p('#inner-ul').css('display') == 'none') {
                $p('#inner-ul').show();
                SetFlyoutMenu();
            }
            else {
                $p('#inner-ul').hide();
            }
        }
    }

    INTONav.onMouseEnter = function () {
        $p = jQuery.noConflict();
        if (!INTONav.agentID) {
            $p('#inner-ul').show();
            SetFlyoutMenu();
        }
    };
    INTONav.onMouseLeave = function () {
        $p = jQuery.noConflict();
        if (!INTONav.agentID) {
            $p('#inner-ul').hide();
        }
    };

    INTONav.onLoad = function () {
        $p = jQuery.noConflict();
        var isFolded = localStorage.getItem('nav');
        if (isFolded != null && isFolded != 'folded') {
            var $navbox = $p("#into-sitenav");
            var $contentbox = $p("#into-pagecontent");
            var $toptitlebox = $p(".ms-breadcrumb-box");
            var $topicon = $p("#siteIcon");
            var $innernav = $p("#inner-ul");

            $navbox.css("width", "200px");
            $contentbox.css("width", "calc(100% - 150px)");
            $contentbox.css("left", "150px");
            //$toptitlebox.css("padding-left", "150px");
            $topicon.css("padding-left", "150px");
            $navbox.removeClass("folded");
            $innernav.removeClass("folded");
            menuWidth = '200px';
        }
        else {
            if (INTONav.agentID) {
                menuWidth = '250px';
            } else {
                menuWidth = '0px';
            }

        }

        if (!INTONav.agentID) {
            $p('#inner-ul').css({ position: 'fixed' });
        }
        INTONav.GetNavigationData();
    }

    function SetFlyoutMenu() {

        var $navbox = $p("#into-sitenav");
        var $innernav = $p("#inner-ul");
        var screenHeight = window.innerHeight - 146;
        var totalItems = $p('.inner-nav').length;
        var itemsHeight = totalItems * 60;
        var showScroll = false;
        if (itemsHeight > screenHeight) {
            itemsHeight = (Math.floor(screenHeight / 60)) * 60;
            showScroll = true;
        } else {
            itemsHeight = totalItems * 60;
        }

        $innernav.css("height", itemsHeight + "px");
        $innernav.css("z-index", "100");
        if (INTONav.agentID) {
            // iPad or iPhone
            $innernav.css("top", "-61px");

            if ($navbox.hasClass("folded")) {
                $innernav.css("left", '0px');
                $innernav.css("width", '300px');
            }
            else {
                $innernav.css("left", '200px')
                $innernav.css("width", '250px');
            }
        } else {
            $innernav.css("left", menuWidth);
            $innernav.css("top", '146px')
            if ($navbox.hasClass("folded")) {
                $innernav.css("width", "300px");
            }
            else {
                $innernav.css("width", "250px");
            }
        }

        if (showScroll) {
            $innernav.scroller("reset");
            $innernav.scroller();
            $innernav.scroller("scroll", 0);
        }
    }

    setTimeout(INTONav.onLoad(), 0);
});
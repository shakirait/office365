var $x = jQuery.noConflict();

var INTONotifications = {

    preCheckCookie: function preCheckCookie() {
        //Get
        var query = "<Query>"
            + "<OrderBy>"
            + "<FieldRef Name='Expires' Ascending='True' />"
            + "<FieldRef Name='Modified' Ascending='FALSE' />"
            + "</OrderBy>"
            + "<Where>"
            + "<Geq>"
            + "<FieldRef Name='Expires' />"
            + "<Value Type='DateTime'  IncludeTimeValue='TRUE'>" + moment(new Date()._d).tz("Europe/London").format('YYYY-MM-DDTHH:mm:ss') + 'Z' + "</Value>"
            + "</Geq>"
            + "</Where>"
            + "</Query>";


        $x().SPServices({
            operation: "GetListItems",
            webURL: _spPageContextInfo.webAbsoluteUrl,
            async: true,
            listName: "Notifications",
            CAMLViewFields: " <ViewFields><FieldRef Name='Body' /><FieldRef Name='Expires' /><FieldRef Name='Icon' /><FieldRef Name='Modified' /><FieldRef Name='Expires' /></ViewFields>",
            CAMLQuery: query,
            CAMLRowLimit: 1,
            completefunc: function (xData) {
                INTONotifications.log(xData);

                //Get the data
                var domElementArray = $x(xData.responseXML).SPFilterNode("z:row").each(function () { });
                var dataMap = domElementArray.map(function () {
                    INTONotifications.log($x(this).attr('ows_Expires'));
                    INTONotifications.log('Icon name: ' + $x(this).attr('ows_Icon'));
                    return {
                        id: $x(this).attr('ows_ID'),
                        expiryDate: $x(this).attr('ows_Expires'),
                        lastModified: $x(this).attr('ows_Modified')
                    };
                });

                var data = dataMap.get();
                if (data.length > 0) {
                    INTONotifications.log('expiry date for cookie:' + data[0].expiryDate);
                    INTONotifications.checkCookie(data[0].expiryDate, data[0].lastModified);
                }
            }
        });
    },

    //Check the Cookie
    checkCookie: function checkCookie(expiryDate, lastModified) {
        INTONotifications.log('checking cookie');
        var d = INTONotifications.readCookie("UserCookie" + lastModified);
        if (d == null || d == '' || d == 'undefined') {

            INTONotifications.log('opening popup');
            INTONotifications.GetNotificationMessage();
        }
    },

    //Get Notifcation Message from the List by making ajax request   SPServices
    GetNotificationMessage: function GetNotificationMessage() {
        INTONotifications.log(window.location.host);

        var query = "<Query>"
            + "<OrderBy>"
            + "<FieldRef Name='Expires' Ascending='True' />"
            + "<FieldRef Name='Modified' Ascending='FALSE' />"
            + "</OrderBy>"
            + "<Where>"
            + "<Geq>"
            + "<FieldRef Name='Expires' />"
            + "<Value Type='DateTime' IncludeTimeValue='TRUE'>" + moment(new Date()._d).tz("Europe/London").format('YYYY-MM-DDTHH:mm:ss') + 'Z' + "</Value>"
            + "</Geq>"
            + "</Where>"
            + "</Query>";

        $x().SPServices({
            operation: "GetListItems",
            webURL: _spPageContextInfo.webAbsoluteUrl,
            async: true,
            listName: "Notifications",
            CAMLViewFields: " <ViewFields><FieldRef Name='Body' /><FieldRef Name='Icon' /><FieldRef Name='Expires' /><FieldRef Name='ShowCheckBox'/></ViewFields>",
            CAMLQuery: query,
            CAMLRowLimit: 1,
            completefunc: INTONotifications.GetHtml
        });
    },

    GetHtml: function GetHtml(xData) {
        INTONotifications.log(xData);
        //Get the data
        var domElementArray = $x(xData.responseXML).SPFilterNode("z:row").each(function () { });
        var dataMap = domElementArray.map(function () {
            return {

                id: $x(this).attr('ows_ID'),
                content: $x(this).attr('ows_Body'),
                title: $x(this).attr('ows_Title'),
                expiryDate: $x(this).attr('ows_Expires'),
                lastModified: $x(this).attr('ows_Modified'),
                icon: $x(this).attr('ows_Icon').trim(),
                showCheckBox: $x(this).attr('ows_ShowCheckBox')
            };
        });

        var data = dataMap.get();
        if (data.length > 0) {
            var expiryTime = new Date(moment(data[0].expiryDate));
            var nowTime = moment(new Date()._d).tz("Europe/London").format('YYYY-MM-DDTHH:mm:ss');

            INTONotifications.log("Expiry Time: " + expiryTime);
            INTONotifications.log("Moment Time in London :" + nowTime);
            INTONotifications.log("Moment Time in Local :" + new Date());

            if (new Date(expiryTime) > new Date(nowTime)) {
                INTONotifications.log(data);
                INTONotifications.OpenPopUp(data[0].content, data[0].title, data[0].icon, data[0].showCheckBox, data[0].lastModified, data[0].expiryDate);
            };
        }
    },

    //Form the Html from the Data and add it to the content
    OpenPopUp: function OpenPopUp($xgHtml, itemTitle, iconName, showCheckBox, lastModified, expiryDate) {
        INTONotifications.log('open popup');

        var chkBoxVisibility = (showCheckBox == 1) ? "block" : "none";
        var $xgElem = '<div class="PopUpContainer" >' +
            '<input type="hidden" name="lastModified" value="' + lastModified + '"/>' +
            '<input type="hidden" name="expiryDate" value="' + expiryDate + '" />' +
            '<div class="PopUpTopBG">' +
            '</div>' +
            '<div class="PopUpTitle" style="margin-top:5px;width:100%">' +
            '<span style="width:5%"><i class="fa fa-' + iconName.trim() + ' fa-2x" style="float:left;padding-top:10px"></i></span>' +
            '<span style="width:95%"><h1 style="padding:5px;padding-left:30px;color:#000;">' + itemTitle + '</h1></span>' +
            '</div>' +
            '<div class="PopUpContent" style="clear:both;border-top:1px solid #CCC; padding-top:5px;overflow:auto;">' + $xgHtml +
            '<div style="float:right; clear:both;padding-top:20px;padding-bottom:20px;width:100%">' +
            '<span style="display:' + chkBoxVisibility + '"><input id="notificationshowMessage"  type="checkbox"   title="showNoMessage" />Do not show this message again</span> ' +
            '<input type="button" class="PopUpClose" style="float:right;margin-top:-25px;" value="OK"/>' +
            '</div>' +

            '</div>' +
            '<div class="PopUpBottomBG">' +
            '</div>' +
            '</div>';
        INTONotifications.log('html: ' + $xgHtml);

        var htmlToLoad = $x($xgElem).append('<div class="PopUpBottomBG">');
        var cloneModalContent = document.createElement('div');

        cloneModalContent.innerHTML = htmlToLoad.html();
        var options = {
            html: cloneModalContent,
            autoSize: true,
            allowMaximize: false,
            dialogClass: "no-titlebar",
            title: " ",
            showClose: true,
            dialogReturnValueCallback:
            function (results, returnValue) {
                var ischecked = returnValue[1];
                var ischeckedBoxVisible = returnValue[2];
                var lastModified = returnValue[3];
                var expiryDate = returnValue[4];
                if ((ischeckedBoxVisible && ischecked) || !ischeckedBoxVisible) {
                    INTONotifications.createCookie("UserCookie" + lastModified, "UserCookie", expiryDate);
                }
            },
            create: function (event, ui) {
                alert("popup");
                $x(".ms-dlgFrameContainer").hide();
            }
        };

        $x(window).scrollTop(0);

        SP.SOD.execute('sp.ui.dialog.js', 'SP.UI.ModalDialog.showModalDialog', options);
        INTONotifications.updateNotificationPopUI();

    },

    updateNotificationPopUI: function updateNotificationPopUI() {
        setTimeout(function () {
            if ($x('.ms-dlgTitle').length == 1) {
                var styles = { border: "none", height: "auto" };
                $x('.ms-dlgTitle').css('display', 'none');
                $x(".ms-dlgContent").css(styles);
                $x(".ms-dlgBorder").css(styles);
                $x(".ms-dlgFrameContainer").css(styles);
                $x(".ms-dlgFrameContainer").css("width", "+=2");

                //Close function.
                $x(".PopUpClose").on("click", function () {
                    var popUpData = [];
                    popUpData[0] = 'Closed';
                    popUpData[1] = $x("#notificationshowMessage").is(":checked");
                    popUpData[2] = $x("#notificationshowMessage").is(":Visible");
                    popUpData[3] = $x("input:hidden[name=lastModified]").val();
                    popUpData[4] = $x("input:hidden[name=expiryDate]").val();

                    SP.UI.ModalDialog.commonModalDialogClose(SP.UI.DialogResult.cancel, popUpData);
                });
            }
            else {
                INTONotifications.updateNotificationPopUI();
            }
        }, 100);


    },

    createCookie: function createCookie(name, value, expiry) {

        INTONotifications.log('cookie expiry: ' + expiry);
        var expires = new Date(expiry);
        INTONotifications.log('cookie expires: ' + expires.toGMTString());
        INTONotifications.log('cookie expires: ' + moment(expiry).tz("Europe/London").format('YYYY-MM-DDTHH:mm:ss'));

        expires = '; expires=' + new Date(moment(expiry).tz("Europe/London").format('YYYY-MM-DDTHH:mm:ss')).toGMTString();
        
        document.cookie = name + '=' + value + expires + '; path=/';
    },

    readCookie: function readCookie(name) {
        var nameEQ = name + '=';
        var ca = document.cookie.split(';');
        INTONotifications.log(ca);

        for (var i = 0; i < ca.length; i++) {
            var c = ca[i];
            INTONotifications.log(c);
            while (c.charAt(0) == ' ') { c = c.substring(1, c.length) };
            if (c.indexOf(nameEQ) == 0) {
                INTONotifications.log(c.substring(nameEQ.length, c.length));
                return c.substring(nameEQ.length, c.length);
            };
        };
        return null;
    },

    eraseCookie: function (name) {
        INTONotifications.createCookie(name, '', -1);
    },

    log: function log(l) {
        if (INTONotifications.getParameterByName("log")) {
            console.log(l);
        }
    },

    getParameterByName: function getParameterByName(name, url) {
        if (!url) url = window.location.href;
        name = name.replace(/[\[\]]/g, "\\$&");
        var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
            results = regex.exec(url);
        if (!results) return null;
        if (!results[2]) return '';
        return decodeURIComponent(results[2].replace(/\+/g, " "));
    }
}


$x(document).ready(function () {
    if (!INTONotifications.getParameterByName("SkipNotification")) {
        INTONotifications.log("Notification window")
        INTONotifications.preCheckCookie();
    }
});

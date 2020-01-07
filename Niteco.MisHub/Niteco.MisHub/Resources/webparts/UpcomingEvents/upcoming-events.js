var UPCommingEvents = UPCommingEvents || {};
var $p = jQuery.noConflict();
var ueHtml = '';

var UEData = [
    {
        title: 'L&amp;L HCM-Intro to machine learning',
        href: '#',
        date: '30',
        month: 'Dec',
        temp: 'Monday',
        from: '12:00 PM',
        to: '01:00 PM',
    },
    {
        title: 'Episerver CMS series - 1st session - Hung Le',
        href: '#',
        date: '31',
        month: 'Sep',
        temp: 'Monday',
        from: '12:00 PM',
        to: '01:00 PM',
    },
    {
        title: 'Episerver CMS series - 2nd session - Ngoan Mai ',
        href: '#',
        date: '1',
        month: 'Jul',
        temp: 'Monday',
        from: '12:00 PM',
        to: '01:00 PM',
    },
]

$p(document).ready(function () {


    UPCommingEvents.render = function (data) {
        for (var i = 0; i < data.length; i++) {
            var e = data[i];

            ueHtml += `<div class="homepage_upcoming-events-item">

                        <!--Date and Month-->
                        <div class="homepage_upcoming-events-item__date">
                            <span class="homepage_upcoming-events-item__date--date">` + e.date + `</span>
                            <span class="homepage_upcoming-events-item__date--month">` + e.month + `</span>
                        </div>

                        <!--Content of this Item-->
                        <div class="homepage_upcoming-events-item__content">

                        
                            <div class="animated-background homepage_upcoming-events-placeholder js_upcoming-events-placeholder hidden">
                                <div class="background-masker homepage_upcoming-events-placeholder__title-bottom"></div>
                                <div class="background-masker homepage_upcoming-events-placeholder__day-right"></div>
                                <div class="background-masker homepage_upcoming-events-placeholder__pending-right"></div>
                            </div>
                        

                            <div class="homepage_upcoming-events-item__content-wrapper js_upcoming-events-content-wrapper">
                                <!--Heading of Item-->
                                <a class="homepage_upcoming-events-item__title js_upcoming-events-item__title" href="` + e.href + `" style="overflow-wrap: break-word;">
                                    ` + e.title + `
                                </a>
                                <div class="homepage_upcoming-events-item__time">
                                    <!--Day-->
                                    <span class="homepage_upcoming-events-item__day homepage_section-time">` + e.temp + `</span>
                                    <!--Pending time-->
                                    <span class="homepage_upcoming-events-item__pending--start">` + e.from + `</span>
                                    <span class="homepage_upcoming-events-item__pending--end">` + e.to + `</span>
                                </div>
                            </div>
                            <div class="clearfix"></div>
                        </div>
                    </div>`;
        }
    }

    UPCommingEvents.onload = function () {

        UPCommingEvents.render(UEData);
        $p("#" + "homepage_upcoming-events").append(ueHtml);
    }

    setTimeout(UPCommingEvents.onload(), 0);
})

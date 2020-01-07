var ANNouncement = ANNouncement || {};
var $p = jQuery.noConflict();
var annHtml = '';

var AnnData = [
    {
        title: 'New timeline for KPI &amp; PRS review',
        description: '',
        href: '#',
        avatar: '../siteassets/Niteco/images/announcements/Performance evaluation.jpeg',
        authorName: 'Hoai Thu Thi Vu',
        authorUrl: '#',
        createDate: '8/9/2019',
    },
    {
        title: 'Condensed guideline of Niteco performance assessment processes',
        description: '',
        href: '#',
        avatar: '../siteassets/Niteco/images/announcements/Niteco performance assessment processes - 20190409.jpg',
        authorName: 'Hoai Thu Thi Vu',
        authorUrl: '#',
        createDate: '4/10/2019',
    },
    {
        title: 'Introduction to Niteco Career Path and Niteco Training System ',
        description: '',
        href: '#',
        avatar: '../siteassets/Niteco/images/announcements/NTS.png',
        authorName: 'Hoai Thu Thi Vu',
        authorUrl: '#',
        createDate: '4/5/2019',
    },
]

$p(document).ready(function () {
    

    ANNouncement.render = function (data) {
        for (var i = 0; i < data.length; i++) {
            var e = data[i];

            annHtml += `<div class="homepage_announcements-item">
                    
                        <div class="animated-background homepage_announcements-placeholder js_announcements-placeholder hidden">
                            <div class="background-masker homepage_announcements-placeholder__title-top"></div>
                            <div class="background-masker homepage_announcements-placeholder__title-left"></div>
                            <div class="background-masker homepage_announcements-placeholder__title-bottom"></div>
                            <div class="background-masker homepage_announcements-placeholder__subtitle-left"></div>
                            <div class="background-masker homepage_announcements-placeholder__subtitle-bottom"></div>
                            <div class="background-masker homepage_announcements-placeholder__author-left"></div>
                            <div class="background-masker homepage_announcements-placeholder__author-right"></div>
                            <div class="background-masker homepage_announcements-placeholder__time-right"></div>
                            <div class="background-masker homepage_announcements-placeholder__content-end"></div>
                        </div>

                        <div class="homepage_announcements-item-wrapper js_announcements-item-wrapper">
                            <a class="homepage_announcements-item__icon" href="` + e.href + `">
                                <img src="` + e.avatar +  `" class="homepage_announcements-item__icon--img">
                            </a>
                            <div class="homepage_announcements-item__content">
                                <a class="homepage_announcements-item__title js_announcements-item__title" href="` + e.href + `" style="overflow-wrap: break-word;">
                                    ` + e.title +  `
                                </a>
                                <div class="homepage_announcements-item__modified-by">
                                    <a class="homepage_announcements-item__team homepage_section-author" href="` + e.authorUrl + `">` + e.authorName + `</a>
                                    <span class="homepage_announcements-item__time homepage_section-time">` + e.createDate +  `</span>
                                </div>
                                <div class="clearfix"></div>
                            </div>
                        </div>
                    </div>
                        `
        }
    }

    ANNouncement.onload = function () {

        ANNouncement.render(AnnData);
        $p("#" + "homepage_announcements").append(annHtml);
    }

    setTimeout(ANNouncement.onload(), 0);
})

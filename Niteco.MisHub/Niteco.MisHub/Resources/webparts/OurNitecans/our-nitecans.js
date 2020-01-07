var OURNitecans = OURNitecans || {};
var $p = jQuery.noConflict();
var ourNiHtml = '';

var OurNiData = [
    {
        title: 'CONGRATULATIONS ON... ',
        description: `We're delighted to hear that the angel has come to your family...`,
        href: '#',
        avatar: '../siteassets/Niteco/images/our-nitecans/54671853-postcard-congratulations-you-have-a-boy-little-newborn-baby-boy-baby-in-cradle-with-blue-bow-.jpg',
        authorName: '',
        authorUrl: '#',
        createDate: '',
    },
    {
        title: 'WELCOME NEW... ',
        description: '​Good morning Nitecans, We gladly welcome new member joining us...',
        href: '#',
        avatar: '../siteassets/Niteco/images/our-nitecans/trang.ngo.jpg',
        authorName: '',
        authorUrl: '#',
        createDate: '',
    },
    {
        title: 'WELCOME NEW... ',
        description: 'Dear Nitecans, We hope you all enjoyed Niteco 9 th anniversary...',
        href: '#',
        avatar: '../siteassets/Niteco/images/our-nitecans/Vu Hoang Ngoc ava.jpg',
        authorName: '',
        authorUrl: '#',
        createDate: '',
    },
    {
        title: 'WELCOME NEW... ',
        description: 'Dear Nitecans, We hope you all enjoyed Niteco 9 th anniversary...',
        href: '#',
        avatar: '../siteassets/Niteco/images/our-nitecans/trang.nguyen6 ava.jpg',
        authorName: '',
        authorUrl: '#',
        createDate: '',
    },
]

$p(document).ready(function () {


    OURNitecans.render = function (data) {
        for (var i = 0; i < data.length; i++) {
            var e = data[i];

            ourNiHtml += `<div class="col-md-3 col-xs-3 homepage_our-nitecans__item">
                    <a class="homepage_our-nitecans__img-wrapper" href="` + e.href + `">
                        <img class="homepage_our-nitecans__img" src="` + e.avatar + `" alt="">
                    </a>
                    <div class="homepage_our-nitecans__content js_our-nitecans__content">
                        <div class="homepage_our-nitecans__title-wrapper">
                            <a class="homepage_our-nitecans__title js_our-nitecans__title is-truncated" href="` + e.href + `" style="overflow-wrap: break-word;">` + e.title + `</a>
                        </div>
                        <div class="homepage_our-nitecans__message js_our-nitecans__message" style="overflow-wrap: break-word;">
                            ` + e.description + `
                        </div>
                    </div>
                    <div class="animated-background homepage_our-nitecans-placeholder js_our-nitecans-placeholder hidden">
                        <div class="background-masker homepage_our-nitecans-placeholder__second-title-top"></div>
                        <div class="background-masker homepage_our-nitecans-placeholder__first-description-top"></div>
                        <div class="background-masker homepage_our-nitecans-placeholder__second-description-top"></div>
                    </div>
                </div>`;
        }
    }

    OURNitecans.onload = function () {

        OURNitecans.render(OurNiData);
        $p("#" + "homepage_our-nitecans").append(ourNiHtml);
    }

    setTimeout(OURNitecans.onload(), 0);
})

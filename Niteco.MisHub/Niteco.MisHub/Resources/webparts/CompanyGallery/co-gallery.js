var COGALLERY__ = COGALLERY__ || {};
var $p = jQuery.noConflict();
var cgalHtml = '';

var CgalData = [

    {
        title: '2019.01 Employee Appreciation Party',
        description: '',
        href: '#',
        avatar: '../siteassets/Niteco/images/gallery/_HNE4207.jpg',
    },
    {
        title: '2018.12 Niteco 8th Anniversary',
        description: '',
        href: '#',
        avatar: '../siteassets/Niteco/images/gallery/_HNE0588.jpg',
    },
    {
        title: '2018.10 OktoberFest',
        description: '',
        href: '#',
        avatar: '../siteassets/Niteco/images/gallery/IMG_20181026_192647.jpg',
    },
    {
        title: '2018.09 Mid Autumn',
        description: '',
        href: '#',
        avatar: '../siteassets/Niteco/images/gallery/IMG_0907.jpg',
    },
    {
        title: '2018.09 OPS Team Building',
        description: '',
        href: '#',
        avatar: '../siteassets/Niteco/images/gallery/20180918_182646.jpg',
    },
    {
        title: '2018.09 HCMC Football',
        description: '',
        href: '#',
        avatar: '../siteassets/Niteco/images/gallery/1537237441618.jpg',
    },
    {
        title: '2018.07 Phu Quoc Vacation',
        description: '',
        href: '#',
        avatar: '../siteassets/Niteco/images/gallery/IMG_1607.jpg',
    },
    {
        title: 'Wallpaper',
        description: '',
        href: '#',
        avatar: '../siteassets/Niteco/images/gallery/180618_TVScreen_16x9.jpg',
    },
]

$p(document).ready(function () {


    COGALLERY__.render = function (data) {
        for (var i = 0; i < data.length; i++) {
            var e = data[i];
            var active = '';
            if (i == 0) {
                active = 'active';
            }
            else {
                active = '';
            }

            cgalHtml += `<div class="item company-gallery__items ` + active + `">
                        <a class="homepage_company-gallery__image-wrapper" href="` + e.href + `">
                            <img class="homepage_company-gallery__image" src="` + e.avatar + `" alt="Chania">
                        </a>
                        <div class="homepage_company-gallery__content-wrapper">
                            <p class="homepage_company-gallery__title">` + e.title + `</p>
                        </div>
                    </div>`;
        }
    }

    COGALLERY__.onload = function () {

        COGALLERY__.render(CgalData);
        console.log(cgalHtml);
        $p("#" + "homepage_company-gallery-carousel").append(cgalHtml);
    }

    setTimeout(COGALLERY__.onload(), 0);
})

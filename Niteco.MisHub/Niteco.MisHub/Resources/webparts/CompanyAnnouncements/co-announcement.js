
var HOTNews = HOTNews || {};
var $p = jQuery.noConflict();
var hmHtml = '';
var hnIndicators = '';

var HotNewsData = [
    {
        title: 'Ascend 2019: What happened in Miami',
        description: 'We were proud Platinum sponsors of Episerver Ascend 2019, which saw a change of location and a record-breaking turnout this year. More than 1000 Episerver partners, customers and prospects congregated at the Fontainebleau hotel in Miami Beach for a combination of... ',
        href: '#',
        avatar: '../siteassets/Niteco/images/hotnews/Ascend 2019 pic of Mark Lotta and Fredrik.png',
        authorName: 'Akofa Wallace',
        authorUrl: '#',
        createDate: '11/6/2019',
    },
    {
        title: 'Congratulations Vinh and Hieu of Odin!',
        description: 'Odin division team members, Vinh Le and Hieu Nguyen are the first Nitecans to become Magento certified! As of this month, Vinh and Hieu hold the Magento 2 certified professional developer plus and the Magento 2 certified professional front end developer certificate...',
        href: '#',
        avatar: '../siteassets/Niteco/images/hotnews/magento devs.png',
        authorName: 'Akofa Wallace',
        authorUrl: '#',
        createDate: '10/31/2019',
    },
    {
        title: 'AMS is now known as 24/7 Proactive Response',
        description: 'e have relaunched our round-the-clock management service as we see a spike in the take up of our unique offering. Now known as 24 / 7 Proactive Response, the rebrand better reflects the active management team customers can have at their disposal in order to ensure their site is...',
        href: '#',
        avatar: '../siteassets/Niteco/images/hotnews/247proactive.jpg',
        authorName: 'Akofa Wallace',
        authorUrl: '#',
        createDate: '10/17/2019',
    },
    {
        title: 'Niteco Ekiden Season 3 - Recap',
        description: `What Nitecans Talk About When We Talk About Running Ekiden is Niteco's famous running contest that has received widespread support and unbelievable enthusiasm from Nitecans based in Hanoi. The first two seasons were extremely fun and successful, thus many asked...`,
        href: '#',
        avatar: '../siteassets/Niteco/images/hotnews/Performance evaluation.jpeg',
        authorName: 'An Khanh Lai',
        authorUrl: '#',
        createDate: '10/8/2019',
    },
    {
        title: 'Lotta Joins Niteco!',
        description: `Exciting times are ahead for us all! We’re expanding our leadership team in order to take us to the next level.
Pelle is pleased to welcome former Microsoft guru, Lotta Widorson Lassfolk to Niteco. Lotta will be joining Niteco on August 16th and will take on the role of Global Executive...`,
        href: '#',
        avatar: '../siteassets/Niteco/images/hotnews/Lotta-3.jpg',
        authorName: 'Akofa Wallace',
        authorUrl: '#',
        createDate: '6/4/2019',
    },
]

$p(document).ready(function () {

    console.log('Hot News');

    HOTNews.render = function (data) {
        for (var i = 0; i < data.length; i++) {
            var e = data[i];
            var hnActive = '';
            var hnActiveLeft = '';
            if (i == 0) {
                hnActive = ' active';
            }
            else {
                var hnActive = '';
            }

            hnIndicators += `<li data-target="#hotNews" data-slide-to="` + i + `" class="`;
            if (i == 0) {
                hnIndicators += ' active';
            }
            hnIndicators += '"></li>';

            hmHtml += `<div class="item `;
            if (i == 0) {
                hmHtml += ' active';
            }
            else if (i == 1) {
                hmHtml += ' next';
            }
            
            hmHtml += `">
                        <a class="homepage_hot-news__image-wrapper" href="` + e.href + `">
                            <img class="homepage_hot-news__image" src="` + e.avatar + `" alt="Chania">
                        </a>
                        <div class="homepage_hot-news__content-wrapper js_hot-news__content-wrapper" style="background: 100%">
                            <a class="homepage_hot-news__title js_hot-news__title" href="` + e.href + `" style="overflow-wrap: break-word;">`
                + e.title +
                            `</a>
                            <div class="homepage_hot-news__content">
                                <div class="homepage_hot-news__description" style="overflow-wrap: break-word;">`
                + e.description +
                            `
                            <a class="readmore homepage_hot-news__read-more" href="` + e.href + `" style="display: inline;">Read more</a></div>
                            </div>
                            <div class="homepage_hot-news__modified-by">
                                <a class="homepage_section-author" href="` + e.authorUrl + `">
                                    ` + e.authorName + `
                                </a>
                                <span class="homepage_section-time homepage_hot-news__time">
                                    ` + e.createDate + `
                                </span>
                            </div>
                        </div>
                        <div class="animated-background homepage_hot-news-placeholder js_hot-news-placeholder hidden">
                            <div class="background-masker homepage_hot-news-placeholder__first-description-top"></div>
                            <div class="background-masker homepage_hot-news-placeholder__second-description-top"></div>
                            <div class="background-masker homepage_hot-news-placeholder__third-description-top"></div>
                            <div class="background-masker homepage_hot-news-placeholder__last-description-top"></div>
                            <div class="background-masker homepage_hot-news-placeholder__last-description-bottom"></div>
                            <div class="background-masker homepage_hot-news-placeholder__author-right"></div>
                            <div class="background-masker homepage_hot-news-placeholder__time-right"></div>
                        </div>
                    </div>`
        }
    }

    HOTNews.onload = function () {

        HOTNews.render(HotNewsData);
        $p("#" + "carousel-indicators").append(hnIndicators);

        $p("#" + "carousel-inner").append(hmHtml);
    }

    setTimeout(HOTNews.onload(), 0);
})

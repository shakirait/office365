var DISCussionView = DISCussionView || {};
var $p = jQuery.noConflict();
var discHtml = '';

var DiscData = [
    {
        title: 'Standard Chartered Cup 2019, đường đến nước Anh',
        description: '',
        href: '#',
        authorName: 'Minh Quang Mai',
        authorUrl: '#',
        createDate: '8/9/2019',
        comment: '4',
    },
    {
        title: 'Football match HCM vs HN',
        description: 'https://intranet.niteco.se/Lists/Hot%20News/DispForm.aspx?ID=700',
        href: '#',
        authorName: 'Minh Quang Mai',
        authorUrl: '#',
        createDate: '8/9/2019',
        comment: '4',
    },
    {
        title: 'Cuộc chiến giữa các vị thần',
        description: 'Long, long ago khi thế giới chỉ là một cõi hư không, không có trời cũng không có trái đât. Khi đó sự kết hợp giữa lửa và băng đã tạo ra một người khổng lồ Yimir',
        href: '#',
        authorName: 'Minh Quang Mai',
        authorUrl: '#',
        createDate: '8/9/2019',
        comment: '4',
    },
]

$p(document).ready(function () {


    DISCussionView.render = function (data) {
        for (var i = 0; i < data.length; i++) {
            var e = data[i];

            discHtml += `<div class="homepage_discussion-view-item">
                    <!--Heading of Item-->
                    <a class="homepage_discussion-view-item__title" href="` + e.href + `">
                        <b>
                            ` + e.title + `
                        </b>
                    </a>
                    <!--Discussion description-->
                    <div class="homepage_discussion-view-item__description">
                        ` + e.description + `
                    </div>
                    <div class="homepage_discussion-view-item__modified-by">
                        <!--Author name-->

                        <a class="homepage_discussion-view-item__author homepage_section-author" href="` + e.authorUrl + `">
                            ` + e.authorName + `
                        </a>
                        <!--Date time-->
                        <span class="homepage_discussion-view-item__time homepage_section-time">` + e.createDate + `</span>
                        <!--Number of comment(s)-->
                        <span class="homepage_discussion-view-item__comment homepage_section-comment">` + e.comment + ` comment(s)</span>
                    </div>
                </div>`;
        }
    }

    DISCussionView.onload = function () {

        DISCussionView.render(DiscData);
        $p("#" + "homepage_discussion-view").append(discHtml);
    }

    setTimeout(DISCussionView.onload(), 0);
})

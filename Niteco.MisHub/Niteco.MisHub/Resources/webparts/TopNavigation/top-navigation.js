

var TOPNav = TOPNav || {};
var $p = jQuery.noConflict();
var data = [
    {
        id: '1',
        text: 'Menu 1',
        url: '#'
    },
    {
        id: '2',
        text: 'Menu 2',
        url: '#',
        childs: [
            {
                id: '1',
                text: 'Sub menu 1',
                url: '#'
            },
            {
                id: '2',
                text: 'Sub menu 2',
                url: '#',

                childs: [
                    {
                        id: '1',
                        text: 'Sub Sub menu 1',
                        url: '#'
                    },
                    {
                        id: '2',
                        text: 'Sub Sub menu 2',
                        url: '#',

                    },
                ]
            },
        ]
    },
    {
        id: '3',
        text: 'Menu 3',
        url: '#'
    },
];

$p(document).ready(function () {

    console.log('Top Navigation');


    TOPNav.render = function (name, data) {
        $p = jQuery.noConflict();

        $p(`#` + name).append("<ul>");
        for (var i = 0; i < data.length; i++) {
            var li = `
                    <li id="` + name + data[i].id + `">
                        <a href="">` + data[i].text + `</a>
                    </li>
                    `;
            $p("#" + name).append(li);

            if (data[i].childs && data[i].childs.length > 0) {
                TOPNav.render(name + data[i].id, data[i].childs);
            }
        }

        $p("#" + name).append("</ul>");
    }

    TOPNav.onload = function () {

        TOPNav.render("top-nav", data);
    }

    setTimeout(TOPNav.onload(), 0);
})

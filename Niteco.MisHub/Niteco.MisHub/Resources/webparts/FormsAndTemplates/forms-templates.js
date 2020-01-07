var FaTDocument = FaTDocument || {};
var $p = jQuery.noConflict();
var fatHtml = '';

var FaTData = [
    {
        title: 'Swedish Team',
        description: '',
        href: '#',
        avatar: '../siteassets/Niteco/images/icon/folder.gif',
    },
    {
        title: 'Niteco Corporate ID (Document template)',
        description: '',
        href: '#',
        avatar: '../siteassets/Niteco/images/icon/folder.gif',
    },
    {
        title: 'Accounting Forms and Templates',
        description: '',
        href: '#',
        avatar: '../siteassets/Niteco/images/icon/folder.gif',
    },
    {
        title: 'Payment Procedure - Quy Trinh Thanh Toan.docx',
        description: '',
        href: '#',
        avatar: '../siteassets/Niteco/images/icon/icdocx.png',
    },
    {
        title: 'Niteco Email Signature Template 1.1.pdf',
        description: '',
        href: '#',
        avatar: '../siteassets/Niteco/images/icon/icpdf.png',
    },
    {
        title: 'How to create a Discussion topic.pdf',
        description: '',
        href: '#',
        avatar: '../siteassets/Niteco/images/icon/icpdf.png',
    },
    {
        title: 'The Intranet for Nitecans - Guidelines 1.0.pdf',
        description: '',
        href: '#',
        avatar: '../siteassets/Niteco/images/icon/icpdf.png',
    },
    {
        title: 'Niteco - Room Booking.pdf',
        description: '',
        href: '#',
        avatar: '../siteassets/Niteco/images/icon/icpdf.png',
    },
]

$p(document).ready(function () {


    FaTDocument.render = function (data) {
        for (var i = 0; i < data.length; i++) {
            var e = data[i];

            fatHtml += `<li class="homepage_forms-templates__item intranet_documents-section__item">
                    <a class="homepage_forms-templates__file intranet_documents-section__file" href="` + e.href + `">
                        <!--Icon-->
                        <img class="homepage_forms-templates__image intranet_documents-section__image" src="` + e.avatar + `">
                        <!--File name-->
                        ` + e.title + `
                    </a>
                </li>`;
        }
    }

    FaTDocument.onload = function () {

        FaTDocument.render(FaTData);
        $p("#" + "homepage_forms-templates").append(fatHtml);
    }

    setTimeout(FaTDocument.onload(), 0);
})

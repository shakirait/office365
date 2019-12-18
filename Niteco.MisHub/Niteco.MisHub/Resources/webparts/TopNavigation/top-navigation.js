

var TOPNav = TOPNav || {};
var $p = jQuery.noConflict();
var data = [
    {
        id: '1',
        text: 'COMPANY',
        url: '#',
        childs: [
            {
                id: '1',
                text: 'Organization Chart',
                url: '#'
            },
            {
                id: '2',
                text: 'News',
                url: '#'
            },
            {
                id: '3',
                text: 'Events',
                url: '#'
            },
            {
                id: '4',
                text: 'Discussion',
                url: '#'
            },
            {
                id: '5',
                text: 'Gallery',
                url: '#'
            },
            {
                id: '6',
                text: 'Niteco Social Club',
                url: '#',
                childs: [

                    {
                        id: '61',
                        text: 'Badminton',
                        url: '#'
                    },
                    {
                        id: '62',
                        text: 'Football',
                        url: '#'
                    },
                ]
            },
            {
                id: '7',
                text: 'NICEF',
                url: '#'
            },
            {
                id: '8',
                text: 'Trade Union',
                url: '#'
            },
            {
                id: '9',
                text: 'Resources',
                url: '#',
                childs: [

                    {
                        id: '91',
                        text: 'Company Presentations',
                        url: '#'
                    },
                    {
                        id: '92',
                        text: 'Forms and Templates',
                        url: '#'
                    },
                ]
            },
            {
                id: '10',
                text: 'Links',
                url: '#',
                childs: [

                    {
                        id: '101',
                        text: 'Efficient Time',
                        url: '#'
                    },
                    {
                        id: '102',
                        text: 'Jira',
                        url: '#'
                    },
                    {
                        id: '103',
                        text: 'Confluence',
                        url: '#'
                    },
                ]
            },
        ]
    },
    {
        id: '2',
        text: 'PMO',
        url: '#',
        childs: [
            {
                id: '',
                text: 'Niteco Project Process',
                url: '#',
            },
            {
                id: '',
                text: 'Development Methodology',
                url: '#',
            },
            {
                id: '',
                text: 'Contract Management',
                url: '#',
            },
            {
                id: '',
                text: 'Resource Summary',
                url: '#',
            },
            {
                id: '',
                text: 'Resource Finder',
                url: '#',
            },
            {
                id: '',
                text: 'Available resources overview',
                url: '#',
            },
            {
                id: '',
                text: 'Project Management',
                url: '#',
            },
            {
                id: '',
                text: 'Forum',
                url: '#',
            },
            {
                id: '',
                text: 'Administration',
                url: '#',
                childs: [
                    {
                        id: '1',
                        text: 'Customers',
                        url: '#',
                    },
                    {
                        id: '1',
                        text: 'Roles',
                        url: '#',
                    }
                ]
            },
        ]
    },
    {
        id: '2',
        text: 'HR',
        url: '#',
        childs: [
            {
                id: '1',
                text: 'Employee Information',
                url: '#',
                childs: [
                    {
                        id: '11',
                        text: 'Employee Directory',
                        url: '#'
                    },
                    {
                        id: '12',
                        text: 'Employee Certification',
                        url: '#'
                    },
                    {
                        id: '13',
                        text: 'Employee Identity',
                        url: '#'
                    },
                    {
                        id: '14',
                        text: 'Employee Skills',
                        url: '#'
                    },
                    {
                        id: '15',
                        text: 'Employee Family Relationship',
                        url: '#'
                    },
                ]
            },
            {
                id: '2',
                text: 'Performance Management',
                url: '#',
                childs: [
                    {
                        id: '21',
                        text: 'About KPI System',
                        url: '#'
                    },
                    {
                        id: '22',
                        text: 'My Evaluations',
                        url: '#'
                    },
                    {
                        id: '23',
                        text: 'Organization Assessment',
                        url: '#'
                    },
                    {
                        id: '24',
                        text: 'System Management',
                        url: '#',
                        childs: [
                            {
                                id: '241',
                                text: 'User Roles Management',
                                url: '#'
                            },
                            {
                                id: '242',
                                text: 'Email Templates',
                                url: '#'
                            },
                            {
                                id: '243',
                                text: 'Question Templates',
                                url: '#'
                            },
                            {
                                id: '244',
                                text: 'Department Generation Rule',
                                url: '#'
                            },
                            {
                                id: '245',
                                text: 'Log Viewer',
                                url: '#'
                            },
                        ]
                    },
                ]
            },
            {
                id: '3',
                text: 'Recruitment',
                url: '#',
                childs: [
                    {
                        id: '31',
                        text: 'RECRUITMENT PROCESS',
                        url: '#'
                    },
                    {
                        id: '32',
                        text: 'Referral Policy',
                        url: '#'
                    },
                ]
            },
            {
                id: '4',
                text: 'Policies and Processes',
                url: '#',
                childs: [
                    {
                        id: '41',
                        text: 'Internal Labour Regulation',
                        url: '#'
                    },
                    {
                        id: '42',
                        text: 'EMPLOYEE ANNIVERSARY POLICY',
                        url: '#'
                    },
                    {
                        id: '43',
                        text: 'Onboarding Process',
                        url: '#'
                    },
                    {
                        id: '44',
                        text: 'Onsite Policy',
                        url: '#'
                    },
                    {
                        id: '45',
                        text: 'Exit Process',
                        url: '#'
                    },
                ]
            },
            {
                id: '5',
                text: 'Training and Development',
                url: '#',
                childs: [
                    {
                        id: '51',
                        text: 'Career Path',
                        url: '#'
                    },
                    {
                        id: '52',
                        text: 'Niteco Training System',
                        url: '#'
                    },
                    {
                        id: '53',
                        text: 'TRAINING ACTIVITIES',
                        url: '#'
                    },
                    {
                        id: '54',
                        text: 'Training Policy',
                        url: '#'
                    },
                    {
                        id: '55',
                        text: 'Training Resources',
                        url: '#',
                        childs: [
                            {
                                id: '',
                                text: 'English Material',
                                url: '#'
                            },
                            {
                                id: '',
                                text: 'Online Courses',
                                url: '#'
                            },
                            {
                                id: '',
                                text: 'Soft Skills',
                                url: '#'
                            },
                            {
                                id: '',
                                text: 'Lunch and Learn Materials',
                                url: '#'
                            },
                        ]
                    },
                ]
            },
            {
                id: '6',
                text: 'Administration',
                url: '#',
                childs: [
                    {
                        id: '',
                        text: 'Job Title',
                        url: '#'
                    },
                    {
                        id: '',
                        text: 'Job Level',
                        url: '#'
                    },
                    {
                        id: '',
                        text: 'Job Main Field',
                        url: '#'
                    },
                    {
                        id: '',
                        text: 'Certificates',
                        url: '#'
                    },
                    {
                        id: '',
                        text: 'Certificate Types',
                        url: '#'
                    },
                    {
                        id: '',
                        text: 'Skills',
                        url: '#'
                    },
                    {
                        id: '',
                        text: 'Skills Category',
                        url: '#'
                    },
                    {
                        id: '',
                        text: 'Skills Level',
                        url: '#'
                    },
                ]
            },
        ]
    },
    {
        id: '3',
        text: 'IT',
        url: '#'
    },
    {
        id: '3',
        text: 'SMARKETING',
        url: '#'
    },
];
var html = '';

$p(document).ready(function () {

    console.log('Top Navigation');


    TOPNav.render = function ( className, data, isFirst) {
        $p = jQuery.noConflict();

        for (var i = 0; i < data.length; i++) {
            var childrenClass = ""
            if (data[i].childs && data[i].childs.length > 0) {
                childrenClass = "dynamic-children";
            }
            html += `
                    <li class="` + className + `">
                        <a class="` + className + " " + childrenClass + ` menu-item ms-core-listMenu-item ms-displayInline ms-navedit-linkNode" tabindex="0" href="#" >
                            <span class="additional-background ms-navedit-flyoutArrow">
                                <span class="menu-item-text">`
                                   + data[i].text + 
                    `</span></span></a>`;

            if (data[i].childs && data[i].childs.length > 0) {
                html += `<ul class="dynamic">`;
                TOPNav.render( "dynamic", data[i].childs, false);
                html += "</ul>";
            }
            html += "</li>"
        }
        return html;

    }

    TOPNav.onload = function () {
        
        TOPNav.render( "static", data, true);
        $p("#" + "rootAspMenu").append(html);
    }

    setTimeout(TOPNav.onload(), 0);
})

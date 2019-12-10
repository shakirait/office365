<%@ Page language="C#"   Inherits="Microsoft.SharePoint.Publishing.PublishingLayoutPage,Microsoft.SharePoint.Publishing,Version=16.0.0.0,Culture=neutral,PublicKeyToken=71e9bce111e9429c" meta:progid="SharePoint.WebPartPage.Document" meta:webpartpageexpansion="full" %>
<%@ Register Tagprefix="SharePointWebControls" Namespace="Microsoft.SharePoint.WebControls" Assembly="Microsoft.SharePoint, Version=16.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %> <%@ Register Tagprefix="WebPartPages" Namespace="Microsoft.SharePoint.WebPartPages" Assembly="Microsoft.SharePoint, Version=16.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %> <%@ Register Tagprefix="PublishingWebControls" Namespace="Microsoft.SharePoint.Publishing.WebControls" Assembly="Microsoft.SharePoint.Publishing, Version=16.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %> <%@ Register Tagprefix="PublishingNavigation" Namespace="Microsoft.SharePoint.Publishing.Navigation" Assembly="Microsoft.SharePoint.Publishing, Version=16.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Register Tagprefix="SharePoint" Namespace="Microsoft.SharePoint.WebControls" Assembly="Microsoft.SharePoint, Version=16.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %> <%@ Register Tagprefix="WebPartPages" Namespace="Microsoft.SharePoint.WebPartPages" Assembly="Microsoft.SharePoint, Version=16.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %> <%@ Register Tagprefix="PublishingWebControls" Namespace="Microsoft.SharePoint.Publishing.WebControls" Assembly="Microsoft.SharePoint.Publishing, Version=16.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %> <%@ Register Tagprefix="PublishingNavigation" Namespace="Microsoft.SharePoint.Publishing.Navigation" Assembly="Microsoft.SharePoint.Publishing, Version=16.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>


<asp:Content ContentPlaceholderID="PlaceHolderAdditionalPageHead" runat="server">
    <SharePoint:SPShortcutIcon runat="server" IconUrl="../SiteAssets/Niteco/Images/favicon.ico" />

	<script type="text/javascript" src="https://code.jquery.com/jquery-1.11.3.min.js"></script>
    <script type="text/javascript" src="../SiteAssets/Niteco/Responsive/js/bootstrap.min.js"></script>
    <script src="../SiteAssets/Niteco/webparts/Nav/jquery.fs.scroller.min.js"></script>
    <script type="text/javascript" src="../SiteAssets/Niteco/Responsive/js/bootstrap.min.js"></script>


    <link rel="stylesheet" type="text/css" href="../SiteAssets/Niteco/css/font-awesome.css" />
    <link rel="stylesheet" type="text/css" href="../SiteAssets/Niteco/Responsive/css/bootstrap.css" />
	 <link rel="stylesheet" type="text/css" media="all" href="../siteassets/Niteco/webparts/Nav/jquery.fs.scroller.min.css" />
    <link rel="stylesheet" type="text/css" href="../SiteAssets/Niteco/css/into.css" />

    <script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/moment.js/2.10.3/moment.js"></script>
    <script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/moment-timezone/0.5.13/moment-timezone-with-data.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery.SPServices/2014.02/jquery.SPServices-2014.02.min.js"></script>
    
</asp:Content>

<asp:Content ContentPlaceholderID="PlaceHolderPageTitle" runat="server">
	<SharePointWebControls:FieldValue id="PageTitle" FieldName="Title" runat="server"/>
</asp:Content>
<asp:Content ContentPlaceholderID="PlaceHolderMain" runat="server">
	<div id='into-pagecontent'>
        <div class="container">
            <!-- Title Row-->
            <div class="row">
                 <div id="mainBody" class="homepage_body-wrapper">
                    <div class="row homepage_body-row">
                        <!-- Company announcements -->
                        <div class="col-xs-8 col-sm-8 col-md-8">
                            <WebPartPages:WebPartZone runat="server" AllowPersonalization="false" FrameType="TitleBarOnly" ID="wpHotNews" Title="Hot News">
                                <ZoneTemplate></ZoneTemplate>
                            </WebPartPages:WebPartZone>
                        </div>

                        <!-- Announcements -->
                        <div class="col-xs-4 col-sm-4 col-md-4">
                            <WebPartPages:WebPartZone runat="server" ID="wpAnnouncements" Title="Announcements" AllowPersonalization="false" FrameType="TitleBarOnly" >
                                <ZoneTemplate></ZoneTemplate>
                            </WebPartPages:WebPartZone>
                        </div>

                    </div>
                    <div class="row homepage_body-row">
                        <%-- Our Nitecans --%>
                        <div class="col-xs-8 col-sm-8 col-md-8">
                            <WebPartPages:WebPartZone runat="server" AllowPersonalization="false" FrameType="TitleBarOnly" ID="wpOurNitecans" Title="Our Nitecans">
                                <ZoneTemplate></ZoneTemplate>
                            </WebPartPages:WebPartZone>
                        </div>

                        <!-- Upcoming events -->
                        <div class="col-xs-4 col-sm-4 col-md-4">
                            <WebPartPages:WebPartZone runat="server" ID="wpUpcomingEvents" Title="Upcoming events" AllowPersonalization="false" FrameType="TitleBarOnly">
                                <ZoneTemplate></ZoneTemplate>
                            </WebPartPages:WebPartZone>
                        </div>
                    </div>

                    <div class="row homepage_body-row">
                        <%-- Forms and templates --%>
                        <div class="col-xs-4 col-sm-4 col-md-4">
                            <WebPartPages:WebPartZone runat="server" AllowPersonalization="false" FrameType="TitleBarOnly"  ID="wpFormsAndTemplates" Title="Forms and templates">
                                <ZoneTemplate></ZoneTemplate>
                            </WebPartPages:WebPartZone>
                        </div>

                        <!-- Discussion view -->
                        <div class="col-xs-4 col-sm-4 col-md-4">
                            <WebPartPages:WebPartZone runat="server" AllowPersonalization="false" FrameType="TitleBarOnly" ID="wpDiscussionView" Title="Discussion view">
                                <ZoneTemplate></ZoneTemplate>
                            </WebPartPages:WebPartZone>
                        </div>

                        <!-- Company gallery -->
                        <div class="col-xs-4 col-sm-4 col-md-4">
                            <WebPartPages:WebPartZone runat="server" ID="wpCompanyGallery" Title="Company gallery" AllowPersonalization="false" FrameType="TitleBarOnly">
                                <ZoneTemplate></ZoneTemplate>
                            </WebPartPages:WebPartZone>
                        </div>
                    </div>
                </div>
            </div>
        </div>
	</div>
    <!-- insert footer -->
                <div class="footer ms-dialogHidden">
                    <div class="container">
                        <div class="row">
                            <div class="col-xs-12 col-sm-6 col-md-6 copyright">
                                <p><strong>&copy; 2020 Niteco Company Ltd.</strong></p>
                                <p class="version">Version 1.0</p>
                            </div>
                            <div class="col-xs-12 col-sm-6 col-md-6 social_links">
                                <div class="pull-right">
                                    <span>Follow us on:</span>
                                    <a class="footer__niteco-icon" href="https://niteco.com/" target="_blank"></a>
                                    <a href="https://www.facebook.com/Niteco" target="_blank"><i class="icon-facebook-sign"></i></a>
                                    <a href="https://twitter.com/NitecoCompany" target="_blank"><i class="icon-twitter-sign"></i></a>
                                    <a href="https://www.linkedin.com/company/niteco-vietnam-company-limited" target="_blank"><i class="icon-linkedin-sign"></i></a>
                                    <a href="https://www.youtube.com/user/nitecocompany" target="_blank"><i class="icon-youtube-sign"></i></a>
                                <div style="clear: both;"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
</asp:Content>
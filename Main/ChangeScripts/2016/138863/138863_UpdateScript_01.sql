use lp_transactions

GO
update WebConfigurationValues
set ConfigurationValue=
'_wpcmWpid=&wpcmVal=&MSOWebPartPage_PostbackSource=&MSOTlPn_SelectedWpId=&MSOTlPn_View=0&MSOTlPn_ShowSettings=False&MSOGallery_SelectedLibrary=&MSOGallery_FilterString=&MSOTlPn_Button=none&__EVENTTARGET=#EVENTTARGET#&__EVENTARGUMENT=&__REQUESTDIGEST=#REQUESTDIGEST#&MSOSPWebPartManager_DisplayModeName=Browse&MSOSPWebPartManager_ExitingDesignMode=false&MSOWebPartPage_Shared=&MSOLayout_LayoutChanges=&MSOLayout_InDesignMode=&_wpSelected=&_wzSelected=&MSOSPWebPartManager_OldDisplayModeName=Browse&MSOSPWebPartManager_StartWebPartEditingName=false&MSOSPWebPartManager_EndWebPartEditing=false&__LASTFOCUS=&__VIEWSTATE=#VIEWSTATE#&__VIEWSTATEGENERATOR=E3165DA7&__EVENTVALIDATION=#EVENTVALIDATION#&Username=&Password=&ctl00%24ctl76%24g_86daaf10_fb31_4f6d_adf3_d7c384f128a3%24ctl00%24RequestOption=1&ctl00%24ctl76%24g_86daaf10_fb31_4f6d_adf3_d7c384f128a3%24ctl00%24AccountNumber=#ACCOUNTNUMBER#'                       
where WebpageReference='HomePageData3'
and UtilityCode='COMED'

GO

update WebConfigurationValues
set ConfigurationValue=
'_wpcmWpid=&wpcmVal=&MSOWebPartPage_PostbackSource=&MSOTlPn_SelectedWpId=&MSOTlPn_View=0&MSOTlPn_ShowSettings=False&MSOGallery_SelectedLibrary=&MSOGallery_FilterString=&MSOTlPn_Button=none&__EVENTTARGET=#EVENTTARGET#&MSOSPWebPartManager_DisplayModeName=Browse&MSOSPWebPartManager_ExitingDesignMode=false&MSOWebPartPage_Shared=&MSOLayout_LayoutChanges=&MSOLayout_InDesignMode=&_wpSelected=&_wzSelected=&MSOSPWebPartManager_OldDisplayModeName=Browse&MSOSPWebPartManager_StartWebPartEditingName=false&MSOSPWebPartManager_EndWebPartEditing=false&__LASTFOCUS=&__VIEWSTATE=#VIEWSTATE#&__VIEWSTATEGENERATOR=E3165DA7&__EVENTVALIDATION=#EVENTVALIDATION#&Username=&Password=&ctl00%24ctl76%24g_86daaf10_fb31_4f6d_adf3_d7c384f128a3%24ctl00%24RequestOption=1'                       
where WebpageReference='HomePageData2'
and UtilityCode='COMED'
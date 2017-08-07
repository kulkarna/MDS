namespace LibertyPower.DataAccess.WebAccess.WebScraperManagement
{
	using System.Web;
	using System.Net;
	using System.IO;

	public static class RgeScraper
	{

		public static string GetAccountUsageHtml( string accountNumber )
		{
			CookieContainer cookieContainer = new CookieContainer();

			RequestLoginPage( cookieContainer );
			RequestFileListPage( cookieContainer );

			return RequestAccountUsagePage( accountNumber, cookieContainer );
		}

		private static string RequestLoginPage( CookieContainer cookieContainer )
		{
			/*
			 * This is the first request to get values of __VIEWSTATE and __EVENTVALIDATION
			 * */
			string loginFirstResponse = RequestWebPage( RgeConfigurationValues.ValueOf.HomePage, string.Empty, cookieContainer );

			/*
			 * This is the second request for 'postback' __VIEWSTATE, __EVENTVALIDATION and all the
			 * data needed to accomplish the login phase
			 * */
			string viewState = ExtractViewState( loginFirstResponse );
			string eventValidation = ExtractEventValidation( loginFirstResponse );
			string postData = GetLoginPageData( viewState, eventValidation,
				RgeConfigurationValues.ValueOf.Username, RgeConfigurationValues.ValueOf.Password );

			return RequestWebPage( RgeConfigurationValues.ValueOf.HomePage, postData, cookieContainer );
		}

		private static string RequestFileListPage( CookieContainer cookieContainer )
		{
			return RequestWebPage( RgeConfigurationValues.ValueOf.FileListPage, string.Empty, cookieContainer );
		}

		private static string RequestAccountUsagePage( string accountNumber, CookieContainer cookieContainer )
		{
			/*
			 * This is the first request to get values of __VIEWSTATE and __EVENTVALIDATION
			 * */
			string responseData = RequestWebPage( RgeConfigurationValues.ValueOf.BillHistoryPage, string.Empty, cookieContainer );

			string viewStateData = ExtractViewState( responseData );
			string eventValidationData = ExtractEventValidation( responseData );
			string postData = GetUsageReportPageData( viewStateData, eventValidationData, accountNumber );

			/*
			 * This is the second request for 'postback' __VIEWSTATE, __EVENTVALIDATION and all the
			 * data needed to accomplish the report phase.
			 * */
			return RequestWebPage( RgeConfigurationValues.ValueOf.BillHistoryPage, postData, cookieContainer );
		}

		private static string GetPageData( string postData, string viewStateData, string eventValidationData )
		{
			if( !string.IsNullOrEmpty( viewStateData ) )
				postData += "&__VIEWSTATE=" + viewStateData;
			if( !string.IsNullOrEmpty( eventValidationData ) )
				postData += "&__EVENTVALIDATION=" + eventValidationData;

			return postData;
		}

		private static string GetLoginPageData( string viewStateData, string eventValidationData, string username, string password )
		{
			string postData;

			postData = string.Format( RgeConfigurationValues.ValueOf.HomePageData, username, password );
			postData = GetPageData( postData, viewStateData, eventValidationData );

			return postData;
		}

		private static string GetUsageReportPageData( string viewStateData, string eventValidationData, string accountNumber )
		{
			string postData;

			postData = string.Format( RgeConfigurationValues.ValueOf.BillHistoryPageData, accountNumber );
			postData = GetPageData( postData, viewStateData, eventValidationData );

			return postData;
		}

		private static string RequestWebPage( string url, string postData, CookieContainer cookieContainer )
		{
			HttpWebRequest webRequest = (HttpWebRequest) HttpWebRequest.Create( url );

			webRequest.Method = "POST";
			webRequest.ContentType = "application/x-www-form-urlencoded";
			webRequest.CookieContainer = cookieContainer;
			webRequest.Timeout = 300000;

			if( !string.IsNullOrEmpty( postData ) )
			{
				webRequest.ContentLength = postData.Length;
				StreamWriter requestWriter = new StreamWriter( webRequest.GetRequestStream() );

				requestWriter.Write( postData );
				requestWriter.Close();
			}
			else
			{
				webRequest.ContentLength = 0;
			}
			StreamReader responseReader = new StreamReader( webRequest.GetResponse().GetResponseStream() );
			string responseData = responseReader.ReadToEnd();

			responseReader.Close();

			return responseData;
		}

		private static string GetHtmlElementValue( string textboxID, string htmlContent )
		{
			string valueToken = "value=\"";

			int textboxIDPosition = htmlContent.IndexOf( textboxID );

			if( textboxIDPosition < 0 )
				return null;

			int valueTokenPosition = htmlContent.IndexOf( valueToken, textboxIDPosition );
			int valueStartPosition = valueTokenPosition + valueToken.Length;
			int valueEndPosition = htmlContent.IndexOf( "\"", valueStartPosition );

			string textboxData = htmlContent.Substring( valueStartPosition, valueEndPosition - valueStartPosition );

			return HttpUtility.UrlEncodeUnicode( textboxData );
		}

		private static string ExtractEventValidation( string htmlContent )
		{
			return GetHtmlElementValue( "__EVENTVALIDATION", htmlContent );
		}

		private static string ExtractViewState( string htmlContent )
		{
			return GetHtmlElementValue( "__VIEWSTATE", htmlContent );
		}
	}
}

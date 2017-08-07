namespace LibertyPower.DataAccess.WebAccess.WebScraperManagement
{
	using System.Web;
	using System.Net;
	using System.IO;

	public static class PecoScraper
	{

		// ------------------------------------------------------------------------------------
		public static string GetAccountUsageHtml( string accountNumber, string zipCode )
		{
			CookieContainer cookieContainer = new CookieContainer();

			RequestLoginPage( cookieContainer );
			RequestAccountInformation( cookieContainer, accountNumber, zipCode );
			string usageHtml = RetrieveAccountInformation( cookieContainer );

			return usageHtml;
		}

		// ------------------------------------------------------------------------------------
		private static void RequestLoginPage( CookieContainer cookies )
		{
			string loginFirstResponse = RequestWebPage( PecoConfigurationValues.ValueOf.HomePage, string.Empty, cookies, "GET" );

			string viewState = ExtractViewState( loginFirstResponse );
			string eventValidation = ExtractEventValidation( loginFirstResponse );
			string postData = "ctl00$ContentPlaceHolder1$disclaimer$chkbxAcceptDisclaimer=on&ctl00$ContentPlaceHolder1$disclaimer$btnAccept=Accept&__EVENTTARGET=&__EVENTARGUMENT=&__LASTFOCUS=";
			postData = FormatPostData( postData, viewState, eventValidation );

			string loginSecondResponse = RequestWebPage( PecoConfigurationValues.ValueOf.HomePage, postData, cookies, "POST" );
		}

		// ------------------------------------------------------------------------------------
		private static void RequestAccountInformation( CookieContainer cookies, string account, string zip )
		{
			string accountRequestResponse = RequestWebPage( PecoConfigurationValues.ValueOf.StartPage, string.Empty, cookies, "GET" );

			string viewState = ExtractViewState( accountRequestResponse );
			string eventValidation = ExtractEventValidation( accountRequestResponse );
			string postData = string.Format( "&ctl00$ContentPlaceHolder1$login$AccountNumber={0}&ctl00$ContentPlaceHolder1$login$ServiceZipCode={1}&ctl00$ContentPlaceHolder1$login$LoginButton=Enter&__EVENTTARGET=&__EVENTARGUMENT=", account, zip );
			postData = FormatPostData( postData, viewState, eventValidation );

			string accountRequestSecondResponse = RequestWebPage( PecoConfigurationValues.ValueOf.StartPage, postData, cookies, "POST" );
		}

		// ------------------------------------------------------------------------------------
		private static string RetrieveAccountInformation( CookieContainer cookies )
		{
			string usageResponse = RequestWebPage( PecoConfigurationValues.ValueOf.BillHistoryPage, string.Empty, cookies, "GET" );

			return usageResponse;
		}

		// ------------------------------------------------------------------------------------
		// Generic methods
		// ------------------------------------------------------------------------------------
		private static string ExtractEventValidation( string htmlContent )
		{
			return GetHtmlElementValue( "__EVENTVALIDATION", htmlContent );
		}

		// ------------------------------------------------------------------------------------
		private static string ExtractViewState( string htmlContent )
		{
			return GetHtmlElementValue( "__VIEWSTATE", htmlContent );
		}

		// ------------------------------------------------------------------------------------
		private static string FormatPostData( string postData, string viewStateData, string eventValidationData )
		{
			if( !string.IsNullOrEmpty( viewStateData ) )
				postData += "&__VIEWSTATE=" + viewStateData;
			if( !string.IsNullOrEmpty( eventValidationData ) )
				postData += "&__EVENTVALIDATION=" + eventValidationData;

			return postData;
		}

		// ------------------------------------------------------------------------------------
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

		// ------------------------------------------------------------------------------------
		private static string RequestWebPage( string url, string postData, CookieContainer cookieContainer, string method )
		{
			HttpWebRequest webRequest = (HttpWebRequest) HttpWebRequest.Create( url );

			webRequest.Method = method;
			webRequest.ContentType = "application/x-www-form-urlencoded";
			webRequest.CookieContainer = cookieContainer;
			webRequest.Timeout = 300000;

			if( !string.IsNullOrEmpty( postData ) )
			{
				StreamWriter requestWriter = new StreamWriter( webRequest.GetRequestStream() );

				requestWriter.Write( postData );
				requestWriter.Close();
			}

			StreamReader responseReader = new StreamReader( webRequest.GetResponse().GetResponseStream() );
			string responseData = responseReader.ReadToEnd();

			responseReader.Close();

			return responseData;
		}
	}
}

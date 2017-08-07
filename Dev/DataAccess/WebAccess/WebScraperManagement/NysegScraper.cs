using System.Text;

namespace LibertyPower.DataAccess.WebAccess.WebScraperManagement
{
	using System;
	using System.Collections.Generic;
	using System.Web;
	using System.Net;
	using System.IO;

	public static class NysegScraper
	{

		// ------------------------------------------------------------------------------------
		public static string GetAccountUsageHtml( string accountNumber )
		{
			CookieContainer cookieContainer = new CookieContainer();

			RequestLoginPage( cookieContainer );
			RequestFileListPage( cookieContainer );

			return RequestAccountUsagePage( accountNumber, cookieContainer );
		}

		// ------------------------------------------------------------------------------------
		private static string RequestLoginPage( CookieContainer cookieContainer )
		{
			/*
			 * login page - this is the first request to get values of __VIEWSTATE and __EVENTVALIDATION
			 * */
			string loginFirstResponse = RequestWebPage( NysegConfigurationValues.ValueOf.HomePage, string.Empty, cookieContainer );

			/*
			 * This is the second request for 'postback' __VIEWSTATE, __EVENTVALIDATION and all the
			 * data needed to accomplish the login phase
			 * */
			string viewState = ExtractViewState( loginFirstResponse );
			string eventValidation = ExtractEventValidation( loginFirstResponse );
			string postData = GetLoginPageData( viewState, eventValidation, NysegConfigurationValues.ValueOf.Username, NysegConfigurationValues.ValueOf.Password );

			// secured services for ESCOs webpage
			return RequestWebPage( NysegConfigurationValues.ValueOf.HomePage, postData, cookieContainer );
		}

		// ------------------------------------------------------------------------------------
		private static string RequestFileListPage( CookieContainer cookieContainer )
		{
			return RequestWebPage( NysegConfigurationValues.ValueOf.FileListPage, string.Empty, cookieContainer );
		}

		// ------------------------------------------------------------------------------------
		private static string RequestAccountUsagePage( string accountNumber, CookieContainer cookieContainer )
		{
			// usage page request..
			string responseData = RequestWebPage( NysegConfigurationValues.ValueOf.BillHistoryPage, string.Empty, cookieContainer );

			string viewStateData = ExtractViewState( responseData );
			string eventValidationData = ExtractEventValidation( responseData );
			string postData = GetUsageReportPageData( viewStateData, eventValidationData, accountNumber );

			// response from server with the usage for this account
			return RequestWebPage( NysegConfigurationValues.ValueOf.BillHistoryPage, postData, cookieContainer );
		}

		// ------------------------------------------------------------------------------------
		private static string GetLoginPageData( string viewStateData, string eventValidationData, string username, string password )
		{
			string postData;

			postData = string.Format( NysegConfigurationValues.ValueOf.HomePageData, username, password );
			postData = GetPageData( postData, viewStateData, eventValidationData );

			return postData;
		}

		// ------------------------------------------------------------------------------------
		private static string GetUsageReportPageData( string viewStateData, string eventValidationData, string accountNumber )
		{
			string postData;

			postData = string.Format( NysegConfigurationValues.ValueOf.BillHistoryPageData, accountNumber );
			postData = GetPageData( postData, viewStateData, eventValidationData );

			return postData;
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
		private static string GetPageData( string postData, string viewStateData, string eventValidationData )
		{
			if( !string.IsNullOrEmpty( viewStateData ) )
				postData += "&__VIEWSTATE=" + viewStateData;
			if( !string.IsNullOrEmpty( eventValidationData ) )
				postData += "&__EVENTVALIDATION=" + eventValidationData;

			return postData;
		}

		// ------------------------------------------------------------------------------------
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
				//Encoding.ASCII.GetBytes( postData ).Length;
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
	}
}

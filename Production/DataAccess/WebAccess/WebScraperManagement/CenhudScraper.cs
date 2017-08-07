namespace LibertyPower.DataAccess.WebAccess.WebScraperManagement
{
	using System;
	using System.Net;
	using System.IO;
	using System.Web;

	public static class CenhudScraper
	{
		public static string GetUsageHtml( string accountNumber )
		{
			CookieContainer cookies = new CookieContainer();
			string responseData = RequestStartPage( accountNumber, cookies );
			string viewState = ExtractViewState( responseData );
			string eventValidation = ExtractEventValidation( responseData );

			return RequestStartPage( accountNumber, viewState, eventValidation, cookies );
		}

		private static string RequestStartPage( string accountNumber, CookieContainer cookies )
		{
			HttpWebRequest webRequest = WebRequest.Create( CenhudConfigurationValues.ValueOf.StartPage ) as HttpWebRequest;

			webRequest.Method = "POST";
			webRequest.ContentType = "application/x-www-form-urlencoded";
			webRequest.CookieContainer = cookies;
			webRequest.Timeout = 300000;

			StreamWriter requestWriter = new StreamWriter( webRequest.GetRequestStream() );

			requestWriter.Write( CenhudConfigurationValues.ValueOf.StartPageData1For( accountNumber ) );
			System.Threading.Thread.Sleep( 5000 );
			requestWriter.Close();

			StreamReader responseReader = new StreamReader( webRequest.GetResponse().GetResponseStream() );
			string responseData = responseReader.ReadToEnd();

			responseReader.Close();

			return responseData;
		}

		private static string RequestStartPage( string accountNumber, string viewState, string eventValidation, CookieContainer cookies )
		{
			HttpWebRequest webRequest = WebRequest.Create(
				CenhudConfigurationValues.ValueOf.StartPage ) as HttpWebRequest;

			webRequest.Method = "POST";
			webRequest.ContentType = "application/x-www-form-urlencoded";
			webRequest.CookieContainer = cookies;
			webRequest.KeepAlive = true;

			StreamWriter requestWriter = new StreamWriter( webRequest.GetRequestStream() );

			requestWriter.Write(
				CenhudConfigurationValues.ValueOf
							.StartPageData2For( accountNumber, viewState, eventValidation ) );

			requestWriter.Close();

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

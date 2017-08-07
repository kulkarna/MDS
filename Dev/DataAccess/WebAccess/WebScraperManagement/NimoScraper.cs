namespace LibertyPower.DataAccess.WebAccess.WebScraperManagement
{
	using System;
	using System.IO;
	using System.Linq;
	using System.Net;
	using System.Web;

	public static class NimoScraper
	{

		public static string GetUsageHtmlContent( string accountNumber )
		{
			CookieContainer cookies = new CookieContainer();

			RequestLoginPage( cookies );

			return RequestNimoUsagePage( accountNumber, cookies );
		}

		/// <summary>
		/// Login in to NIMO website, main menu..
		/// </summary>
		/// <param name="cookies"></param>
		/// <returns></returns>
		private static string RequestLoginPage( CookieContainer cookies )
		{
			return RequestWebPage( NimoConfigurationValues.ValueOf.HomePage,
				NimoConfigurationValues.ValueOf.HomePageData, cookies );
		}

		/// <summary>
		/// Usage data displayed/returned..
		/// </summary>
		/// <param name="accountNumber"></param>
		/// <param name="cookies"></param>
		/// <returns></returns>
		private static string RequestNimoUsagePage( string accountNumber, CookieContainer cookies )
		{
			return RequestWebPage( NimoConfigurationValues.ValueOf.BillHistoryPage,
				NimoConfigurationValues.ValueOf.BillHistoryPageDataForAccount( accountNumber ), cookies );
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

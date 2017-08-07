namespace LibertyPower.DataAccess.WebAccess.WebScraperManagement
{
	using System.IO;
	using System.Net;

	public static class CmpScraper
	{

		private static string RequestStartPage( CookieContainer cookies )
		{
			HttpWebRequest webRequest = WebRequest.Create( CmpConfigurationValues.ValueOf.HomePage ) as HttpWebRequest;
			webRequest.Method = "GET";
			webRequest.ContentType = "application/x-www-form-urlencoded";
			webRequest.CookieContainer = cookies;
			webRequest.Timeout = 300000;
			webRequest.KeepAlive = true;
			webRequest.AllowAutoRedirect = true;

			StreamReader responseReader = new StreamReader( webRequest.GetResponse().GetResponseStream() );

			string responseData = responseReader.ReadToEnd();
			responseReader.Close();

			return responseData;
		}

		private static string RequestAuthenticationPage( CookieContainer cookies )
		{
			HttpWebRequest webRequest = WebRequest.Create( CmpConfigurationValues.ValueOf.BillHistoryPage ) as HttpWebRequest;
			webRequest.Method = "POST";
			webRequest.ContentType = "application/x-www-form-urlencoded";
			webRequest.CookieContainer = cookies;
			webRequest.Timeout = 300000;
			webRequest.KeepAlive = true;
			webRequest.AllowAutoRedirect = true;

			StreamWriter requestWriter = new StreamWriter( webRequest.GetRequestStream() );
			requestWriter.Write( CmpConfigurationValues.ValueOf.BillHistoryPageData );
			requestWriter.Close();

			StreamReader responseReader = new StreamReader( webRequest.GetResponse().GetResponseStream() );

			string responseData = responseReader.ReadToEnd();
			responseReader.Close();

			return responseData;
		}

		private static string RequestBillHistoryPage( string accountNumber, CookieContainer cookies )
		{
			HttpWebRequest webRequest = WebRequest.Create( CmpConfigurationValues.ValueOf.BillHistoryPage ) as HttpWebRequest;
			webRequest.Method = "POST";
			webRequest.ContentType = "application/x-www-form-urlencoded";
			webRequest.CookieContainer = cookies;
			webRequest.Timeout = 300000;
			webRequest.KeepAlive = true;
			webRequest.ReadWriteTimeout = 300000;
			webRequest.AllowAutoRedirect = true;

			StreamWriter requestWriter = new StreamWriter( webRequest.GetRequestStream() );
			requestWriter.Write( CmpConfigurationValues.ValueOf.BillHistoryPageDataFor( accountNumber ) );
			requestWriter.Close();

			StreamReader responseReader = new StreamReader( webRequest.GetResponse().GetResponseStream() );

			string responseData = responseReader.ReadToEnd();
			responseReader.Close();

			return responseData;
		}

		public static string GetUsageHtml( string accountNumber )
		{
			CookieContainer cookies = new CookieContainer();

			RequestStartPage( cookies );
			RequestAuthenticationPage( cookies );

			return RequestBillHistoryPage( accountNumber, cookies );
		}
	}
}

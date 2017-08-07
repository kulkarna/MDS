namespace LibertyPower.DataAccess.WebAccess.WebScraperManagement
{
	using System.Linq;
	using System.Net;
	using System.Web;
	using System.IO;
	using System.Xml.Linq;

	using HtmlAgilityPack;

	public static class BgeScraper
	{

		// ------------------------------------------------------------------------------------
		public static string GetUsageHtml( string accountNumber )
		{
			string referenceNbr = string.Empty;
			string responseData = string.Empty;
			CookieContainer cookies = new CookieContainer();

			RequestHomePage( cookies );
			RequestLoginHomePage( cookies );

			responseData = RequestBillHistoryPage( accountNumber, cookies );
			referenceNbr = ExtractReferenceNumber( responseData );

			return RequestUsageDataWebService( referenceNbr, accountNumber, cookies );
		}

		private static string RequestHomePage( CookieContainer cookies )
		{
			HttpWebRequest webRequest = WebRequest.Create( BgeConfigurationValues.ValueOf.HomePage ) as HttpWebRequest;
			webRequest.CookieContainer = cookies;

			StreamReader responseReader = new StreamReader( webRequest.GetResponse().GetResponseStream() );
			string responseData = responseReader.ReadToEnd();

			responseReader.Close();

			return responseData;
		}

		private static string RequestLoginHomePage( CookieContainer cookies )
		{
			HttpWebRequest webRequest = WebRequest.Create( BgeConfigurationValues.ValueOf.HomePage ) as HttpWebRequest;
			webRequest.Method = "POST";
			webRequest.ContentType = "application/x-www-form-urlencoded";
			webRequest.CookieContainer = cookies;
			webRequest.Timeout = 300000;

			StreamWriter requestWriter = new StreamWriter( webRequest.GetRequestStream() );
			requestWriter.Write( BgeConfigurationValues.ValueOf.HomePageData );
			requestWriter.Close();

			StreamReader responseReader = new StreamReader( webRequest.GetResponse().GetResponseStream() );
			string responseData = responseReader.ReadToEnd();

			responseReader.Close();

			return responseData;
		}

		private static string RequestBillHistoryPage( string accountNumber, CookieContainer cookies )
		{
			HttpWebRequest webRequest = WebRequest.Create( BgeConfigurationValues.ValueOf.BillHistoryPage ) as HttpWebRequest;
			webRequest.Method = "POST";
			webRequest.Referer = "https://supplier.bge.com/CDWeb/";
			webRequest.KeepAlive = true;
			webRequest.AllowAutoRedirect = true;
			webRequest.ContentType = "multipart/form-data; boundary=---------------------------7d8a9141e1202";
			webRequest.CookieContainer = cookies;
			webRequest.SendChunked = true;
			webRequest.Timeout = 300000;

			StreamWriter requestWriter = new StreamWriter( webRequest.GetRequestStream() );

			requestWriter.Write( BgeConfigurationValues.ValueOf.BillHistoryPageDataFor( accountNumber ) );
			requestWriter.Close();

			StreamReader responseReader = new StreamReader( webRequest.GetResponse().GetResponseStream() );
			string responseData = responseReader.ReadToEnd();

			responseReader.Close();

			return responseData;
		}

		private static string RequestUsageDataWebService( string referenceNumber, string accountNumber, CookieContainer cookies )
		{
			HttpWebRequest webRequest = WebRequest.Create( BgeConfigurationValues.ValueOf.UsageWebService ) as HttpWebRequest;
			webRequest.Method = "POST";
			webRequest.Referer = "https://supplier.bge.com/CDWeb/Process_Request.aspx";
			webRequest.KeepAlive = true;
			webRequest.AllowAutoRedirect = true;
			webRequest.ContentType = "application/x-www-form-urlencoded; charset=UTF-8";
			webRequest.CookieContainer = cookies;
			webRequest.SendChunked = true;
			webRequest.Timeout = 300000;

			StreamWriter requestWriter = new StreamWriter( webRequest.GetRequestStream() );
			requestWriter.Write( BgeConfigurationValues.ValueOf.WebServiceDataFor( accountNumber, referenceNumber ) );
			requestWriter.Close();

			StreamReader responseReader = new StreamReader( webRequest.GetResponse().GetResponseStream() );
			string responseData = responseReader.ReadToEnd();
			responseReader.Close();

			return responseData;
		}

		private static string ExtractReferenceNumber( string htmlContent )
		{
			HtmlDocument htmlDocument = new HtmlDocument();

			htmlDocument.LoadHtml( htmlContent );

			HtmlNode inputXml = htmlDocument.GetElementbyId( "txtXML" );
			string xml = inputXml.Attributes["value"].Value;
			XElement xmlDoc = XElement.Parse( xml );

			return xmlDoc
						.Descendants( "REFERENCE_NBR" )
						.First()
						.Value;
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
	}
}

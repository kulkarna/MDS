using System;
using System.Net;
using System.IO;
using System.Web;

namespace LibertyPower.DataAccess.WebAccess.WebScraperManagement
{

	public class IDRPecoScraper: IDRScraper
	{

		static IDRPecoScraper instance;

		/// <summary>
		/// Constructor: it run the base class constructor
		/// </summary>
		public IDRPecoScraper():base()
		{
		}

		/// <summary>
		/// Get the instance of the class
		/// </summary>
		/// <returns></returns>
		public static IDRPecoScraper GetInstance()
		{
			if( instance == null )
				instance = new IDRPecoScraper();
			return instance;
		}

		/// <summary>
		/// Get the list from the site
		/// </summary>
		/// <returns>String: which will be the list in a text format</returns>
		public override string GetIDRList( )
		{
			CookieContainer cookies = new CookieContainer();

			//open the page
			IDRPecoConfigurationValues.MapToOject();
			HttpWebRequest webRequest = WebRequest.Create( IDRPecoConfigurationValues.IDRList ) as HttpWebRequest;
			webRequest.Method = "GET";
			webRequest.ContentType = "application/x-www-form-urlencoded";
			webRequest.CookieContainer = cookies;
			webRequest.Timeout = 300000;
			webRequest.KeepAlive = true;
			webRequest.AllowAutoRedirect = true;
			webRequest.Credentials = new NetworkCredential( IDRPecoConfigurationValues.Username, IDRPecoConfigurationValues.Password );

			StreamReader responseReader = new StreamReader( webRequest.GetResponse().GetResponseStream() );

			string responseData = responseReader.ReadToEnd();
			responseReader.Close();
			return responseData;

		}
	}
}

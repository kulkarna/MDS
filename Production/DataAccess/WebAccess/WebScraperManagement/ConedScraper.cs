namespace LibertyPower.DataAccess.WebAccess.WebScraperManagement
{
	using System;
	using System.Data;
	using System.Linq;
	using System.Net;
	using System.IO;
	using LibertyPower.DataAccess.SqlAccess.TransactionsSql;

	public static class ConedScraper
	{

		// ------------------------------------------------------------------------------------
		private static ConedConfigurationValues GetConedConfigurationValues()
		{
			DataSet ds = TransactionsSql.GetConfigurationValues( "CONED" );

			return GetConedConfigurationValues( ds );
		}

		// ------------------------------------------------------------------------------------
		public static string Navigate( string accountNumber )
		{
			ConedConfigurationValues config = GetConedConfigurationValues();

			CookieContainer cookies = new CookieContainer();

			// ------------------------------------------
			// prepares a url request to be send to the server
			HttpWebRequest webRequest = (HttpWebRequest) WebRequest.Create( config.HomePage );
			webRequest.Method = "GET";
			webRequest.ContentType = "application/x-www-form-urlencoded";
			webRequest.CookieContainer = cookies;
			webRequest.Timeout = 300000;
			webRequest.KeepAlive = true;
			webRequest.AllowAutoRedirect = true;

			// the request is actually sent to the server here..
			StreamReader responseReader = new StreamReader( webRequest.GetResponse().GetResponseStream() );

			// the data that is received from remote server is in the form of stream so it needs to be collected in some container (StreamReader)..
			string responseData = responseReader.ReadToEnd();
			responseReader.Close();

			// ------------------------------------------
			webRequest = (HttpWebRequest) WebRequest.Create( config.StartPage );
			webRequest.Method = "POST";
			webRequest.ContentType = "application/x-www-form-urlencoded";
			webRequest.CookieContainer = cookies;
			webRequest.Timeout = 300000;
			webRequest.KeepAlive = true;
			webRequest.AllowAutoRedirect = true;

			StreamWriter requestWriter = new StreamWriter( webRequest.GetRequestStream() );
			// passUID=barrantm&passUCD=MvceX4%21&Enter2.x=50&Enter2.y=7
			requestWriter.Write( "passUID=" + config.Username + "&passUCD=" + config.Password + "&Enter2.x=45&Enter2.y=11" );
			requestWriter.Close();

			responseReader = new StreamReader( webRequest.GetResponse().GetResponseStream() );

			responseData = responseReader.ReadToEnd();
			responseReader.Close();

			// ------------------------------------------
			webRequest = (HttpWebRequest) WebRequest.Create( config.MainPage );
			webRequest.Method = "GET";
			webRequest.CookieContainer = cookies;
			webRequest.Timeout = 300000;
			webRequest.KeepAlive = true;
			webRequest.ReadWriteTimeout = 300000;
			webRequest.AllowAutoRedirect = true;

			responseReader = new StreamReader( webRequest.GetResponse().GetResponseStream() );

			responseData = responseReader.ReadToEnd();
			responseReader.Close();

			// ------------------------------------------
			webRequest = (HttpWebRequest) WebRequest.Create( config.BillHistoryPage + accountNumber );
			webRequest.Method = "GET";
			webRequest.CookieContainer = cookies;
			webRequest.Timeout = 300000;
			webRequest.KeepAlive = true;
			webRequest.ReadWriteTimeout = 300000;
			webRequest.AllowAutoRedirect = true;

			responseReader = new StreamReader( webRequest.GetResponse().GetResponseStream() );

			responseData = responseReader.ReadToEnd();
			responseReader.Close();

			return responseData;
		}

		// ------------------------------------------------------------------------------------
		private static ConedConfigurationValues GetConedConfigurationValues( DataSet ds1 )
		{
			ConedConfigurationValues config = new ConedConfigurationValues();
			string webPage;

			if( ds1 != null && ds1.Tables.Count > 0 && ds1.Tables[0].Rows.Count > 0 )
			{
				foreach( DataRow row in ds1.Tables[0].Rows )
				{
					if( Convert.ToInt16( row["configurationType"] ) == 1 )
						config.Username = (string) row["configurationValue"];
					else if( Convert.ToInt16( row["configurationType"] ) == 2 )
						config.Password = (string) row["configurationValue"];
					else if( Convert.ToInt16( row["configurationType"] ) == 3 )
					{
						switch( (string) row["webPageReference"] )
						{
							case "HomePage":
								config.HomePage = (string) row["configurationValue"];
								break;
							case "StartPage":
								config.StartPage = (string) row["configurationValue"];
								break;
						}
					}
					else
					{
						webPage = String.Format( (string) row["configurationValue"], config.Username );

						switch( (string) row["webPageReference"] )
						{
							case "LeftPage":
								config.LeftPage = webPage;
								break;
							case "MainPage":
								config.MainPage = webPage;
								break;
							case "FrameControlPage":
								config.FrameControlPage = webPage;
								break;
							case "AcctInfoHdrPage":
								config.AccountInfoHeaderPage = webPage;
								break;
							case "AcctInfoMenuPage":
								config.AccounttInfoMenuPage = webPage;
								break;
							case "BillHist2Page":
								config.AlternateBillHistoryPage = webPage;
								break;
							default:
								config.BillHistoryPage = webPage;
								break;
						}
					}
				}
			}

			return config;
		}
	}
}

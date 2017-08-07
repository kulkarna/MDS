namespace LibertyPower.DataAccess.WebAccess.WebScraperManagement
{
	using System;
	using System.Data;
	using System.Linq;
	using System.Collections.Generic;
	using System.Text;

	public class ConfigurationValues
	{
		/// <summary>
		/// Using Linq to get the configuration values from the dataset..
		/// </summary>
		/// <param name="dsCfgValues"></param>
		/// <param name="configurationType"></param>
		/// <param name="webPageReference"></param>
		/// <returns></returns>
		protected static object GetValue( DataSet dsCfgValues, string configurationType, string webPageReference )
		{
			return (from row in dsCfgValues.Tables[0].AsEnumerable()
					where Convert.ToString( row["ConfigurationType"] ) == (configurationType ?? "") &&
						  Convert.ToString( row["WebPageReference"] ) == (webPageReference ?? "")
					select row).Single()["ConfigurationValue"];
		}

		private string username;
		private string password;
		private string homePage;
		private string startPage;
		private string billHistoryPage;

		public string Username
		{
			get { return username; }
			set { username = value; }
		}

		public string Password
		{
			get { return password; }
			set { password = value; }
		}

		/// <summary>
		/// Coned's login webpage
		/// </summary>
		public string HomePage
		{
			get { return homePage; }
			set { homePage = value; }
		}

		/// <summary>
		/// Coned's starting webpage
		/// </summary>
		public string StartPage
		{
			get { return startPage; }
			set { startPage = value; }
		}

		public string BillHistoryPage
		{
			get { return billHistoryPage; }
			set { billHistoryPage = value; }
		}
		
	}
}

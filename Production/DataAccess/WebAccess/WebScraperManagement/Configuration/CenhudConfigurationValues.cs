namespace LibertyPower.DataAccess.WebAccess.WebScraperManagement
{
	using System;
	using System.Linq;
	using System.Data;

	using LibertyPower.DataAccess.SqlAccess.TransactionsSql;

	public class CenhudConfigurationValues : ConfigurationValues
	{
		private static CenhudConfigurationValues instance;

		private string startPageData1;
		private string startPageData2;

		public string StartPageData1For( string accountNumber )
		{
			return startPageData1
						.Replace( "#AccountNumber#", accountNumber );
		}

		public string StartPageData2For( string accountNumber, string viewState, string eventValidation )
		{
			return startPageData2
						.Replace( "#AccountNumber#", accountNumber )
						.Replace( "#ViewState#", viewState )
						.Replace( "#EventValidation#", eventValidation );
		}

		private CenhudConfigurationValues()
		{
		}

		static CenhudConfigurationValues()
		{
			instance = MapToObject( TransactionsSql.GetConfigurationValues( "CENHUD" ) );
		}

		private static CenhudConfigurationValues MapToObject( DataSet cenhudDS )
		{
			CenhudConfigurationValues cenhudValues = new CenhudConfigurationValues()
			{
				StartPage      = GetValue( cenhudDS, "3", "HomePage" ) as string,
				startPageData1 = GetValue( cenhudDS, "4", "HomePageData1" ) as string,
				startPageData2 = GetValue( cenhudDS, "4", "HomePageData2" ) as string
			};

			return cenhudValues;
		}

		public static CenhudConfigurationValues ValueOf
		{
			get { return instance; }
		}
	}
}

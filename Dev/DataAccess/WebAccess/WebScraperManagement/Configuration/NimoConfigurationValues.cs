namespace LibertyPower.DataAccess.WebAccess.WebScraperManagement
{
	using System;
	using LibertyPower.DataAccess.SqlAccess.TransactionsSql;
	using System.Linq;
	using System.Data;

	public class NimoConfigurationValues : ConfigurationValues
	{
		private static NimoConfigurationValues instance;

		/// <summary>
		/// Default Constructor..
		/// </summary>
		private NimoConfigurationValues() { }

		private string homePageData;
		private string billHistoryPageData;

		public string HomePageData
		{
			get
			{
				return homePageData
					.Replace( "#Username#", Username )
					.Replace( "#Password#", Password );
			}
		}

		public string BillHistoryPageDataForAccount( string accountNumber )
		{
			return billHistoryPageData.Replace( "#AccountNumber#", accountNumber );
		}

		static NimoConfigurationValues()
		{
			DataSet nimoValues;

			nimoValues = TransactionsSql.GetConfigurationValues( "NIMO" );
			instance = MapToOject( nimoValues );
		}

		// ------------------------------------------------------------------------------------
		private static NimoConfigurationValues MapToOject( DataSet dsCfgValues )
		{
			NimoConfigurationValues nimoConfiguration = new NimoConfigurationValues();

			nimoConfiguration.Username = GetValue( dsCfgValues, "1", null ) as string;
			nimoConfiguration.Password = GetValue( dsCfgValues, "2", null ) as string;
			nimoConfiguration.HomePage = GetValue( dsCfgValues, "3", "HomePage" ) as string;
			nimoConfiguration.homePageData = GetValue( dsCfgValues, "4", "HomePageData" ) as string;
			nimoConfiguration.BillHistoryPage = GetValue( dsCfgValues, "3", "BillHistoryPage" ) as string;
			nimoConfiguration.billHistoryPageData = GetValue( dsCfgValues, "4", "BillHistoryPageData" ) as string;

			return nimoConfiguration;
		}

		// ------------------------------------------------------------------------------------
		public static NimoConfigurationValues ValueOf
		{
			get { return instance; }
		}
	}
}

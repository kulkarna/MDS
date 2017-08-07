namespace LibertyPower.DataAccess.WebAccess.WebScraperManagement
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Data;
	using LibertyPower.DataAccess.SqlAccess.TransactionsSql;

	public class NysegConfigurationValues : ConfigurationValues
	{

		// ------------------------------------------------------------------------------------
		//private NysegConfigurationValues() { }

		private string homePageData;
		private string fileListPage;
		private string billHistoryPageData;

		private static NysegConfigurationValues instance;

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Default Constructor..
		/// </summary>
		static NysegConfigurationValues()
		{
			DataSet NysegValues;

			NysegValues = GetNysegConfigurationValues();
			instance = MapToOject( NysegValues );
		}

		// ------------------------------------------------------------------------------------
		public static NysegConfigurationValues ValueOf
		{
			get { return instance; }
		}

		// ------------------------------------------------------------------------------------
		private static DataSet GetNysegConfigurationValues()
		{
			return TransactionsSql.GetConfigurationValues( "Nyseg" );
		}

		// ------------------------------------------------------------------------------------
		private static NysegConfigurationValues MapToOject( DataSet dsCfgValues )
		{
			NysegConfigurationValues NysegConfiguration = new NysegConfigurationValues();

            NysegConfiguration.Username            = GetValue(dsCfgValues, "1",                  null) as string;
            NysegConfiguration.Password            = GetValue(dsCfgValues, "2",                  null) as string;
            NysegConfiguration.HomePage            = GetValue(dsCfgValues, "3",            "HomePage") as string;
            NysegConfiguration.homePageData        = GetValue(dsCfgValues, "4",        "HomePageData") as string;
            NysegConfiguration.fileListPage        = GetValue(dsCfgValues, "3",        "FileListPage") as string;
            NysegConfiguration.BillHistoryPage     = GetValue(dsCfgValues, "3",    "UsageRequestPage") as string;
            NysegConfiguration.billHistoryPageData = GetValue(dsCfgValues, "4",    "UsageHistoryPage") as string;

			return NysegConfiguration;
		}

		// ------------------------------------------------------------------------------------
		// Properties
		// ------------------------------------------------------------------------------------
		public string HomePageData
		{
			get { return homePageData; }
		}

		public string FileListPage
		{
			get { return fileListPage; }
		}

		public string BillHistoryPageData
		{
			get { return billHistoryPageData; }
		}

	}
}

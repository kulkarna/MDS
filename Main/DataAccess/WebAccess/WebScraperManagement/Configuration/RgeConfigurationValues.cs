namespace LibertyPower.DataAccess.WebAccess.WebScraperManagement
{
	using System;
	using System.Linq;
	using System.Data;
	using System.Web;
	using System.Net;
	using System.IO;
	using System.Collections.Generic;

	using LibertyPower.DataAccess.SqlAccess.TransactionsSql;

	public class RgeConfigurationValues : ConfigurationValues
	{
		private static RgeConfigurationValues instance;

		static RgeConfigurationValues()
		{
			instance = MapToOject( TransactionsSql.GetConfigurationValues( "RGE" ) );
		}

		public static RgeConfigurationValues ValueOf
		{
			get { return instance; }
		}

		private static RgeConfigurationValues MapToOject( DataSet dsCfgValues )
		{
			RgeConfigurationValues rgeConfiguration = new RgeConfigurationValues();

			rgeConfiguration.Username = GetValue( dsCfgValues, "1", null ) as string;
			rgeConfiguration.Password = GetValue( dsCfgValues, "2", null ) as string;
			rgeConfiguration.HomePage = GetValue( dsCfgValues, "3", "HomePage" ) as string;
			rgeConfiguration.homePageData = GetValue( dsCfgValues, "4", "HomePageData" ) as string;
			rgeConfiguration.fileListPage = GetValue( dsCfgValues, "3", "FileListPage" ) as string;
			rgeConfiguration.BillHistoryPage = GetValue( dsCfgValues, "3", "BillHistoryPage" ) as string;
			rgeConfiguration.billHistoryPageData = GetValue( dsCfgValues, "4", "BillHistoryPageData" ) as string;

			return rgeConfiguration;
		}

		private RgeConfigurationValues()
		{ }

		private string homePageData;
		private string fileListPage;
		private string billHistoryPageData;

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

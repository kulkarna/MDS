namespace LibertyPower.DataAccess.WebAccess.WebScraperManagement
{
	using System;
	using System.Linq;
	using System.Data;

	using LibertyPower.DataAccess.SqlAccess.TransactionsSql;

	public class ComedConfigurationValues : ConfigurationValues
	{
		private ComedConfigurationValues()
		{ }

		private string homePageData1;
		private string homePageData2;
		private string homePageData3;
		private string validationPage;

		public string ValidationPage
		{
			get { return validationPage;  }
		}

		public string ValidationPageDataFor( string homePageResponseData )
		{ 
			string stringToFind = "CustomerChoice_usagedataChart.aspx?";
			int    BeginPos     = homePageResponseData.IndexOf( stringToFind, 1, StringComparison.OrdinalIgnoreCase ) + 35;
			int    EndPos       = homePageResponseData.IndexOf( "'", BeginPos, StringComparison.OrdinalIgnoreCase );
			int    DataLength   = EndPos - BeginPos;

			string ComedQueryStringData = homePageResponseData.Substring( BeginPos, DataLength ).Trim();

			return ComedQueryStringData;
		}

		public string HomePageData1For( string accountNumber, string meterNumber )
		{
			return homePageData1
						.Replace( "#ACCOUNTNUMBER#", accountNumber )
						.Replace( "#METERNUMBER#", meterNumber );
		}

		public string HomePageData2For( string viewState, string requestDigest, string eventValidation, string eventTarget )
		{
			return homePageData2
						.Replace( "#EVENTVALIDATION#", eventValidation )
						.Replace( "#REQUESTDIGEST#", requestDigest )
						.Replace( "#VIEWSTATE#", viewState )
						.Replace( "#EVENTTARGET#", eventTarget );
		}

		public string HomePageData3For( string viewState, string requestDigest, string eventValidation, string eventTarget, string accountNumber )
		{
			string home3 = homePageData3
						.Replace( "#ACCOUNTNUMBER#", accountNumber )
						.Replace( "#EVENTVALIDATION#", eventValidation )
						.Replace( "#REQUESTDIGEST#", requestDigest )
						.Replace( "#VIEWSTATE#", viewState )
						.Replace( "#EVENTTARGET#", eventTarget );
			return home3;
		}

		private static ComedConfigurationValues instance;

		static ComedConfigurationValues()
		{
			DataSet comedValues;

			comedValues = TransactionsSql.GetConfigurationValues( "COMED" );
			instance    = MapToOject( comedValues );
		}

		private static ComedConfigurationValues MapToOject( DataSet dsCfgValues )
		{
			ComedConfigurationValues comedConfiguration = new ComedConfigurationValues()
			{
				HomePage        = GetValue( dsCfgValues, "3", "HomePage" ) as string,
				homePageData1   = GetValue( dsCfgValues, "4", "HomePageData1" ) as string,
				homePageData2   = GetValue( dsCfgValues, "4", "HomePageData2" ) as string,
				homePageData3   = GetValue( dsCfgValues, "4", "HomePageData3" ) as string,
				BillHistoryPage = GetValue( dsCfgValues, "3", "BillHistoryPage" ) as string,
				validationPage  = GetValue( dsCfgValues, "3", "ValidationPage" ) as string

			};

			return comedConfiguration;
		}

		public static ComedConfigurationValues ValueOf
		{
			get { return instance; }
		}
	}
}

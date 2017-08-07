namespace LibertyPower.DataAccess.WebAccess.WebScraperManagement
{
	using System.Data;

	using LibertyPower.DataAccess.SqlAccess.TransactionsSql;

	public class AmerenConfigurationValues : ConfigurationValues
	{
		private static AmerenConfigurationValues instance;

		static AmerenConfigurationValues()
		{
			instance = MapToObject( TransactionsSql.GetConfigurationValues( "AMEREN" ) );
		}

		public static AmerenConfigurationValues ValueOf
		{
			get { return instance; }
		}

		private static AmerenConfigurationValues MapToObject( DataSet amerenValues )
		{
			AmerenConfigurationValues values = new AmerenConfigurationValues()
			{
				Username = GetValue( amerenValues, "1", null ) as string,
				Password = GetValue( amerenValues, "2", null ) as string,
				HomePage = GetValue( amerenValues, "3", "HomePage" ) as string,
				loginPage = GetValue( amerenValues, "3", "LoginPage" ) as string,
				loginPageData = GetValue( amerenValues, "4", "LoginPageData" ) as string,
				summaryPage = GetValue( amerenValues, "3", "SummaryPage" ) as string,
				summaryPageData1 = GetValue( amerenValues, "4", "SummaryPageData1" ) as string,
				summaryPageData2 = GetValue( amerenValues, "4", "SummaryPageData2" ) as string,
				BillHistoryPage = GetValue( amerenValues, "3", "BillHistoryPage" ) as string,
				billHistoryPageData = GetValue( amerenValues, "4", "BillHistoryPageData" ) as string
			};

			return values;
		}

		private string loginPage;
		private string loginPageData;
		private string summaryPage;
		private string summaryPageData1;
		private string summaryPageData2;
		private string billHistoryPageData;

		public string BillHistoryPageDataFor( string accountNumber )
		{
			return billHistoryPageData
						.Replace( "#AccountNumber#", accountNumber );
		}

		public string LoginPage
		{
			get { return loginPage; }
		}

		public string LoginPageData
		{
			get
			{
				return loginPageData
							.Replace( "#UserName#", Username )
							.Replace( "#Password#", Password );
			}
		}

		public string SummaryPage
		{
			get { return summaryPage; }
		}

		public string SummaryPageDataFor( string accountNumber )
		{
			return summaryPageData1
						.Replace( "#AccountNumber#", accountNumber );
		}

		public string SummaryPageDataFor( string accountNumber, string viewState, string eventValidation )
		{
			return summaryPageData2
						.Replace( "#AccountNumber#", accountNumber )
						.Replace( "#ViewState#", viewState )
						.Replace( "#EventValidation#", eventValidation );
		}

		private AmerenConfigurationValues()
		{
		}
	}
}

namespace LibertyPower.DataAccess.WebAccess.WebScraperManagement
{
	using System;
	using System.Linq;
	using System.Data;

	using LibertyPower.DataAccess.SqlAccess.TransactionsSql;

	public class CmpConfigurationValues : ConfigurationValues
	{
		private static CmpConfigurationValues instance;

		static CmpConfigurationValues()
		{
			DataSet cmpValues = TransactionsSql.GetConfigurationValues( "CMP" );

			instance = MapToOject( cmpValues );
		}

		private static CmpConfigurationValues MapToOject( DataSet dsCfgValues )
		{
			CmpConfigurationValues cmpConfiguration = new CmpConfigurationValues();

			cmpConfiguration.Username             = GetValue( dsCfgValues, "1", null ) as string;
			cmpConfiguration.Password             = GetValue( dsCfgValues, "2", null ) as string;
			cmpConfiguration.HomePage             = GetValue( dsCfgValues, "3", "HomePage" ) as string;
			cmpConfiguration.BillHistoryPage      = GetValue( dsCfgValues, "3", "BillHistoryPage" ) as string;
			cmpConfiguration.billHistoryPageData1 = GetValue( dsCfgValues, "4", "BillHistoryPageData1" ) as string;
			cmpConfiguration.billHistoryPageData2 = GetValue( dsCfgValues, "4", "BillHistoryPageData2" ) as string;

			return cmpConfiguration;
		}

		public static CmpConfigurationValues ValueOf
		{
			get { return instance; }
		}

		private string billHistoryPageData1;
		private string billHistoryPageData2;

		private CmpConfigurationValues()
		{ }

		public string BillHistoryPageData
		{
			// "username=#UserName#&password=#Password#&verifyMe=Verify+me";
			get
			{
				return billHistoryPageData1
							.Replace( "#UserName#", Username )
							.Replace( "#Password#", Password );
			}
		}

		public string BillHistoryPageDataFor( string accountNumber )
		{
			// "custName=LPC&companyName=LPC&areaCode=&phoneNumber1=&phoneNumber2=&accountsFile=&inputType=userEntered&acctID1=#AccountNumber#&acctID2=&acctID3=&acctID4=&acctID5=&acctID6=&acctID7=&acctID8=&acctID9=&acctID10=&acctID11=&acctID12=&acctID13=&acctID14=&acctID15=&acctID16=&acctID17=&acctID18=&acctID19=&acctID20=&acctID21=&acctID22=&acctID23=&acctID24=&acctID25=&numberMonths=13&mimeType=htmlSummary&submitForm=Submit";
			return billHistoryPageData2
						.Replace( "#AccountNumber#", accountNumber );
		}
	}
}

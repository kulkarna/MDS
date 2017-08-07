namespace LibertyPower.DataAccess.WebAccess.WebScraperManagement
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;
	using System.Data;
	using LibertyPower.DataAccess.SqlAccess.TransactionsSql;

	public class BgeConfigurationValues : ConfigurationValues
	{
		private static BgeConfigurationValues instance;

		static BgeConfigurationValues()
		{
			DataSet bgeDs = TransactionsSql.GetConfigurationValues( "BGE" );

			instance = MapToObject( bgeDs );

			// HARDCODED CONFIGURATION
			// -----------------------
			//instance = new BgeConfigurationValues();
			//instance.Username = "W01027";
			//instance.Password = "key2turn";
			//instance.HomePage = "https://supplier.bge.com/smforms/login.fcc?TYPE=33554433&REALMOID=06-caacd612-22c8-4622-8585-bd8362028c61&GUID=&SMAUTHREASON=0&TARGET=$SM$https%3a%2f%2fsupplier%2ebge%2ecom%2fCDWeb%2f";
			//instance.homePageData = "username=#UserName#&password=#Password#&target=https://supplier.bge.com/CDWeb/&smauthreason=0";
			//instance.BillHistoryPage = "https://supplier.bge.com/CDWeb/Process_Request.aspx";
			//instance.billHistoryPageData = "-----------------------------7d8a9141e1202\r\nContent-Disposition: form-data; name=\"checkbox1\"\r\n\r\nhasAuthority\r\n-----------------------------7d8a9141e1202\r\nContent-Disposition: form-data; name=\"rdAction\"\r\n\r\nRequestDisplay\r\n-----------------------------7d8a9141e1202\r\nContent-Disposition: form-data; name=\"txtFileName\"; filename=\"\"\r\nContent-Type: application/octet-stream\r\n\r\n-----------------------------7d8a9141e1202\r\nContent-Disposition: form-data; name=\"txtSupplierID\"\r\n\r\n#UserName#\r\n-----------------------------7d8a9141e1202\r\nContent-Disposition: form-data; name=\"txtAppName\"\r\n\r\nCDWEB\r\n-----------------------------7d8a9141e1202\r\nContent-Disposition: form-data; name=\"txtRequestType\"\r\n\r\nRequestDisplay\r\n-----------------------------7d8a9141e1202\r\nContent-Disposition: form-data; name=\"txtOutputType\"\r\n\r\nDisplay\r\n-----------------------------7d8a9141e1202\r\nContent-Disposition: form-data; name=\"txtEmailString\"\r\n\r\n-----------------------------7d8a9141e1202\r\nContent-Disposition: form-data; name=\"txtXML\"\r\n\r\n<ConsumptionDataRequest><AppName>CDWEB</AppName><Request_Type>GetConsumData</Request_Type><Supplier_Id>#UserName#</Supplier_Id><Request_DateTime>#Date#</Request_DateTime><RequestData><HistoricalAccounts><HistoricalData><AccountNumber>#AccountNumber#</AccountNumber><ConsumptionType>HE</ConsumptionType></HistoricalData></HistoricalAccounts></RequestData></ConsumptionDataRequest>\r\n\r\n-----------------------------7d8a9141e1202--\r\n";
			//instance.billHistoryPageData = "-----------------------------7d8a9141e1202#NewLine#Content-Disposition: form-data; name=\"checkbox1\"#NewLine##NewLine#hasAuthority#NewLine#-----------------------------7d8a9141e1202#NewLine#Content-Disposition: form-data; name=\"rdAction\"#NewLine##NewLine#RequestDisplay#NewLine#-----------------------------7d8a9141e1202#NewLine#Content-Disposition: form-data; name=\"txtFileName\"; filename=\"\"#NewLine#Content-Type: application/octet-stream#NewLine##NewLine#-----------------------------7d8a9141e1202#NewLine#Content-Disposition: form-data; name=\"txtSupplierID\"#NewLine##NewLine##UserName##NewLine#-----------------------------7d8a9141e1202#NewLine#Content-Disposition: form-data; name=\"txtAppName\"#NewLine##NewLine#CDWEB#NewLine#-----------------------------7d8a9141e1202#NewLine#Content-Disposition: form-data; name=\"txtRequestType\"#NewLine##NewLine#RequestDisplay#NewLine#-----------------------------7d8a9141e1202#NewLine#Content-Disposition: form-data; name=\"txtOutputType\"#NewLine##NewLine#Display#NewLine#-----------------------------7d8a9141e1202#NewLine#Content-Disposition: form-data; name=\"txtEmailString\"#NewLine##NewLine#-----------------------------7d8a9141e1202#NewLine#Content-Disposition: form-data; name=\"txtXML\"#NewLine##NewLine#<ConsumptionDataRequest><AppName>CDWEB</AppName><Request_Type>GetConsumData</Request_Type><Supplier_Id>#UserName#</Supplier_Id><Request_DateTime>#Date#</Request_DateTime><RequestData><HistoricalAccounts><HistoricalData><AccountNumber>#AccountNumber#</AccountNumber><ConsumptionType>HE</ConsumptionType></HistoricalData></HistoricalAccounts></RequestData></ConsumptionDataRequest>#NewLine##NewLine#-----------------------------7d8a9141e1202--#NewLine#";
			//instance.UsageWebService = "https://supplier.bge.com/cdweb/CDWebService.asmx/SubmitDisplayRequest";
			//instance.webserviceData = "inputXml=<?xml version=\"1.0\" encoding=\"Windows-1252\"?><ConsumptionDataRequest xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"><REFERENCE_CONTROL_AREA><CD_RQST_CD>CreateSupplierReq</CD_RQST_CD><REFERENCE_NBR>#ReferenceNumber#</REFERENCE_NBR></REFERENCE_CONTROL_AREA><AppName>CDWEB</AppName><Request_Type>GetConsumData</Request_Type><Supplier_Id>#UserName#</Supplier_Id><Request_DateTime>#Date#</Request_DateTime><RequestData><HistoricalAccounts><HistoricalData><AccountNumber>#AccountNumber#</AccountNumber><ConsumptionType>HE</ConsumptionType></HistoricalData></HistoricalAccounts></RequestData></ConsumptionDataRequest>";
		}

		private static BgeConfigurationValues MapToObject( DataSet dsCfgValues )
		{
			BgeConfigurationValues cmpConfiguration = new BgeConfigurationValues();

			cmpConfiguration.Username            = GetValue( dsCfgValues, "1", null ) as string;
			cmpConfiguration.Password            = GetValue( dsCfgValues, "2", null ) as string;
			cmpConfiguration.HomePage            = GetValue( dsCfgValues, "3", "HomePage" ) as string;
			cmpConfiguration.homePageData        = GetValue( dsCfgValues, "4", "HomePageData" ) as string;
			cmpConfiguration.BillHistoryPage     = GetValue( dsCfgValues, "3", "BillHistoryPage" ) as string;
			cmpConfiguration.billHistoryPageData = GetValue( dsCfgValues, "4", "BillHistoryPageData" ) as string;
			cmpConfiguration.UsageWebService     = GetValue( dsCfgValues, "3", "UsageWebService" ) as string;
			cmpConfiguration.webserviceData      = GetValue( dsCfgValues, "4", "UsageWebServiceData" ) as string;

			return cmpConfiguration;
		}

		public static BgeConfigurationValues ValueOf
		{
			get { return instance; }
		}

		private string homePageData;
		private string billHistoryPageData;
		private string webserviceData;

		public string HomePageData
		{
			get
			{
				return homePageData
							.Replace( "#UserName#", Username )
							.Replace( "#Password#", Password );
			}
		}

		public string BillHistoryPageDataFor( string accountNumber )
		{
			return billHistoryPageData
						.Replace( "#UserName#", Username )
						.Replace( "#Date#", DateTime.Now.ToString( "yyyy-MM-dd HH:mm" ) )
						.Replace( "#AccountNumber#", accountNumber )
						.Replace( "#NewLine#", "\r\n" );
		}

		public string UsageWebService
		{
			get;
			set;
		}

		public string WebServiceDataFor( string accountNumber, string referenceNumber )
		{
			return webserviceData
						.Replace( "#UserName#", Username )
						.Replace( "#Date#", DateTime.Now.ToString( "yyyy-MM-dd HH:mm" ) )
						.Replace( "#AccountNumber#", accountNumber )
						.Replace( "#ReferenceNumber#", referenceNumber );
		}
	}
}

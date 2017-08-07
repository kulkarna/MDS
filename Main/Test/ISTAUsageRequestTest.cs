using DATA;
using Microsoft.VisualStudio.TestTools.UnitTesting;

using System;
using System.Data;
using System.Data.SqlClient;
using System.Collections;
using System.Collections.Generic;
using System.Web.Services.Protocols;

using EnrollmentBusiness;
using VOHBMSQLSERVER;
using VOHBMSQLSERVERHistoricalData;
using LibertyPower.Business.CommonBusiness.CommonHelper;

namespace FrameworkTest
{
	/// <summary>
	///This is a test class for HistoricalDataHDAOTest and is intended
	///to contain all HistoricalDataHDAOTest Unit Tests
	///</summary>
	[TestClass()]
	public class ISTAUsageRequestTest
	{

		private TestContext testContextInstance;
		private string offerEngineConnStr = "Data Source=sqlprod;Initial Catalog=OfferEngineDB;user id=sa;password=Sp@c3ch@1r";
		private string enrollmentConnStr = "Data Source=sqlprod;Initial Catalog=lp_enrollment;user id=sa;password=Sp@c3ch@1r";
		private string workspaceConnStr = "Data Source=sqlprod;Initial Catalog=Workspace;user id=sa;password=Sp@c3ch@1r";

		/// <summary>
		///Gets or sets the test context which provides
		///information about and functionality for the current test run.
		///</summary>
		public TestContext TestContext
		{
			get
			{
				return testContextInstance;
			}
			set
			{
				testContextInstance = value;
			}
		}

		#region Additional test attributes
		// 
		//You can use the following additional attributes as you write your tests:
		//
		//Use ClassInitialize to run code before running the first test in the class
		//[ClassInitialize()]
		//public static void MyClassInitialize(TestContext testContext)
		//{
		//}
		//
		//Use ClassCleanup to run code after all tests in a class have run
		//[ClassCleanup()]
		//public static void MyClassCleanup()
		//{
		//}
		//
		//Use TestInitialize to run code before running each test
		//[TestInitialize()]
		//public void MyTestInitialize()
		//{
		//}
		//
		//Use TestCleanup to run code after each test has run
		//[TestCleanup()]
		//public void MyTestCleanup()
		//{
		//}
		//
		#endregion


		/// <summary>
		///A test for SendISTAUsageRequest
		///</summary>
		[TestMethod()]
		public void SendISTAUsageRequestTest()
		{
			DataSet dsPricingRequests = GetPricingRequests();
			if( DataSetHelper.HasRow( dsPricingRequests ) )
			{
				foreach( DataRow PricingRequests in dsPricingRequests.Tables[0].Rows )
				{
					string pricingRequestId = PricingRequests["PricingRequestID"].ToString();
					string customerName = PricingRequests["CustomerName"].ToString();

					DataSet dsAccounts = GetPricingRequestAccounts( pricingRequestId );
					if( DataSetHelper.HasRow( dsAccounts ) )
					{
						foreach( DataRow drAccounts in dsAccounts.Tables[0].Rows )
						{
							string accountNumber = drAccounts["ACCOUNT_NUMBER"].ToString();
							string billingAccountNumber = drAccounts["BillingAccountNumber"].ToString();
							string marketCode = drAccounts["MARKET"].ToString();
							string utilityCode = drAccounts["UTILITY"].ToString();
							string zip = drAccounts["ZIP"].ToString();
							string nameKey = drAccounts["NAME_KEY"].ToString();
							string meterType = drAccounts["METER_TYPE"].ToString();
							string entityDuns = String.Empty;
							string utilityDuns = GetDuns( utilityCode, ref entityDuns );

							// do not process these markets
							if( marketCode.ToLower().Trim() != "tx" && marketCode.ToLower().Trim() != "oh" && marketCode.ToLower().Trim() != "ca" && marketCode.ToLower().Trim() != "ny" )
							{
								ProspectDealVO prospectDealVO = GetProspectDealVO( accountNumber, billingAccountNumber,
									utilityCode, zip, nameKey, meterType, entityDuns, utilityDuns, customerName );

								if( prospectDealVO != null )
								{
									SendISTAUsageRequest( pricingRequestId, prospectDealVO );
								}
							}
						}
					}
					SetPricingRequestComplete( pricingRequestId );
				}
			}
		}

		private ProspectDealVO GetProspectDealVO( string accountNumber, string billingAccountNumber, string utilityCode,
			string zip, string nameKey, string meterType, string entityDuns, string utilityDuns, string customerName )
		{
			ProspectDealVO p = new ProspectDealVO();
			p.AccountNumber = accountNumber;
			p.BillingAccount = billingAccountNumber;
			p.Utility = utilityCode;
			p.AcctZip = zip;
			p.NameKey = nameKey;
			p.MeterType = meterType;
			p.EntityDUNS = entityDuns;
			p.DUNS = utilityDuns;
			p.AcctName = customerName;
			return p;
		}

		private void SendISTAUsageRequest( string pricingRequestId, ProspectDealVO prospectDealVO )
		{
			int nameKeyLength = 0;
			string result = String.Empty;
			string spaces = "              ";
			string customerName = String.Empty;
			string appName = "OfferEngine";
			string accountNumber = prospectDealVO.AccountNumber;

			try
			{
				// concatenate name key and customer name separated by a hyphen
				if( prospectDealVO.NameKey.Trim().Length > 0 )
				{
					var @params = new ArrayList();
					@params.Add( new SqlParameter( "@p_utility_id", prospectDealVO.Utility.Trim() ) );

					try
					{
						nameKeyLength =
							Convert.ToInt32(
								DAO.GetInstance(
									enrollmentConnStr )
									.ExecuteStoredProcedure( "usp_name_key_required_length_by_utility_sel", @params,
															DAO.SPDatabase.OfferEngineDB ).Tables[0].Rows[0][
																"required_length"] );
					}
					catch( Exception ex )
					{
						nameKeyLength = 0;
					}

					customerName = ((prospectDealVO.NameKey + spaces)).Substring( 0, nameKeyLength ) + "-" +
								   prospectDealVO.AcctName;
				}
				else
				{
					customerName = prospectDealVO.AcctName;
				}

				try
				{
					BillingServices.SubmitHistoricalUsageRequestPreEnrollment( accountNumber, "11", "11",
																			  "11", "11", prospectDealVO.AcctZip ?? "11111", "11",
																			  "11", "9999999999", customerName, "11",
																			  "11", prospectDealVO.EntityDUNS,
																			  prospectDealVO.DUNS, "11", "11", "11",
																			  "11", prospectDealVO.AcctZip ?? "11111",
																			  prospectDealVO.NameKey, "",
																			  prospectDealVO.BillingAccount, "",
																			  prospectDealVO.MeterType,
																			  prospectDealVO.Utility, appName );
					result = "Usage request successfully sent.";
				}
				catch( SoapException ex )
				{
					result = "Error: " + ex.Detail.InnerText;
				}
				catch( Exception ex )
				{
					result = "Error: " + ex.Message;
				}
			}
			catch( Exception ex )
			{
				result = "Error: " + ex.Message;
			}

			InsertResult( pricingRequestId, accountNumber, result, DateTime.Now );
		}

		public DataSet GetPricingRequests()
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( workspaceConnStr ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_zzzIcapUpdatesSelect";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public void InsertResult( string pricingRequestId, string accountNumber, string result, DateTime dateCreated )
		{
			using( SqlConnection cn = new SqlConnection( workspaceConnStr ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_zzzIcapUpdateResultsInsert";

					cmd.Parameters.Add( new SqlParameter( "@PricingRequestID", pricingRequestId ) );
					cmd.Parameters.Add( new SqlParameter( "@AccountNumber", accountNumber ) );
					cmd.Parameters.Add( new SqlParameter( "@Result", result ) );
					cmd.Parameters.Add( new SqlParameter( "@DateCreated", dateCreated ) );

					cn.Open();
					cmd.ExecuteNonQuery();
				}
			}
		}

		public void SetPricingRequestComplete( string pricingRequestId )
		{
			using( SqlConnection cn = new SqlConnection( workspaceConnStr ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_zzzIcapUpdatesSetComplete";

					cmd.Parameters.Add( new SqlParameter( "@PricingRequestId", pricingRequestId ) );

					cn.Open();
					cmd.ExecuteNonQuery();
				}
			}
		}

		public DataSet GetPricingRequestAccounts( string pricingRequestId )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( offerEngineConnStr ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_accounts_by_pricing_request_id_sel";

					cmd.Parameters.Add( new SqlParameter( "@p_pricing_request_id", pricingRequestId ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public string GetDuns( string utilityCode, ref string entityDuns )
		{
			string dunsNumber = String.Empty;
			entityDuns = String.Empty;
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( offerEngineConnStr ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_utility_duns_sel";

					cmd.Parameters.Add( new SqlParameter( "@p_utility_id", utilityCode ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			if( DataSetHelper.HasRow( ds ) )
			{
				dunsNumber = ds.Tables[0].Rows[0][0].ToString();
				entityDuns = ds.Tables[0].Rows[0][1].ToString();
			}
			return dunsNumber;
		}
	}
}

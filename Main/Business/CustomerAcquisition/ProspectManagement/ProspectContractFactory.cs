using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Data;
using System.IO;
using System.Drawing;
using LibertyPower.Business.CommonBusiness.SecurityManager;
using DAL = LibertyPower.DataAccess.SqlAccess.ProspectManagementSqlDal;
using LibertyPower.Business.CustomerAcquisition.Prospects;
using LibertyPower.Business.CommonBusiness.CommonHelper;
using System.Runtime.InteropServices;
using LibertyPower.Business.CustomerAcquisition.ProductManagement;
using LibertyPower.Business.CommonBusiness.CommonShared;
using Infragistics.Excel;
using LibertyPower.Business.CommonBusiness.CommonEntity;
using LibertyPower.Business.CommonBusiness.CommonEncryption;
using LibertyPower.DataAccess.SqlAccess.ProspectManagementSqlDal;
using LibertyPower.DataAccess.SqlAccess.CommonSql;
using LibertyPower.DataAccess.SqlAccess.AccountSql;
using LibertyPower.Business.CustomerAcquisition.SalesChannel;
using sc = LibertyPower.Business.CustomerAcquisition.SalesChannel;
using LibertyPower.Business.CustomerAcquisition.DailyPricing;
using EFDAL = LibertyPower.DataAccess.SqlAccess.CustomerManagementEF;
using Aspose.Cells;


namespace LibertyPower.Business.CustomerAcquisition.ProspectManagement
{
	[Guid( "95C32E2C-69C7-4ab4-931A-4BE955738C8B" )]
	public static class ProspectContractFactory
	{
		public static Dictionary<string, string> GetDropDownListByLink( string username, string contractNumber, DropDownSelectorLinkType linkType )
		{
			Dictionary<string, string> values = new Dictionary<string, string>();
			DataSet ds = DAL.ProspectManagementSqlDal.GetDropDownListByLink( username, contractNumber, linkType.ToString().ToUpper() );
            if (ds != null && ds.Tables.Count > 0)
			{
                foreach (DataRow dr in ds.Tables[0].Rows)
				{
					//values.Add( dr["option_id"].ToString(), dr["return_value"].ToString() );
					values.Add( dr["return_value"].ToString(), dr["option_id"].ToString() );

				}
			}
			return values;
		}

		#region Drop down wrappers, used in Deal Capture Express web page:

		public static Dictionary<string, string> GetDealContractTypes( string username )
		{
			Dictionary<string, string> values = new Dictionary<string, string>();
			DataSet ds = DAL.ProspectManagementSqlDal.GetDropDownView( username, "DEAL CONTRACT TYPE" );
            if (ds != null && ds.Tables.Count > 0)
			{
                foreach (DataRow dr in ds.Tables[0].Rows)
				{
					// remove renewal choices from drop-down
                    if (!dr["option_id"].ToString().ToUpper().Contains( "RENEWAL" ))
						values.Add( dr["option_id"].ToString(), dr["return_value"].ToString() );
				}
			}
			return values;
		}

		public static Dictionary<string, string> GetAccountTypeDropDown( string username, string salesChannelRole )
		{
			Dictionary<string, string> values = new Dictionary<string, string>();
			DataSet ds = DAL.ProspectManagementSqlDal.GetAccountTypeDropDown( username, salesChannelRole );
            if (ds != null && ds.Tables.Count > 0)
			{
                foreach (DataRow dr in ds.Tables[0].Rows)
				{
					values.Add( dr["option_id"].ToString(), dr["return_value"].ToString() );
				}
			}
			return values;
		}

		public static Dictionary<string, string> GetDealContractStatuses( string username )
		{
			Dictionary<string, string> values = new Dictionary<string, string>();
			DataSet ds = DAL.ProspectManagementSqlDal.GetDropDownView( username, "DEAL CONTRACT STATUS" );
            if (ds != null && ds.Tables.Count > 0)
			{
                foreach (DataRow dr in ds.Tables[0].Rows)
				{
					values.Add( dr["option_id"].ToString(), dr["return_value"].ToString() );
				}
			}
			values.Add( "NONE", "NONE" );
			return values;
		}

		public static Dictionary<string, string> GetDealCaptureExpressOptions( string username )
		{
			Dictionary<string, string> values = new Dictionary<string, string>();
			DataSet ds = DAL.ProspectManagementSqlDal.GetDropDownView( username, "DEAL CAPTURE EXPRESS" );
            if (ds != null && ds.Tables.Count > 0)
			{
                foreach (DataRow dr in ds.Tables[0].Rows)
				{
					values.Add( dr["option_id"].ToString(), dr["return_value"].ToString() );
				}
			}
			return values;
		}

		public static Dictionary<string, string> GetBusinessTypeDealOptions( string username )
		{
			Dictionary<string, string> values = new Dictionary<string, string>();
			DataSet ds = DAL.ProspectManagementSqlDal.GetDropDownView( username, "BUSINESS TYPE DEAL" );
            if (ds != null && ds.Tables.Count > 0)
			{
                foreach (DataRow dr in ds.Tables[0].Rows)
				{
					values.Add( dr["option_id"].ToString(), dr["return_value"].ToString() );
				}
			}
			return values;
		}

		public static Dictionary<string, string> GetBusinessActivityDealOptions( string username )
		{
			Dictionary<string, string> values = new Dictionary<string, string>();
			DataSet ds = DAL.ProspectManagementSqlDal.GetDropDownView( username, "BUSINESS ACTIVITY DEAL" );
            if (ds != null && ds.Tables.Count > 0)
			{
                foreach (DataRow dr in ds.Tables[0].Rows)
				{
					values.Add( dr["option_id"].ToString(), dr["return_value"].ToString() );
				}
			}
			return values;
		}

		public static Dictionary<string, string> GetStatesDropDown( string username )
		{
			Dictionary<string, string> values = new Dictionary<string, string>();
			DataSet ds = DAL.ProspectManagementSqlDal.GetDropDownView( username, "STATES" );
            if (ds != null && ds.Tables.Count > 0)
			{
                foreach (DataRow dr in ds.Tables[0].Rows)
				{
					values.Add( dr["option_id"].ToString(), dr["return_value"].ToString() );
				}
			}
			return values;
		}

		public static Dictionary<string, string> GetMonthsDaysDropDown( string username )
		{
			Dictionary<string, string> values = new Dictionary<string, string>();
			DataSet ds = DAL.ProspectManagementSqlDal.GetDropDownView( username, "MONTHS DAYS" );
            if (ds != null && ds.Tables.Count > 0)
			{
                foreach (DataRow dr in ds.Tables[0].Rows)
				{
					values.Add( dr["option_id"].ToString(), dr["return_value"].ToString() );
				}
			}
			return values;
		}

		public static Dictionary<string, string> GetStatusIdTypes( string username )
		{
			Dictionary<string, string> values = new Dictionary<string, string>();
			DataSet ds = DAL.ProspectManagementSqlDal.GetDropDownView( username, "ID TYPE" );
            if (ds != null && ds.Tables.Count > 0)
			{
                foreach (DataRow dr in ds.Tables[0].Rows)
				{
					values.Add( dr["option_id"].ToString(), dr["return_value"].ToString() );
				}
			}
			return values;
		}

		public static Dictionary<string, string> GetSalesChannels( string username )
		{
			Dictionary<string, string> values = new Dictionary<string, string>();
			DataSet ds = DAL.ProspectManagementSqlDal.GetDropDownView( username, "SALES CHANNEL" );
            if (ds != null && ds.Tables.Count > 0)
			{
                foreach (DataRow dr in ds.Tables[0].Rows)
				{
					values.Add( dr["option_id"].ToString(), dr["return_value"].ToString() );
				}
			}
			return values;
		}

		public static Dictionary<string, string> GetEnrollmentType( string username, string market )
		{
			Dictionary<string, string> values = new Dictionary<string, string>();
			DataSet ds = DAL.ProspectManagementSqlDal.GetDropDownView( username, "ENROLLMENT TYPE", market, null );
			DataTable dt = null;
            if (ds != null && ds.Tables.Count > 0)
			{
				// There seems to be a bug in the SP, need to treat a condition on which there are 2 tables returned instead of 1, 
				// this bug was documented by CEvans and the fix was moved to here:
                if (ds.Tables.Count == 1)
				{
					dt = ds.Tables[0];//cevans added this to eliminate a initialization bug in previous assignment of selected value
				}
                else if (ds.Tables.Count == 2) //cevans added this to avoid crash; additional info to diagnose why 2 tables are returned not available TODO further research
				{
					dt = ds.Tables[1];//cevans added this to eliminate a initialization bug in previous assignment of selected value
				}
                foreach (DataRow dr in dt.Rows)
				{
					values.Add( dr["option_id"].ToString(), dr["return_value"].ToString() );
				}
			}
			return values;
		}

		public static Dictionary<string, string> GetRepositoryDocumentTypes( string username )
		{
			Dictionary<string, string> values = new Dictionary<string, string>();
			DataSet ds = DAL.ProspectManagementSqlDal.GetRepositoryDocumentTypes( username );
            if (ds != null && ds.Tables.Count > 0)
			{
                foreach (DataRow dr in ds.Tables[0].Rows)
				{
					values.Add( dr["document_type_id"].ToString(), dr["document_type_name"].ToString() );
				}
			}
			return values;
		}

		#endregion

		#region Contract Related Functionality

		/// <summary>
		/// Generates a new contract number and returns it
		/// </summary>
		/// <param name="username"></param>
		/// <returns></returns>
		public static string GenerateContractNumber( string username )
		{
			return DAL.ProspectManagementSqlDal.GenerateContractNumber( username );
		}

		public static bool CheckContractAmmendmentExistence( string contractNumber, string amendContractNumber, out string errorMessage )
		{
			bool success = false;
			errorMessage = "No errors found.";
			DataSet ds = DAL.ProspectManagementSqlDal.CheckContractAmmendmentExistence( contractNumber, amendContractNumber );
            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
			{
                if (ds.Tables[0].Rows[0][0].ToString().Equals( "E" ))
				{
					errorMessage = ds.Tables[0].Rows[0][2].ToString();
					success = false;
				}
				else
				{
					errorMessage = ds.Tables[0].Rows[0][2].ToString();
					success = true;
				}
			}
			else
			{
				success = false;
			}
			return success;
		}

		public static bool InsertContract( string username, string contractNumber, string amendContractNumber, string contractType,string CurrentContractAccount,string CurrentNumber, out string errorMessage )
		{
			bool success = true;
			errorMessage = "No errors found.";
			DataSet ds = null;
			// Do some simple data validation:
            if (string.IsNullOrEmpty( contractNumber ) || contractNumber.Trim().Length <= 0)
			{
				contractNumber = contractNumber.Trim();
				errorMessage = "Invalid Contract #";
				success = false;
			}

            if (string.IsNullOrEmpty( contractType ))
			{
				errorMessage = "Must provide contract type before submitting contract";
				success = false;
			}
			else
			{
                if (contractType.Equals( "AMENDMENT" ))
				{
                    if (string.IsNullOrEmpty( amendContractNumber ) || amendContractNumber.Trim().Length <= 0)
					{
						errorMessage = "Invalid Contract # to Amend";
						success = false;
					}
					// now do other checks related to the ammendment contract type:
					success = CheckContractAmmendmentExistence( contractNumber, amendContractNumber, out errorMessage );
				}
			}

			// Now insert first contract(s)
            if (success)
			{
				ds = DAL.ProspectManagementSqlDal.InsertContract( username, contractNumber, amendContractNumber, contractType, CurrentContractAccount,CurrentNumber );
                if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
				{
                    if (ds.Tables[0].Rows[0][0].ToString().Equals( "E" ))
					{
						errorMessage = ds.Tables[0].Rows[0][2].ToString();
						success = false;
					}
					else
					{
						errorMessage = ds.Tables[0].Rows[0][2].ToString();
						success = true;
					}
				}
				else
				{
					success = false;
				}
			}
			return success;
		}

		private static bool InsertContractGeneralInfo( string username, string contractNumber, string businessType, string businessActivity, string additionalIdNumberType, string additionalIdNumber,
					string salesChannelRole, string salesRep, string accountNumber, DateTime? dateSubmit, string dealType, bool? resultIndicator, string ssnClear, string ssnEncrypted, string salesManager,
					int? initialPaymentOptionId, int? residualOptionId, int? evergreenOptionId, DateTime? residualComissionEnd, DateTime? evergreenComissionEnd, double? evergreenCommissionRate, out string errorMessage )
		{
			return InsertContractGeneralInfo( username, contractNumber, businessType, businessActivity, additionalIdNumberType, additionalIdNumber, salesChannelRole, salesRep, accountNumber, dateSubmit, dealType, resultIndicator, ssnClear, ssnEncrypted, salesManager, initialPaymentOptionId, residualOptionId, evergreenOptionId, residualComissionEnd, evergreenComissionEnd, evergreenCommissionRate, null, out errorMessage );
		}

		public static bool InsertContractGeneralInfo( string username, string contractNumber, string businessType, string businessActivity, string additionalIdNumberType, string additionalIdNumber,
					string salesChannelRole, string salesRep, string accountNumber, DateTime? dateSubmit, string dealType, bool? resultIndicator, string ssnClear, string ssnEncrypted, string salesManager,
					int? initialPaymentOptionId, int? residualOptionId, int? evergreenOptionId, DateTime? residualComissionEnd, DateTime? evergreenComissionEnd, double? evergreenCommissionRate, int? taxExempt, out string errorMessage )
		{
			bool success = true;
			errorMessage = "No errors found.";
			DataSet ds = null;
			// Do some simple data validation:
            if (string.IsNullOrEmpty( contractNumber ) || contractNumber.Trim().Length <= 0)
			{
				errorMessage = "Invalid Contract #";
				success = false;
			}

            if (string.IsNullOrEmpty( username ) || username.Trim().Length <= 0)
			{
				errorMessage = "Invalid Username #";
				success = false;
			}

            if (taxExempt == null)
			{
				errorMessage = "Invalid Tax Exempt";
				success = false;
			}

			// Now insert first contract(s)
            if (success)
			{
				ds = DAL.ProspectManagementSqlDal.InsertContractGeneralInfo( username, contractNumber, businessType, businessActivity, additionalIdNumberType, additionalIdNumber,
					 salesChannelRole, salesRep, accountNumber, dateSubmit, dealType, resultIndicator, ssnClear, ssnEncrypted, salesManager,
					 initialPaymentOptionId, residualOptionId, evergreenOptionId, residualComissionEnd, evergreenComissionEnd, evergreenCommissionRate, taxExempt );

                if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
				{
                    if (ds.Tables[0].Rows[0][0].ToString().Equals( "E" ))
					{
						errorMessage = ds.Tables[0].Rows[0][2].ToString();
						success = false;
					}
					else
					{
						errorMessage = ds.Tables[0].Rows[0][2].ToString();
						success = true;
					}
				}
				else
				{
					success = false;
				}
			}

			return success;
		}

		public static bool InsertContractCustomerName( string contractNumber, string customerName, string username, out string errorMessage )
		{
			return InsertContractName( contractNumber, "CUSTOMER", 0, customerName, "CONTRACT", username, out errorMessage );
		}

		private static bool InsertContractName( string contractNumber, string nameType, int nameLink, string fullName, string accountNumber, string username, out string errorMessage )
		{
			return InsertContractName( username, contractNumber, nameType, Convert.ToString( nameLink ), fullName, accountNumber, null, out errorMessage );
		}

		public static bool InsertContractName( string username, string contractNumber, string nameType, string nameLink, string fullName, string accountNumber, bool? resultIndicator, out string errorMessage )
		{
			bool success = true;
			errorMessage = "No errors found.";
			DataSet ds = null;
			// Do some simple data validation:
            if (string.IsNullOrEmpty( contractNumber ) || contractNumber.Trim().Length <= 0)
			{
				errorMessage = "Invalid Contract #";
				success = false;
			}

            if (string.IsNullOrEmpty( username ) || username.Trim().Length <= 0)
			{
				errorMessage = "Invalid Username #";
				success = false;
			}

			// Now insert first contract(s)
            if (success)
			{
				//ds = DAL.ProspectManagementSqlDal.InsertContractName( contractNumber, nameType, nameLink, fullName, accountNumber, username );
				ds = DAL.ProspectManagementSqlDal.InsertContractName( username, contractNumber, nameType, nameLink, fullName, accountNumber, resultIndicator );

                if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
				{
                    if (ds.Tables[0].Rows[0][0].ToString().Equals( "E" ))
					{
						errorMessage = ds.Tables[0].Rows[0][2].ToString();
						success = false;
					}
					else
					{
						errorMessage = ds.Tables[0].Rows[0][2].ToString();
						success = true;
					}
				}
				else
				{
					success = false;
				}
			}

			return success;
		}

		#endregion Contract Related Functionality

		public static bool SaveToDocumentRepository( Stream newDocument, string documentName, int docTypeId,
													 string accountId, string contractNumber, string username, out string errors )
		{
			return DAL.ProspectManagementSqlDal.SaveToDocumentRepository( newDocument, documentName, docTypeId, accountId, contractNumber, username, out errors );
		}

		public static Guid? SaveToDocumentRepository( byte[] newDocument, string documentName, int docTypeId, string accountId, string contractNumber, string username, out List<string> errors )
		{
			errors = new List<string>();

            if (newDocument == null)
			{
				errors.Add( "Parameter newDocument is missing" );
			}
            if (string.IsNullOrEmpty( documentName ))
			{
				errors.Add( "Parameter documentName is missing" );
			}
            if (docTypeId < 1)
			{
				errors.Add( "Parameter docTypeId is missing" );
			}
            if (string.IsNullOrEmpty( contractNumber ))
			{
				errors.Add( "Parameter contractNumber is missing" );
			}
            if (string.IsNullOrEmpty( username ))
			{
				errors.Add( "Parameter username is missing" );
			}

            if (errors.Count == 0)
			{
				return DAL.ProspectManagementSqlDal.SaveToDocumentRepository( newDocument, documentName, docTypeId, accountId, contractNumber, username );
			}
			else
			{
				return null;
			}
		}

		public static bool InsertContractComment( string username, string contractNumber, string comment, out string errorMessage )
		{
			bool success = true;
			DataSet ds = null;
			errorMessage = "No errors found.";
			// Do some simple data validation:
            if (string.IsNullOrEmpty( contractNumber ) || contractNumber.Trim().Length <= 0)
			{
				errorMessage = "Invalid Contract #";
				success = false;
			}

            if (string.IsNullOrEmpty( username ) || username.Trim().Length <= 0)
			{
				errorMessage = "Invalid Username #";
				success = false;
			}

            if (success)
			{
				ds = DAL.ProspectManagementSqlDal.InsertContractComment( username, contractNumber, comment );

                if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
				{
                    if (ds.Tables[0].Rows[0][0].ToString().Equals( "E" ))
					{
						errorMessage = ds.Tables[0].Rows[0][2].ToString();
						success = false;
					}
					else
					{
						errorMessage = ds.Tables[0].Rows[0][2].ToString();
						success = true;
					}
				}
				else
				{
					success = false;
				}
			}

			return success;
		}
        /// <summary>
        /// Test if the account already exist in LibertyPower database
        /// </summary>
        /// <param name="accountNumber"></param>
        /// <param name="utilityId"></param>
        /// <param name="errorMessage"></param>
        /// <returns></returns>
        public static bool ChkAccountInLp(string accountNumber, string utilityId, out string errorMessage)
        {
            bool success = true;
            DataSet ds = null;
            errorMessage = "No errors found.";

            ds = DAL.ProspectManagementSqlDal.ChkAccountInLp(accountNumber, utilityId);

                if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                {
                    if (ds.Tables[0].Rows[0][0].ToString().Equals("This is an Account of Liberty Power"))
                    {
                        errorMessage = ds.Tables[0].Rows[0][0].ToString();
                        success = false;
                    }                   
                }
                else
                {
                    success = false;
                }
            return success;
        }

        
        public static bool InsertContractContact( string username, string contractNumber, string contactLink, string firstName, string lastName, string title, string phone, string fax, string email, string birthday, string contactType, string accountNumber, out string errorMessage )
		{
			bool success = true;
			DataSet ds = null;
			errorMessage = "No errors found.";
			// Do some simple data validation:
            if (string.IsNullOrEmpty( contractNumber ) || contractNumber.Trim().Length <= 0)
			{
				errorMessage = "Invalid Contract #";
				success = false;
			}

            if (string.IsNullOrEmpty( username ) || username.Trim().Length <= 0)
			{
				errorMessage = "Invalid Username #";
				success = false;
			}

            if (success)
			{
				ds = DAL.ProspectManagementSqlDal.InsertContractContact( username, contractNumber, contactLink, firstName, lastName, title, phone, fax, email, birthday, contactType, accountNumber );

                if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
				{
                    if (ds.Tables[0].Rows[0][0].ToString().Equals( "E" ))
					{
						errorMessage = ds.Tables[0].Rows[0][2].ToString();
						success = false;
					}
					else
					{
						errorMessage = ds.Tables[0].Rows[0][2].ToString();
						success = true;
					}
				}
				else
				{
					success = false;
				}
			}

			return success;
		}

		public static bool InsertContractAddress( string username, string contractNumber, string addressLink, string address,
			string suite, string city, string state, string zip, string addressType, string accountNumber, out string errorMessage )
		{
			bool success = true;
			DataSet ds = null;
			errorMessage = "No errors found.";
			// Do some simple data validation:
            if (string.IsNullOrEmpty( contractNumber ) || contractNumber.Trim().Length <= 0)
			{
				errorMessage = "Invalid Contract #";
				success = false;
			}

            if (string.IsNullOrEmpty( username ) || username.Trim().Length <= 0)
			{
				errorMessage = "Invalid Username #";
				success = false;
			}

            if (success)
			{
				ds = DAL.ProspectManagementSqlDal.InsertContractAddress( username, contractNumber, addressLink, address, suite, city, state, zip, addressType, accountNumber );

                if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
				{
                    if (ds.Tables[0].Rows[0][0].ToString().Equals( "E" ))
					{
						errorMessage = ds.Tables[0].Rows[0][2].ToString();
						success = false;
					}
					else
					{
						errorMessage = ds.Tables[0].Rows[0][2].ToString();
						success = true;
					}
				}
				else
				{
					success = false;
				}
			}

			return success;
		}

		public static bool InsertContractPricing( string username, string contractNumber, string market, string utility,
			string accountType, string product, string rateId, string rate, string effStartDate, string enrollmentType,
			string requestedFlowStartDate, string termMonths, string accountNumber, string customerCode, string customerGroup,
			string transferRate, string gasIndexName, string heat, string commCapm, string contractDate,
			Int64 priceID, int priceTierID, out string errorMessage, string ratesString = null )
		{
			bool success = true;
			DataSet ds = null;
			errorMessage = "No errors found.";
			// Do some simple data validation:
            if (string.IsNullOrEmpty( contractNumber ) || contractNumber.Trim().Length <= 0)
			{
				errorMessage = "Invalid Contract #";
				success = false;
			}

            if (string.IsNullOrEmpty( username ) || username.Trim().Length <= 0)
			{
				errorMessage = "Invalid Username #";
				success = false;
			}

            if (success)
			{
                if (contractDate.Length == 0)
				{
					contractDate = DateTime.Today.Date.ToShortDateString();
				}

				ds = DAL.ProspectManagementSqlDal.InsertContractPricing( username, contractNumber, market, utility, accountType, product, rateId, rate,
					effStartDate, enrollmentType, requestedFlowStartDate, termMonths, accountNumber, customerCode, customerGroup, transferRate, gasIndexName,
					heat, commCapm, contractDate, priceID, priceTierID, ratesString );

                if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
				{
                    if (ds.Tables[0].Rows[0][0].ToString().Equals( "E" ))
					{
						errorMessage = ds.Tables[0].Rows[0][2].ToString();
						success = false;
					}
					else
					{
						errorMessage = ds.Tables[0].Rows[0][2].ToString();
						success = true;
					}
				}
				else
				{
					success = false;
				}
			}

			return success;
		}

		public static bool InsertContractAccount( string username, string contractNumber, string accountNumber, string utility,
			string meterNumber, string zone, Int64 priceID, out string errorMessage )
		{
			bool success = true;
			DataSet ds = null;
			errorMessage = "No errors found.";
			// Do some simple data validation:
            if (string.IsNullOrEmpty( contractNumber ) || contractNumber.Trim().Length <= 0)
			{
				errorMessage = "Invalid Contract #";
				success = false;
			}

            if (string.IsNullOrEmpty( username ) || username.Trim().Length <= 0)
			{
				errorMessage = "Invalid Username #";
				success = false;
			}

            if (success)
			{
				ds = DAL.ProspectManagementSqlDal.InsertContractAccount( username, contractNumber, accountNumber, utility, meterNumber, zone, priceID );

                if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
				{
                    if (ds.Tables[0].Rows[0][0].ToString().Equals( "E" ))
					{
						errorMessage = ds.Tables[0].Rows[0][2].ToString();
						success = false;
					}
					else
					{
						errorMessage = ds.Tables[0].Rows[0][2].ToString();
						success = true;
					}
				}
				else
				{
					success = false;
				}
			}

			return success;
		}

		public static DataSet GetContractAccountListByContract( string contractNumber, string contractType, int eventId )
		{
			DataSet ds = DAL.ProspectManagementSqlDal.GetContractAccountListByContract( contractNumber, contractType, eventId );

			return ds;
		}

		public static DataSet GetDailyPricingTerms( string username, string productId, string unionSelect, string contractNumber, DateTime effStartDate, string accountType, DateTime contractDate )
		{
			DataSet ds = DAL.ProspectManagementSqlDal.GetDailyPricingTerms( username, productId, unionSelect, contractNumber, effStartDate, accountType, contractDate );

			return ds;
		}

		public static DataSet GetDailyPricingRates( string username, string contractNumber, string utilityCode, string productId, string termMonths, string unionSelect, DateTime effStartDate, DateTime contractDate )
		{
			DataSet ds = DAL.ProspectManagementSqlDal.GetDailyPricingRates( username, contractNumber, utilityCode, productId, termMonths, unionSelect, effStartDate, contractDate );

			return ds;
		}

		public static DataSet GetDailyPricingRates( string username, string contractNumber, string utilityCode, string productId, string termMonths, string unionSelect, DateTime effStartDate, DateTime contractDate, string serviceClass, string zone )
		{
			DataSet ds = DAL.ProspectManagementSqlDal.GetDailyPricingRates( username, contractNumber, utilityCode, productId, termMonths, unionSelect, effStartDate, contractDate, serviceClass, zone );

			return ds;
		}

		public static DataSet GetCustomTerms( string username, string utilityCode, int accountTypeID, DateTime startDate, DateTime contractDate )
		{
			return DAL.ProspectManagementSqlDal.GetCustomTerms( username, utilityCode, accountTypeID, startDate, contractDate );
		}

		public static DataSet GetCustomRates( string username, string utilityCode, int accountTypeID, DateTime startDate, DateTime contractDate, int term )
		{
			return DAL.ProspectManagementSqlDal.GetCustomRates( username, utilityCode, accountTypeID, startDate, contractDate, term );
		}

		public static DataSet GetCustomRate( string username, string utilityCode, int accountTypeID, DateTime startDate, DateTime contractDate, int term, Int64 rateId )
		{
			return DAL.ProspectManagementSqlDal.GetCustomRate( username, utilityCode, accountTypeID, startDate, contractDate, term, rateId );
		}

		public static DataSet GetPriceDetailsByPriceId( long priceId )
		{
			return DAL.ProspectManagementSqlDal.GetPriceDetailsByPriceId( priceId );
		}

		public static DataSet GetContractAccountByContract( string username, string contractNumber )
		{
			DataSet ds = DAL.ProspectManagementSqlDal.GetContractAccountByContract( username, contractNumber );

			return ds;
		}

		public static DataSet GetRequestedFlowStartDates( string contractNumber, string username )
		{
			DataSet ds = DAL.ProspectManagementSqlDal.GetRequestedFlowStartDates( contractNumber, username );

			return ds;
		}

		public static DataSet GetContractAddress( string username, string contractNumber, string addressType, string accountNumber )
		{
			DataSet ds = DAL.ProspectManagementSqlDal.GetContractAddress( username, contractNumber, addressType, accountNumber );

			return ds;
		}

		public static DataSet GetContractRateInfo( string username, string productId, string termMonths, int rateId, DateTime contractDate, string multiRatePrint )
		{
			DataSet ds = DAL.ProspectManagementSqlDal.GetContractRateInfo( username, productId, termMonths, rateId, contractDate, multiRatePrint );

			return ds;
		}



		public static decimal GetDealRate()
		{
			DataSet ds = DAL.ProspectManagementSqlDal.GetDealRate();
			decimal rate_cap;
			decimal.TryParse( ds.Tables[0].Rows[0]["rate_cap"] + "", out rate_cap );

			return rate_cap;
		}

		public static DataSet GetHeatIndexSource()
		{
			DataSet ds = DAL.ProspectManagementSqlDal.GetHeatIndexSource();

			return ds;
		}

		public static bool ProductIsFlexible( string productId, out string errorMessage )
		{
			bool flag = false;
			DataTable dt;
			errorMessage = "No errors found.";
			dt = DAL.ProspectManagementSqlDal.ProductIsFlexible( productId ).Tables[0];

            switch (dt.Rows[0][0] + "")
			{
				case "E":
					errorMessage = dt.Rows[0][2] + "";
					break;
				case "N":
					// keep txt_rate.Enabled = False
					flag = false;
					break;
				default:
					flag = true;
					break;
			}

			return flag;
		}

		public static bool ProductIsFixed( string productId )
		{
			string pCategory = DAL.ProspectManagementSqlDal.ProductCategory( productId );
            if (pCategory.ToUpper().Trim().Equals( "FIXED" ))
				return true;
			return false;
		}

		public static bool ProductIsCustom( string username, string productId )
		{
			bool flag = false;
			DataTable dt;
			string strCategory = "";
			string strSubCategory = "";
			string isCustom = "";

			dt = DAL.ProspectManagementSqlDal.ProductIsCustom( username, productId ).Tables[0];

            if (dt != null)
			{
                if (dt.Rows.Count > 0)
				{
                    if (!(dt.Rows[0].IsNull( "product_category" )))
					{
						strCategory = dt.Rows[0]["product_category"] + "";
					}
                    if (!(dt.Rows[0].IsNull( "product_sub_category" )))
					{
						strSubCategory = dt.Rows[0]["product_sub_category"] + "";
					}
                    if (!(dt.Rows[0].IsNull( "isCustom" )))
					{
						isCustom = dt.Rows[0]["isCustom"] + "";
					}
				}
			}
			flag = isCustom.Trim().ToUpper() == ("1");

			return flag;
		}

		public static string GetMetersByAccountNumber( string accountNumber )
		{
			DataTable dt = DAL.ProspectManagementSqlDal.GetMetersByAccountNumber( accountNumber ).Tables[0];

            if (dt.Rows.Count > 0)
			{
				return dt.Rows[0]["meter_number"].ToString().Trim();
			}
			return "";


		}

		public static bool IsMeterNumberRequired( string utilityId )
		{
			bool flag = false;
			DataTable dt = DAL.ProspectManagementSqlDal.IsMeterNumberRequired( utilityId ).Tables[0];
            if (dt.Rows.Count > 0)
			{
                if (Convert.ToInt16( dt.Rows[0]["meter_number_required"] ) == 1)
				{
					flag = true;
				}
			}

			return flag;

		}

		public static bool CheckContractTypeExists( string contractType )
		{
			bool flag = false;
			DataTable dt = DAL.ProspectManagementSqlDal.CheckContractTypeExists( contractType ).Tables[0];
            if (dt.Rows[0][0].ToString() == "FALSE")
			{
				flag = false;
			}
			else
			{
				flag = true;
			}
			return flag;
		}

		public static DataSet GetServiceClassZoneByProduct( string productCode, string rateId )
		{
			DataSet ds = DAL.ProspectManagementSqlDal.GetServiceClassZoneByProduct( productCode, rateId );

			return ds;
		}

		public static DataSet GetContractError( string contractNumber )
		{
			DataSet ds = DAL.ProspectManagementSqlDal.GetContractError( contractNumber );

			return ds;
		}

		public static DataSet GetPrintMultiContract( string contractNumber )
		{
			DataSet ds = DAL.ProspectManagementSqlDal.GetPrintMultiContract( contractNumber );

			return ds;
		}
        //Added JUly 2013
		public static DataSet GetPrintContract( string contractNumber, string userName )
        {
			DataSet ds = DAL.ProspectManagementSqlDal.GetPrintContract( contractNumber, userName );

            return ds;
        }
		public static DataSet GetContractAddressByLink( string username, string contractNumber, string addressLink )
		{
			DataSet ds = DAL.ProspectManagementSqlDal.GetContractAddressByLink( username, contractNumber, addressLink );

			return ds;
		}

		public static DataSet GetContractContact( string username, string contractNumber, string contactType, string accountNumber )
		{
			DataSet ds = DAL.ProspectManagementSqlDal.GetContractContact( username, contractNumber, contactType, accountNumber );

			return ds;
		}

		public static DataSet GetContractContactByLink( string username, string contractNumber, string contactLink )
		{
			DataSet ds = DAL.ProspectManagementSqlDal.GetContractContactByLink( username, contractNumber, contactLink );

			return ds;
		}

		public static DataSet GetContractName( string username, string contractNumber, string nameType, string accountNumber )
		{
			DataSet ds = DAL.ProspectManagementSqlDal.GetContractName( username, contractNumber, nameType, accountNumber );

			return ds;
		}

		public static DataSet GetContractNameByLink( string username, string contractNumber, string nameLink )
		{
			DataSet ds = DAL.ProspectManagementSqlDal.GetContractNameByLink( username, contractNumber, nameLink );

			return ds;
		}

		//public static DataSet GetCommSalesChannelRatesCommCap(string username, string commTransTypeID)
		//{
		//    DataSet ds = DAL.ProspectManagementSqlDal.GetCommSalesChannelRatesCommCap( username, commTransTypeID);

		//    return ds;
		//}

		public static DataSet SubmitContract( string username, string contractNumber, string process, string contractType )
		{
			DataSet ds = new DataSet();
			DataTable dt = new DataTable();
			dt.Columns.Add( "0" );
			dt.Columns.Add( "1" );
			dt.Columns.Add( "2" );
			ds.Tables.Add( dt );

			try
			{
				ProspectContract contract = GetContractInfo( username, contractNumber, "CONTRACT" );
				contract.Accounts = FillContractAccounts( username, contract );

				ds = DAL.ProspectManagementSqlDal.SubmitContract( username, contractNumber, process, contractType );
				dt.Rows.Add( "", "", "Process completed successfully" );
			}
            catch (Exception e)
			{
				dt.Rows.Add( "E", "", e.Message );
			}

			return ds;
		}

		public static ProspectContract GetContractInfo( string username, string contractNumber, string accountNumber )
		{
			ProspectContract objContract = new ProspectContract();

			DataSet dsRecord = DAL.ProspectManagementSqlDal.GetContractInfo( username, contractNumber, accountNumber );

            if (dsRecord != null && dsRecord.Tables.Count > 0)
			{
				objContract.ContractNumber = dsRecord.Tables[0].Rows[0]["contract_nbr"].ToString().Trim();
				objContract.Status = dsRecord.Tables[0].Rows[0]["status"].ToString().Trim();
				objContract.Comment = dsRecord.Tables[0].Rows[0]["comment"].ToString().Trim();
				objContract.BusinessActivity = dsRecord.Tables[0].Rows[0]["business_activity"].ToString().Trim();
				objContract.BusinessType = dsRecord.Tables[0].Rows[0]["business_type"].ToString().Trim();
				objContract.AdditionalIdNumberType = dsRecord.Tables[0].Rows[0]["additional_id_nbr_type"].ToString().Trim();
				objContract.SalesChannelRole = dsRecord.Tables[0].Rows[0]["sales_channel_role"].ToString().Trim();

				objContract.ContractEffectiveStartDate = Convert.ToDateTime( dsRecord.Tables[0].Rows[0]["contract_eff_start_date"] );
				objContract.DateEnd = Convert.ToDateTime( dsRecord.Tables[0].Rows[0]["date_end"] );
				objContract.SalesRep = dsRecord.Tables[0].Rows[0]["sales_rep"].ToString().Trim();

                if (dsRecord.Tables[0].Rows[0]["sales_mgr"] != DBNull.Value)
					objContract.SalesManager = dsRecord.Tables[0].Rows[0]["sales_mgr"].ToString().Trim();
                if (dsRecord.Tables[0].Rows[0]["initial_pymt_option_id"] != DBNull.Value)
					objContract.InitialPymtOptionId = Convert.ToInt32( dsRecord.Tables[0].Rows[0]["initial_pymt_option_id"] );
                if (dsRecord.Tables[0].Rows[0]["residual_option_id"] != DBNull.Value)
					objContract.ResidualOptionId = Convert.ToInt32( dsRecord.Tables[0].Rows[0]["residual_option_id"] );
                if (dsRecord.Tables[0].Rows[0]["residual_commission_end"] != DBNull.Value)
					objContract.ResidualCommisionEnd = Convert.ToDateTime( dsRecord.Tables[0].Rows[0]["residual_commission_end"] );
                if (dsRecord.Tables[0].Rows[0]["evergreen_option_id"] != DBNull.Value)
					objContract.EvergreenOptionId = Convert.ToInt32( dsRecord.Tables[0].Rows[0]["evergreen_option_id"] );
                if (dsRecord.Tables[0].Rows[0]["evergreen_commission_end"] != DBNull.Value)
					objContract.EvergreenCommissionEnd = Convert.ToDateTime( dsRecord.Tables[0].Rows[0]["evergreen_commission_end"] );
                if (dsRecord.Tables[0].Rows[0]["evergreen_commission_rate"] != DBNull.Value)
					objContract.EvergreenCommisionRate = Convert.ToDouble( dsRecord.Tables[0].Rows[0]["evergreen_commission_rate"] );
				objContract.CustomerGroup = dsRecord.Tables[0].Rows[0]["customer_group"].ToString().Trim();
				objContract.RequestedFlowStartDate = Convert.ToDateTime( dsRecord.Tables[0].Rows[0]["requested_flow_start_date"] );
				objContract.CustomerNameLink = Convert.ToInt32( dsRecord.Tables[0].Rows[0]["customer_name_link"] );
				objContract.CustomerName = dsRecord.Tables[0].Rows[0]["customer_name"].ToString().Trim();
				objContract.OwnerNameLink = Convert.ToInt32( dsRecord.Tables[0].Rows[0]["owner_name_link"] );
				objContract.OwnerName = dsRecord.Tables[0].Rows[0]["owner_name"].ToString().Trim();
				objContract.CustomerAddressLink = Convert.ToInt32( dsRecord.Tables[0].Rows[0]["customer_address_link"] );
				objContract.CustomerAddress = dsRecord.Tables[0].Rows[0]["customer_address"].ToString().Trim();
				objContract.CustomerSuite = dsRecord.Tables[0].Rows[0]["customer_suite"].ToString().Trim();
				objContract.CustomerCity = dsRecord.Tables[0].Rows[0]["customer_city"].ToString().Trim();
				objContract.CustomerZip = dsRecord.Tables[0].Rows[0]["customer_zip"].ToString().Trim();
				objContract.CustomerState = dsRecord.Tables[0].Rows[0]["customer_state"].ToString().Trim();
				objContract.ServiceAddressLink = Convert.ToInt32( dsRecord.Tables[0].Rows[0]["service_address_link"] );
				objContract.ServiceAddress = dsRecord.Tables[0].Rows[0]["service_address"].ToString().Trim();
				objContract.ServiceSuite = dsRecord.Tables[0].Rows[0]["service_suite"].ToString().Trim();
				objContract.ServiceCity = dsRecord.Tables[0].Rows[0]["service_city"].ToString().Trim();
				objContract.ServiceZip = dsRecord.Tables[0].Rows[0]["service_zip"].ToString().Trim();
				objContract.ServiceState = dsRecord.Tables[0].Rows[0]["service_state"].ToString().Trim();
				objContract.BillingAddressLink = Convert.ToInt32( dsRecord.Tables[0].Rows[0]["billing_address_link"] );
				objContract.BillingAddress = dsRecord.Tables[0].Rows[0]["billing_address"].ToString().Trim();
				objContract.BillingSuite = dsRecord.Tables[0].Rows[0]["billing_suite"].ToString().Trim();
				objContract.BillingCity = dsRecord.Tables[0].Rows[0]["billing_city"].ToString().Trim();
				objContract.BillingZip = dsRecord.Tables[0].Rows[0]["billing_zip"].ToString().Trim();
				objContract.BillingState = dsRecord.Tables[0].Rows[0]["billing_state"].ToString().Trim();
				objContract.CustomerContactLink = Convert.ToInt32( dsRecord.Tables[0].Rows[0]["customer_contact_link"] );
				objContract.CustomerFirstName = dsRecord.Tables[0].Rows[0]["customer_first_name"].ToString().Trim();
				objContract.CustomerLastName = dsRecord.Tables[0].Rows[0]["customer_last_name"].ToString().Trim();
				objContract.CustomerTitle = dsRecord.Tables[0].Rows[0]["customer_title"].ToString().Trim();
				objContract.CustomerPhone = dsRecord.Tables[0].Rows[0]["customer_phone"].ToString().Trim();
				objContract.CustomerFax = dsRecord.Tables[0].Rows[0]["customer_fax"].ToString().Trim();
				objContract.CustomerEmail = dsRecord.Tables[0].Rows[0]["customer_email"].ToString().Trim();
				objContract.CustomerBirthday = dsRecord.Tables[0].Rows[0]["customer_birthday"].ToString().Trim();
				objContract.BillingContactLink = Convert.ToInt32( dsRecord.Tables[0].Rows[0]["billing_contact_link"] );
				objContract.BillingFirstName = dsRecord.Tables[0].Rows[0]["billing_first_name"].ToString().Trim();
				objContract.BillingLastName = dsRecord.Tables[0].Rows[0]["billing_last_name"].ToString().Trim();
				objContract.BillingTitle = dsRecord.Tables[0].Rows[0]["billing_title"].ToString().Trim();
				objContract.BillingPhone = dsRecord.Tables[0].Rows[0]["billing_phone"].ToString().Trim();
				objContract.BillingFax = dsRecord.Tables[0].Rows[0]["billing_fax"].ToString().Trim();
				objContract.BillingEmail = dsRecord.Tables[0].Rows[0]["billing_email"].ToString().Trim();
				objContract.BillingBirthday = dsRecord.Tables[0].Rows[0]["billing_birthday"].ToString().Trim();
                if (!dsRecord.Tables[0].Rows[0]["retail_mkt_id"].ToString().Trim().Contains( "NN" ))
					objContract.Market = MarketManagement.UtilityManagement.MarketFactory.GetRetailMarket( dsRecord.Tables[0].Rows[0]["retail_mkt_id"].ToString().Trim() );
                if (!dsRecord.Tables[0].Rows[0]["utility_id"].ToString().Trim().Contains( "NONE" ))
					objContract.Utility = MarketManagement.UtilityManagement.UtilityFactory.GetUtilityByCode( dsRecord.Tables[0].Rows[0]["utility_id"].ToString().Trim() );
				objContract.SSNEncrypted = dsRecord.Tables[0].Rows[0]["SSNEncrypted"].ToString().Trim();
				objContract.AdditionalIdNumber = dsRecord.Tables[0].Rows[0]["additional_id_nbr"].ToString().Trim();
                if (dsRecord.Tables[0].Rows[0]["account_type"] != DBNull.Value)
				{
                    if (dsRecord.Tables[0].Rows[0]["account_type"].ToString().Trim() == "3")
					{
						objContract.AccountType = LibertyPower.Business.CustomerAcquisition.ProductManagement.AccountType.Lci;
					}
                    else if (dsRecord.Tables[0].Rows[0]["account_type"].ToString().Trim() == "1")
					{
						objContract.AccountType = LibertyPower.Business.CustomerAcquisition.ProductManagement.AccountType.Smb;
					}
                    else if (dsRecord.Tables[0].Rows[0]["account_type"].ToString().Trim() == "2")
					{
						objContract.AccountType = LibertyPower.Business.CustomerAcquisition.ProductManagement.AccountType.Residential;
					}
                    else if (dsRecord.Tables[0].Rows[0]["account_type"].ToString().Trim() == "4")
					{
						objContract.AccountType = LibertyPower.Business.CustomerAcquisition.ProductManagement.AccountType.Soho;
					}
				}

				objContract.ContractRateType = dsRecord.Tables[0].Rows[0]["contract_rate_type"].ToString().Trim();
                if (!dsRecord.Tables[0].Rows[0]["product_id"].ToString().Trim().Contains( "NONE" ))
					objContract.Product = ProductManagement.ProductFactory.CreateProduct( dsRecord.Tables[0].Rows[0]["product_id"].ToString().Trim() );
				if (objContract.Product != null)
				{
					int productAccountTypeId = 0;
					int.TryParse( dsRecord.Tables[0].Rows[0]["account_type"].ToString().Trim(), out productAccountTypeId );
					objContract.Product.AccountTypeID = productAccountTypeId;
				}
				objContract.DateDeal = Convert.ToDateTime( dsRecord.Tables[0].Rows[0]["date_deal"] );
				objContract.DateSubmit = Convert.ToDateTime( dsRecord.Tables[0].Rows[0]["date_submit"] );
				objContract.TermMonths = Convert.ToInt32( dsRecord.Tables[0].Rows[0]["term_months"] );
				objContract.RateId = Convert.ToInt32( dsRecord.Tables[0].Rows[0]["rate_id"] );
				objContract.Rate = Convert.ToDecimal( dsRecord.Tables[0].Rows[0]["rate"] );
				objContract.EnrollmentType = Convert.ToInt32( dsRecord.Tables[0].Rows[0]["enrollment_type"] );
				objContract.HeaderEnrollment1 = dsRecord.Tables[0].Rows[0]["header_enrollment_1"].ToString().Trim();
				objContract.HeaderEnrollment2 = dsRecord.Tables[0].Rows[0]["header_enrollment_2"].ToString().Trim();
				objContract.ContractType = dsRecord.Tables[0].Rows[0]["contract_type"].ToString().Trim();
				objContract.Username = UserFactory.GetUserByLogin( dsRecord.Tables[0].Rows[0]["username"].ToString().Trim() );
				objContract.ProductBrandID = dsRecord.Tables[0].Rows[0]["ProductBrandID"] == DBNull.Value ? 0 : Convert.ToInt32( dsRecord.Tables[0].Rows[0]["ProductBrandID"] );
				objContract.PriceID = dsRecord.Tables[0].Rows[0]["PriceID"] == DBNull.Value ? 0 : Convert.ToInt64( dsRecord.Tables[0].Rows[0]["PriceID"] );
				objContract.PriceTier = dsRecord.Tables[0].Rows[0]["PriceTier"] == DBNull.Value ? 0 : Convert.ToInt32( dsRecord.Tables[0].Rows[0]["PriceTier"] );

				int taxStatus = dsRecord.Tables[0].Rows[0]["TaxExempt"] == DBNull.Value ? 0 : Convert.ToInt32( dsRecord.Tables[0].Rows[0]["TaxExempt"] );
				objContract.TaxExempt = taxStatus;
			}
			return objContract;
		}

		public static ProspectContract GetContractInfo( string username, string contractNumber, string accountNumber, int estimatedAnnualUsage )
		{
			ProspectContract objContract = new ProspectContract();

			DataSet dsRecord = DAL.ProspectManagementSqlDal.GetContractInfo( username, contractNumber, accountNumber );
            if (dsRecord != null && dsRecord.Tables.Count > 0)
			{
				objContract.ContractNumber = dsRecord.Tables[0].Rows[0]["contract_nbr"].ToString().Trim();
				objContract.Status = dsRecord.Tables[0].Rows[0]["status"].ToString().Trim();
				objContract.Comment = dsRecord.Tables[0].Rows[0]["comment"].ToString().Trim();
				objContract.BusinessActivity = dsRecord.Tables[0].Rows[0]["business_activity"].ToString().Trim();
				objContract.BusinessType = dsRecord.Tables[0].Rows[0]["business_type"].ToString().Trim();
				objContract.AdditionalIdNumberType = dsRecord.Tables[0].Rows[0]["additional_id_nbr_type"].ToString().Trim();
				objContract.SalesChannelRole = dsRecord.Tables[0].Rows[0]["sales_channel_role"].ToString().Trim();

				objContract.ContractEffectiveStartDate = Convert.ToDateTime( dsRecord.Tables[0].Rows[0]["contract_eff_start_date"] );
				objContract.DateEnd = Convert.ToDateTime( dsRecord.Tables[0].Rows[0]["date_end"] );
				objContract.SalesRep = dsRecord.Tables[0].Rows[0]["sales_rep"].ToString().Trim();

                if (dsRecord.Tables[0].Rows[0]["sales_mgr"] != DBNull.Value)
					objContract.SalesManager = dsRecord.Tables[0].Rows[0]["sales_mgr"].ToString().Trim();
                if (dsRecord.Tables[0].Rows[0]["initial_pymt_option_id"] != DBNull.Value)
					objContract.InitialPymtOptionId = Convert.ToInt32( dsRecord.Tables[0].Rows[0]["initial_pymt_option_id"] );
                if (dsRecord.Tables[0].Rows[0]["residual_option_id"] != DBNull.Value)
					objContract.ResidualOptionId = Convert.ToInt32( dsRecord.Tables[0].Rows[0]["residual_option_id"] );
                if (dsRecord.Tables[0].Rows[0]["residual_commission_end"] != DBNull.Value)
					objContract.ResidualCommisionEnd = Convert.ToDateTime( dsRecord.Tables[0].Rows[0]["residual_commission_end"] );
                if (dsRecord.Tables[0].Rows[0]["evergreen_option_id"] != DBNull.Value)
					objContract.EvergreenOptionId = Convert.ToInt32( dsRecord.Tables[0].Rows[0]["evergreen_option_id"] );
                if (dsRecord.Tables[0].Rows[0]["evergreen_commission_end"] != DBNull.Value)
					objContract.EvergreenCommissionEnd = Convert.ToDateTime( dsRecord.Tables[0].Rows[0]["evergreen_commission_end"] );
                if (dsRecord.Tables[0].Rows[0]["evergreen_commission_rate"] != DBNull.Value)
					objContract.EvergreenCommisionRate = Convert.ToDouble( dsRecord.Tables[0].Rows[0]["evergreen_commission_rate"] );
				objContract.CustomerGroup = dsRecord.Tables[0].Rows[0]["customer_group"].ToString().Trim();
				objContract.RequestedFlowStartDate = Convert.ToDateTime( dsRecord.Tables[0].Rows[0]["requested_flow_start_date"] );
				objContract.CustomerNameLink = Convert.ToInt32( dsRecord.Tables[0].Rows[0]["customer_name_link"] );
				objContract.CustomerName = dsRecord.Tables[0].Rows[0]["customer_name"].ToString().Trim();
				objContract.OwnerNameLink = Convert.ToInt32( dsRecord.Tables[0].Rows[0]["owner_name_link"] );
				objContract.OwnerName = dsRecord.Tables[0].Rows[0]["owner_name"].ToString().Trim();
				objContract.CustomerAddressLink = Convert.ToInt32( dsRecord.Tables[0].Rows[0]["customer_address_link"] );
				objContract.CustomerAddress = dsRecord.Tables[0].Rows[0]["customer_address"].ToString().Trim();
				objContract.CustomerSuite = dsRecord.Tables[0].Rows[0]["customer_suite"].ToString().Trim();
				objContract.CustomerCity = dsRecord.Tables[0].Rows[0]["customer_city"].ToString().Trim();
				objContract.CustomerZip = dsRecord.Tables[0].Rows[0]["customer_zip"].ToString().Trim();
				objContract.CustomerState = dsRecord.Tables[0].Rows[0]["customer_state"].ToString().Trim();
				objContract.ServiceAddressLink = Convert.ToInt32( dsRecord.Tables[0].Rows[0]["service_address_link"] );
				objContract.ServiceAddress = dsRecord.Tables[0].Rows[0]["service_address"].ToString().Trim();
				objContract.ServiceSuite = dsRecord.Tables[0].Rows[0]["service_suite"].ToString().Trim();
				objContract.ServiceCity = dsRecord.Tables[0].Rows[0]["service_city"].ToString().Trim();
				objContract.ServiceZip = dsRecord.Tables[0].Rows[0]["service_zip"].ToString().Trim();
				objContract.ServiceState = dsRecord.Tables[0].Rows[0]["service_state"].ToString().Trim();
				objContract.BillingAddressLink = Convert.ToInt32( dsRecord.Tables[0].Rows[0]["billing_address_link"] );
				objContract.BillingAddress = dsRecord.Tables[0].Rows[0]["billing_address"].ToString().Trim();
				objContract.BillingSuite = dsRecord.Tables[0].Rows[0]["billing_suite"].ToString().Trim();
				objContract.BillingCity = dsRecord.Tables[0].Rows[0]["billing_city"].ToString().Trim();
				objContract.BillingZip = dsRecord.Tables[0].Rows[0]["billing_zip"].ToString().Trim();
				objContract.BillingState = dsRecord.Tables[0].Rows[0]["billing_state"].ToString().Trim();
				objContract.CustomerContactLink = Convert.ToInt32( dsRecord.Tables[0].Rows[0]["customer_contact_link"] );
				objContract.CustomerFirstName = dsRecord.Tables[0].Rows[0]["customer_first_name"].ToString().Trim();
				objContract.CustomerLastName = dsRecord.Tables[0].Rows[0]["customer_last_name"].ToString().Trim();
				objContract.CustomerTitle = dsRecord.Tables[0].Rows[0]["customer_title"].ToString().Trim();
				objContract.CustomerPhone = dsRecord.Tables[0].Rows[0]["customer_phone"].ToString().Trim();
				objContract.CustomerFax = dsRecord.Tables[0].Rows[0]["customer_fax"].ToString().Trim();
				objContract.CustomerEmail = dsRecord.Tables[0].Rows[0]["customer_email"].ToString().Trim();
				objContract.CustomerBirthday = dsRecord.Tables[0].Rows[0]["customer_birthday"].ToString().Trim();
				objContract.BillingContactLink = Convert.ToInt32( dsRecord.Tables[0].Rows[0]["billing_contact_link"] );
				objContract.BillingFirstName = dsRecord.Tables[0].Rows[0]["billing_first_name"].ToString().Trim();
				objContract.BillingLastName = dsRecord.Tables[0].Rows[0]["billing_last_name"].ToString().Trim();
				objContract.BillingTitle = dsRecord.Tables[0].Rows[0]["billing_title"].ToString().Trim();
				objContract.BillingPhone = dsRecord.Tables[0].Rows[0]["billing_phone"].ToString().Trim();
				objContract.BillingFax = dsRecord.Tables[0].Rows[0]["billing_fax"].ToString().Trim();
				objContract.BillingEmail = dsRecord.Tables[0].Rows[0]["billing_email"].ToString().Trim();
				objContract.BillingBirthday = dsRecord.Tables[0].Rows[0]["billing_birthday"].ToString().Trim();
                if (!dsRecord.Tables[0].Rows[0]["retail_mkt_id"].ToString().Trim().Contains( "NN" ))
					objContract.Market = MarketManagement.UtilityManagement.MarketFactory.GetRetailMarket( dsRecord.Tables[0].Rows[0]["retail_mkt_id"].ToString().Trim() );
                if (!dsRecord.Tables[0].Rows[0]["utility_id"].ToString().Trim().Contains( "NONE" ))
					objContract.Utility = MarketManagement.UtilityManagement.UtilityFactory.GetUtilityByCode( dsRecord.Tables[0].Rows[0]["utility_id"].ToString().Trim() );
				objContract.SSNEncrypted = dsRecord.Tables[0].Rows[0]["SSNEncrypted"].ToString().Trim();
				objContract.AdditionalIdNumber = dsRecord.Tables[0].Rows[0]["additional_id_nbr"].ToString().Trim();
                if (dsRecord.Tables[0].Rows[0]["account_type"] != DBNull.Value)
				{
                    if (dsRecord.Tables[0].Rows[0]["account_type"].ToString().Trim() == "3")
					{
						objContract.AccountType = LibertyPower.Business.CustomerAcquisition.ProductManagement.AccountType.Lci;
					}
                    else if (dsRecord.Tables[0].Rows[0]["account_type"].ToString().Trim() == "1")
					{
						objContract.AccountType = LibertyPower.Business.CustomerAcquisition.ProductManagement.AccountType.Smb;
					}
                    else if (dsRecord.Tables[0].Rows[0]["account_type"].ToString().Trim() == "2")
					{
						objContract.AccountType = LibertyPower.Business.CustomerAcquisition.ProductManagement.AccountType.Residential;
					}
                    else if (dsRecord.Tables[0].Rows[0]["account_type"].ToString().Trim() == "4")
					{
						objContract.AccountType = LibertyPower.Business.CustomerAcquisition.ProductManagement.AccountType.Soho;
					}
				}

				objContract.ContractRateType = dsRecord.Tables[0].Rows[0]["contract_rate_type"].ToString().Trim();
                if (!dsRecord.Tables[0].Rows[0]["product_id"].ToString().Trim().Contains( "NONE" ))
					objContract.Product = ProductManagement.ProductFactory.CreateProduct( dsRecord.Tables[0].Rows[0]["product_id"].ToString().Trim() );
				objContract.DateDeal = Convert.ToDateTime( dsRecord.Tables[0].Rows[0]["date_deal"] );
				objContract.DateSubmit = Convert.ToDateTime( dsRecord.Tables[0].Rows[0]["date_submit"] );
				objContract.TermMonths = Convert.ToInt32( dsRecord.Tables[0].Rows[0]["term_months"] );
				objContract.RateId = Convert.ToInt32( dsRecord.Tables[0].Rows[0]["rate_id"] );
				objContract.Rate = Convert.ToDecimal( dsRecord.Tables[0].Rows[0]["rate"] );
				objContract.EnrollmentType = Convert.ToInt32( dsRecord.Tables[0].Rows[0]["enrollment_type"] );
				objContract.HeaderEnrollment1 = dsRecord.Tables[0].Rows[0]["header_enrollment_1"].ToString().Trim();
				objContract.HeaderEnrollment2 = dsRecord.Tables[0].Rows[0]["header_enrollment_2"].ToString().Trim();
				objContract.ContractType = dsRecord.Tables[0].Rows[0]["contract_type"].ToString().Trim();
				objContract.Username = UserFactory.GetUserByLogin( dsRecord.Tables[0].Rows[0]["username"].ToString().Trim() );
				objContract.ProductBrandID = dsRecord.Tables[0].Rows[0]["ProductBrandID"] == DBNull.Value ? 0 : Convert.ToInt32( dsRecord.Tables[0].Rows[0]["ProductBrandID"] );
				objContract.PriceID = dsRecord.Tables[0].Rows[0]["PriceID"] == DBNull.Value ? 0 : Convert.ToInt64( dsRecord.Tables[0].Rows[0]["PriceID"] );
				objContract.PriceTier = dsRecord.Tables[0].Rows[0]["PriceTier"] == DBNull.Value ? 0 : Convert.ToInt32( dsRecord.Tables[0].Rows[0]["PriceTier"] );
				objContract.EstimatedAnnualUsage = estimatedAnnualUsage;

				int taxStatus = dsRecord.Tables[0].Rows[0]["TaxExempt"] == DBNull.Value ? 0 : Convert.ToInt32( dsRecord.Tables[0].Rows[0]["TaxExempt"] );
				objContract.TaxExempt = taxStatus;
			}
			return objContract;
		}
		public static DataSet GetRenewalContractAccountList( string username, string contractNumber, string accountNumber )
        {
			DataSet ds = DAL.ProspectManagementSqlDal.GetRenewalContractAccountList( username, contractNumber, accountNumber );
            return ds;
        }
		public static List<ProspectAccount> BuildProspectAccountsList( DataSet ds, ProspectContract contract )
        {
            List<ProspectAccount> lstAccount = new List<ProspectAccount>();
            foreach (DataRow dr in ds.Tables[ds.Tables.Count - 1].Rows)
            {
				ProspectAccount account = new ProspectAccount( dr["account_number"].ToString() );
                account.ContractNumber = contract.ContractNumber;
                account.ZoneCode = dr["zone"].ToString();
                //account.TransferRate = contract.Rate;
                account.Status = dr["status"].ToString();
                if (!dr["utility_id"].ToString().Trim().Contains( "NONE" ))
					account.Utility = MarketManagement.UtilityManagement.UtilityFactory.GetUtilityByCode( dr["utility_id"].ToString().Trim() );
                account.AccountName = dr["full_name"].ToString();

                if (dr["contract_type"].ToString().Trim().Contains( "PRE-PRINTED" ))
                    account.ContractType = "PAPER";
                else
                    account.ContractType = dr["contract_type"].ToString().Trim();

                account.AccountType = dr["account_type"].ToString().Trim();
                if (dr["account_type"] != DBNull.Value)
                {
                    if (dr["account_type"].ToString().Trim() == "3")
                    {
                        account.AccountType = LibertyPower.Business.CustomerAcquisition.ProductManagement.AccountType.Lci.ToString();
                    }
                    else if (dr["account_type"].ToString().Trim() == "1")
                    {
                        account.AccountType = LibertyPower.Business.CustomerAcquisition.ProductManagement.AccountType.Smb.ToString();
                    }
                    else if (dr["account_type"].ToString().Trim() == "2")
                    {
                        account.AccountType = LibertyPower.Business.CustomerAcquisition.ProductManagement.AccountType.Residential.ToString();
                    }
                    else if (dr["account_type"].ToString().Trim() == "4")
                    {
                        account.AccountType = LibertyPower.Business.CustomerAcquisition.ProductManagement.AccountType.Soho.ToString();
                    }
                }

                if (!String.IsNullOrEmpty( dr["requested_flow_start_date"].ToString() ))
					account.RequestedFlowStartDate = Convert.ToDateTime( dr["requested_flow_start_date"] );

				account.EnrollmentType = Convert.ToInt32( dr["enrollment_type"] );
				account.Rate = Convert.ToDecimal( dr["rate"] );
				account.RateId = Convert.ToInt32( dr["rate_id"] );
				account.CustomerNameLink = Convert.ToInt32( dr["customer_name_link"] );
				account.CustomerAddressLink = Convert.ToInt32( dr["customer_address_link"] );
				account.CustomerContactLink = Convert.ToInt32( dr["customer_contact_link"] );
				account.BillingAddressLink = Convert.ToInt32( dr["billing_address_link"] );
				account.BillingContactLink = Convert.ToInt32( dr["billing_contact_link"] );
				account.OwnerNameLink = Convert.ToInt32( dr["owner_name_link"] );
				account.ServiceAddressLink = Convert.ToInt32( dr["service_address_link"] );
				account.AccountNameLink = Convert.ToInt32( dr["account_name_link"] );
                account.MeterNumber = dr["meter_number"].ToString().Trim();
                account.Comment = dr["comment"].ToString().Trim();
				account.DateComment = Convert.ToDateTime( dr["date_comment"] );
                account.AdditionalIdNumber = dr["additional_id_nbr"].ToString().Trim();
                account.AdditionalIdNumberType = dr["additional_id_nbr_type"].ToString().Trim();
                account.SalesChannelRole = dr["sales_channel_role"].ToString().Trim();
                account.SalesRep = dr["sales_rep"].ToString().Trim();
				account.DateDeal = Convert.ToDateTime( dr["date_deal"].ToString().Trim() );

                account.CustomerFirstName = dr["first_name"].ToString().Trim();
                account.CustomerLastName = dr["last_name"].ToString().Trim();
                account.BillingFirstName = dr["BillingFirstName"].ToString().Trim();
                account.BillingLastName = dr["BillingLastName"].ToString().Trim();
                account.CustomerTitle = dr["title"].ToString().Trim();
                account.BillingTitle = dr["BillingTitle"].ToString().Trim();
                account.CustomerPhone = dr["phone"].ToString().Trim();
                account.CustomerFax = dr["fax"].ToString().Trim();
                account.CustomerEmail = dr["email"].ToString().Trim();
                account.BillingPhone = dr["BillingPhone"].ToString().Trim();
                account.BillingFax = dr["BillingFax"].ToString().Trim();
                account.BillingEmail = dr["BillingEmail"].ToString().Trim();
                account.CustomerName = dr["CustomerName"].ToString().Trim();
                account.OwnerName = dr["OwnerName"].ToString().Trim();
                account.AccountId = dr["account_id"].ToString().Trim();
				account.DateSubmit = Convert.ToDateTime( dr["date_submit"].ToString().Trim() );
                account.BusinessType = dr["business_type"].ToString().Trim();
                account.BusinessActivity = dr["business_activity"].ToString().Trim();
				account.EffStartDate = Convert.ToDateTime( dr["contract_eff_start_date"].ToString().Trim() );
				account.TermMonths = Convert.ToInt32( dr["term_months"].ToString().Trim() );
				account.DateEnd = Convert.ToDateTime( dr["date_end"].ToString().Trim() );
				account.DateCreated = Convert.ToDateTime( dr["date_created"].ToString().Trim() );
                account.Origin = dr["origin"].ToString().Trim();
                account.DealType = dr["deal_type"].ToString().Trim();
                account.CustomerCode = dr["customer_code"].ToString().Trim();
                account.CustomerGroup = dr["customer_group"].ToString().Trim();
                if (dr["SSNEncrypted"] != DBNull.Value)
                    account.SSNEncrypted = dr["SSNEncrypted"].ToString().Trim();
                else
                    account.SSNEncrypted = "";
                string taxStatus = dr["TaxStatus"].ToString().Trim();
                if (taxStatus == "1")
                    account.TaxStatus = "EXEMPT";
                else
                    account.TaxStatus = "FULL";



                account.CustomerAddress = dr["CustomerAddress"].ToString().Trim();
                account.CustomerSuite = dr["CustomerSuite"].ToString().Trim();
                account.CustomerState = dr["CustomerState"].ToString().Trim();
                account.CustomerZip = dr["CustomerZip"].ToString().Trim();
                account.CustomerCity = dr["CustomerCity"].ToString().Trim();

                account.BillingAddressStreet = dr["Billingaddress"].ToString().Trim();
                account.BillingSuite = dr["Billingsuite"].ToString().Trim();
                account.BillingState = dr["Billingstate"].ToString().Trim();
                account.BillingZip = dr["Billingzip"].ToString().Trim();
                account.BillingCity = dr["Billingcity"].ToString().Trim();

                account.ServiceAddressStreet = dr["address"].ToString().Trim();
                account.ServiceSuite = dr["suite"].ToString().Trim();
                account.ServiceState = dr["state"].ToString().Trim();
                account.ServiceZip = dr["zip"].ToString().Trim();
                account.ServiceCity = dr["city"].ToString().Trim();

                if (dr["contract_nbr_amend"] != DBNull.Value)
                    account.ContractAmendNumber = dr["contract_nbr_amend"].ToString().Trim();

                if (!dr["retail_mkt_id"].ToString().Trim().Contains( "NN" ))
					account.Market = MarketManagement.UtilityManagement.MarketFactory.GetRetailMarket( dr["retail_mkt_id"].ToString().Trim() );
                if (!dr["product_id"].ToString().Trim().Contains( "NONE" ))
					account.Product = ProductManagement.ProductFactory.CreateProduct( dr["product_id"].ToString().Trim() );

				account.PriceID = Convert.ToInt64( dr["PriceID"].ToString().Trim() );
                account.EstimatedAnnualUsage = contract.EstimatedAnnualUsage;

                if (account.Product.IsMultiTerm)
                {
					account.TransferRate = DailyPricing.DailyPricingFactory.GetMultiTermByPriceID( account.PriceID )[0].Price;
                }
                else
                {
					account.TransferRate = DailyPricing.DailyPricingFactory.GetPrice( account.PriceID ).Price;
                }

                if (dr.Table.Columns.Contains( "IsForSave" ))
                {
                    if (dr["IsForSave"] != DBNull.Value)
						account.IsForSave = Convert.ToBoolean( dr["IsForSave"] );
                    else
                        account.IsForSave = true;
                }
                else
                    account.IsForSave = true;

                if (dr["RatesString"] != DBNull.Value)
                {
                    account.RatesString = dr["RatesString"].ToString();
                }

                //removed By Lev Rosenblum due contract.Rate sometimes has a total value (commision+tranferrate)
                //account.TransferRate = contract.Rate; 
				lstAccount.Add( account );

            }
            return lstAccount;
        }
		public static List<ProspectAccount> FillRenewalContractAccounts( string username, ProspectContract contract )
        {
			DataSet ds = GetRenewalContractAccountList( username, contract.ContractNumber, "" );
			return BuildProspectAccountsList( ds, contract );
        }
		public static ProspectContract GetContractRenewalInfo( string username, string contractNumber, string accountNumber )
		{
			ProspectContract objContract = new ProspectContract();

			DataSet dsRecord = DAL.ProspectManagementSqlDal.GetContractRenewalInfo( username, contractNumber, accountNumber );

            if (dsRecord != null && dsRecord.Tables.Count > 0)
			{
				objContract.ContractNumber = dsRecord.Tables[0].Rows[0]["contract_nbr"].ToString().Trim();
				objContract.Status = dsRecord.Tables[0].Rows[0]["status"].ToString().Trim();
				objContract.Comment = dsRecord.Tables[0].Rows[0]["comment"].ToString().Trim();
				objContract.BusinessActivity = dsRecord.Tables[0].Rows[0]["business_activity"].ToString().Trim();
				objContract.BusinessType = dsRecord.Tables[0].Rows[0]["business_type"].ToString().Trim();
				objContract.AdditionalIdNumberType = dsRecord.Tables[0].Rows[0]["additional_id_nbr_type"].ToString().Trim();
				objContract.SalesChannelRole = dsRecord.Tables[0].Rows[0]["sales_channel_role"].ToString().Trim();

				objContract.ContractEffectiveStartDate = Convert.ToDateTime( dsRecord.Tables[0].Rows[0]["contract_eff_start_date"] );
				objContract.DateEnd = Convert.ToDateTime( dsRecord.Tables[0].Rows[0]["date_end"] );
				objContract.SalesRep = dsRecord.Tables[0].Rows[0]["sales_rep"].ToString().Trim();

                if (dsRecord.Tables[0].Rows[0]["sales_mgr"] != DBNull.Value)
					objContract.SalesManager = dsRecord.Tables[0].Rows[0]["sales_mgr"].ToString().Trim();
                if (dsRecord.Tables[0].Rows[0]["initial_pymt_option_id"] != DBNull.Value)
					objContract.InitialPymtOptionId = Convert.ToInt32( dsRecord.Tables[0].Rows[0]["initial_pymt_option_id"] );
                if (dsRecord.Tables[0].Rows[0]["residual_option_id"] != DBNull.Value)
					objContract.ResidualOptionId = Convert.ToInt32( dsRecord.Tables[0].Rows[0]["residual_option_id"] );
                if (dsRecord.Tables[0].Rows[0]["residual_commission_end"] != DBNull.Value)
					objContract.ResidualCommisionEnd = Convert.ToDateTime( dsRecord.Tables[0].Rows[0]["residual_commission_end"] );
                if (dsRecord.Tables[0].Rows[0]["evergreen_option_id"] != DBNull.Value)
					objContract.EvergreenOptionId = Convert.ToInt32( dsRecord.Tables[0].Rows[0]["evergreen_option_id"] );
                if (dsRecord.Tables[0].Rows[0]["evergreen_commission_end"] != DBNull.Value)
					objContract.EvergreenCommissionEnd = Convert.ToDateTime( dsRecord.Tables[0].Rows[0]["evergreen_commission_end"] );
                if (dsRecord.Tables[0].Rows[0]["evergreen_commission_rate"] != DBNull.Value)
					objContract.EvergreenCommisionRate = Convert.ToDouble( dsRecord.Tables[0].Rows[0]["evergreen_commission_rate"] );
				objContract.CustomerNameLink = Convert.ToInt32( dsRecord.Tables[0].Rows[0]["customer_name_link"] );
				objContract.CustomerName = dsRecord.Tables[0].Rows[0]["customer_name"].ToString().Trim();
				objContract.OwnerNameLink = Convert.ToInt32( dsRecord.Tables[0].Rows[0]["owner_name_link"] );
				objContract.OwnerName = dsRecord.Tables[0].Rows[0]["owner_name"].ToString().Trim();
				objContract.CustomerAddressLink = Convert.ToInt32( dsRecord.Tables[0].Rows[0]["customer_address_link"] );
				objContract.CustomerAddress = dsRecord.Tables[0].Rows[0]["customer_address"].ToString().Trim();
				objContract.CustomerSuite = dsRecord.Tables[0].Rows[0]["customer_suite"].ToString().Trim();
				objContract.CustomerCity = dsRecord.Tables[0].Rows[0]["customer_city"].ToString().Trim();
				objContract.CustomerZip = dsRecord.Tables[0].Rows[0]["customer_zip"].ToString().Trim();
				objContract.CustomerState = dsRecord.Tables[0].Rows[0]["customer_state"].ToString().Trim();
				objContract.ServiceAddressLink = Convert.ToInt32( dsRecord.Tables[0].Rows[0]["service_address_link"] );
				objContract.ServiceAddress = dsRecord.Tables[0].Rows[0]["service_address"].ToString().Trim();
				objContract.ServiceSuite = dsRecord.Tables[0].Rows[0]["service_suite"].ToString().Trim();
				objContract.ServiceCity = dsRecord.Tables[0].Rows[0]["service_city"].ToString().Trim();
				objContract.ServiceZip = dsRecord.Tables[0].Rows[0]["service_zip"].ToString().Trim();
				objContract.ServiceState = dsRecord.Tables[0].Rows[0]["service_state"].ToString().Trim();
				objContract.BillingAddressLink = Convert.ToInt32( dsRecord.Tables[0].Rows[0]["billing_address_link"] );
				objContract.BillingAddress = dsRecord.Tables[0].Rows[0]["billing_address"].ToString().Trim();
				objContract.BillingSuite = dsRecord.Tables[0].Rows[0]["billing_suite"].ToString().Trim();
				objContract.BillingCity = dsRecord.Tables[0].Rows[0]["billing_city"].ToString().Trim();
				objContract.BillingZip = dsRecord.Tables[0].Rows[0]["billing_zip"].ToString().Trim();
				objContract.BillingState = dsRecord.Tables[0].Rows[0]["billing_state"].ToString().Trim();
				objContract.CustomerContactLink = Convert.ToInt32( dsRecord.Tables[0].Rows[0]["customer_contact_link"] );
				objContract.CustomerFirstName = dsRecord.Tables[0].Rows[0]["customer_first_name"].ToString().Trim();
				objContract.CustomerLastName = dsRecord.Tables[0].Rows[0]["customer_last_name"].ToString().Trim();
				objContract.CustomerTitle = dsRecord.Tables[0].Rows[0]["customer_title"].ToString().Trim();
				objContract.CustomerPhone = dsRecord.Tables[0].Rows[0]["customer_phone"].ToString().Trim();
				objContract.CustomerFax = dsRecord.Tables[0].Rows[0]["customer_fax"].ToString().Trim();
				objContract.CustomerEmail = dsRecord.Tables[0].Rows[0]["customer_email"].ToString().Trim();
				objContract.CustomerBirthday = dsRecord.Tables[0].Rows[0]["customer_birthday"].ToString().Trim();
				objContract.BillingContactLink = Convert.ToInt32( dsRecord.Tables[0].Rows[0]["billing_contact_link"] );
				objContract.BillingFirstName = dsRecord.Tables[0].Rows[0]["billing_first_name"].ToString().Trim();
				objContract.BillingLastName = dsRecord.Tables[0].Rows[0]["billing_last_name"].ToString().Trim();
				objContract.BillingTitle = dsRecord.Tables[0].Rows[0]["billing_title"].ToString().Trim();
				objContract.BillingPhone = dsRecord.Tables[0].Rows[0]["billing_phone"].ToString().Trim();
				objContract.BillingFax = dsRecord.Tables[0].Rows[0]["billing_fax"].ToString().Trim();
				objContract.BillingEmail = dsRecord.Tables[0].Rows[0]["billing_email"].ToString().Trim();
				objContract.BillingBirthday = dsRecord.Tables[0].Rows[0]["billing_birthday"].ToString().Trim();
                if (!dsRecord.Tables[0].Rows[0]["retail_mkt_id"].ToString().Trim().Contains( "NN" ))
					objContract.Market = MarketManagement.UtilityManagement.MarketFactory.GetRetailMarket( dsRecord.Tables[0].Rows[0]["retail_mkt_id"].ToString().Trim() );
                if (!dsRecord.Tables[0].Rows[0]["utility_id"].ToString().Trim().Contains( "NONE" ))
					objContract.Utility = MarketManagement.UtilityManagement.UtilityFactory.GetUtilityByCode( dsRecord.Tables[0].Rows[0]["utility_id"].ToString().Trim() );
				objContract.SSNEncrypted = dsRecord.Tables[0].Rows[0]["SSNEncrypted"].ToString().Trim();
				objContract.AdditionalIdNumber = dsRecord.Tables[0].Rows[0]["additional_id_nbr"].ToString().Trim();
                if (dsRecord.Tables[0].Rows[0]["account_type"] != DBNull.Value)
				{
                    if (dsRecord.Tables[0].Rows[0]["account_type"].ToString().Trim() == "3")
					{
						objContract.AccountType = LibertyPower.Business.CustomerAcquisition.ProductManagement.AccountType.Lci;
					}
                    else if (dsRecord.Tables[0].Rows[0]["account_type"].ToString().Trim() == "1")
					{
						objContract.AccountType = LibertyPower.Business.CustomerAcquisition.ProductManagement.AccountType.Smb;
					}
                    else if (dsRecord.Tables[0].Rows[0]["account_type"].ToString().Trim() == "2")
					{
						objContract.AccountType = LibertyPower.Business.CustomerAcquisition.ProductManagement.AccountType.Residential;
					}
                    else if (dsRecord.Tables[0].Rows[0]["account_type"].ToString().Trim() == "4")
					{
						objContract.AccountType = LibertyPower.Business.CustomerAcquisition.ProductManagement.AccountType.Soho;
					}
				}

                if (!dsRecord.Tables[0].Rows[0]["product_id"].ToString().Trim().Contains( "NONE" ))
					objContract.Product = ProductManagement.ProductFactory.CreateProduct( dsRecord.Tables[0].Rows[0]["product_id"].ToString().Trim(), false );
				objContract.DateDeal = Convert.ToDateTime( dsRecord.Tables[0].Rows[0]["date_deal"] );
				objContract.DateSubmit = Convert.ToDateTime( dsRecord.Tables[0].Rows[0]["date_submit"] );
				objContract.TermMonths = Convert.ToInt32( dsRecord.Tables[0].Rows[0]["term_months"] );
				objContract.RateId = Convert.ToInt32( dsRecord.Tables[0].Rows[0]["rate_id"] );
				objContract.Rate = Convert.ToDecimal( dsRecord.Tables[0].Rows[0]["rate"] );
				objContract.Username = UserFactory.GetUserByLogin( dsRecord.Tables[0].Rows[0]["username"].ToString().Trim() );
				objContract.ProductBrandID = dsRecord.Tables[0].Rows[0]["ProductBrandID"] == DBNull.Value ? 0 : Convert.ToInt32( dsRecord.Tables[0].Rows[0]["ProductBrandID"] );
				objContract.PriceID = dsRecord.Tables[0].Rows[0]["PriceID"] == DBNull.Value ? 0 : Convert.ToInt64( dsRecord.Tables[0].Rows[0]["PriceID"] );
				objContract.PriceTier = dsRecord.Tables[0].Rows[0]["PriceTier"] == DBNull.Value ? 0 : Convert.ToInt32( dsRecord.Tables[0].Rows[0]["PriceTier"] );
			}
			return objContract;
		}

		public static bool DeleteContractAccount( string username, string contractNumber, string accountNumber, out string errorMessage )
		{
			bool success = true;
			DataSet ds = null;
			errorMessage = "No errors found.";
			// Do some simple data validation:
            if (string.IsNullOrEmpty( contractNumber ) || contractNumber.Trim().Length <= 0)
			{
				errorMessage = "Invalid Contract #";
				success = false;
			}

            if (string.IsNullOrEmpty( username ) || username.Trim().Length <= 0)
			{
				errorMessage = "Invalid Username #";
				success = false;
			}

            if (success)
			{
				ds = DAL.ProspectManagementSqlDal.DeleteContractAccount( username, contractNumber, accountNumber );

                if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
				{
                    if (ds.Tables[0].Rows[0][0].ToString().Equals( "E" ))
					{
						errorMessage = ds.Tables[0].Rows[0][2].ToString();
						success = false;
					}
					else
					{
						errorMessage = ds.Tables[0].Rows[0][2].ToString();
						success = true;
					}
				}
				else
				{
					success = false;
				}
			}

			return success;
		}

		public static bool DeleteContractAllAccounts( string username, string contractNumber, out string errorMessage )
		{
			bool success = true;
			DataSet ds = null;
			errorMessage = "No errors found.";
			// Do some simple data validation:
            if (string.IsNullOrEmpty( contractNumber ) || contractNumber.Trim().Length <= 0)
			{
				errorMessage = "Invalid Contract #";
				success = false;
			}

            if (string.IsNullOrEmpty( username ) || username.Trim().Length <= 0)
			{
				errorMessage = "Invalid Username #";
				success = false;
			}

            if (success)
			{
				ds = DAL.ProspectManagementSqlDal.DeleteContractAllAccounts( username, contractNumber );

                if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
				{
                    if (ds.Tables[0].Rows[0][0].ToString().Equals( "E" ))
					{
						errorMessage = ds.Tables[0].Rows[0][2].ToString();
						success = false;
					}
					else
					{
						errorMessage = ds.Tables[0].Rows[0][2].ToString();
						success = true;
					}
				}
				else
				{
					success = false;
				}
			}

			return success;
		}
		public static void UpdateAccountFlowDates( string contractNumber, int newMonth )
		{

			DAL.ProspectManagementSqlDal.UpdateAccountFlowDates( contractNumber, newMonth );
		}

		public static void OverrideAccountContractRates( string username, string contractNumber, string accountNumber, string rates )
		{
			DAL.ProspectManagementSqlDal.OverrideAccountContractRates( username, contractNumber, accountNumber, rates );
		}

        //Added isRowSelectedforSave field for sending them to the LP.
        //July 16 2013 IT 121- PBI14205
        //Bug 23903 - NEW DEAL: Move In date is not saving for TX deals --EnrollmentType Added Oct 25 2013
		public static bool UpdateContractAccount( string username, string contractNumber, string fullName, string address,
			string suite, string city, string state, string zip, string firstName, string lastName, string phoneNumber,
			string billingAddress, string billingSuite, string billingCity, string billingState, string billingZip, string accountNumber,
			string newAccountNumber, string zone, out string errorMessage, bool isRowSelectedforSave = true, string reqFlowStartDate = "", int enrollmentType = 1 )
		{
			bool success = true;
			DataSet ds = null;
			errorMessage = "No errors found.";
			// Do some simple data validation:
            if (string.IsNullOrEmpty( contractNumber ) || contractNumber.Trim().Length <= 0)
			{
				errorMessage = "Invalid Contract #";
				success = false;
			}

            if (string.IsNullOrEmpty( username ) || username.Trim().Length <= 0)
			{
				errorMessage = "Invalid Username #";
				success = false;
			}

            if (success)
			{
                //Added isRowSelectedforSave field for sending them to the LP.
                //July 16 2013 IT 121- PBI14205
                //Added requested Flow Start date on Aug 19
                //Bug 23903 - NEW DEAL: Move In date is not saving for TX deals --EnrollmentType Added Oct 25 2013
				ds = DAL.ProspectManagementSqlDal.UpdateContractAccount( username, contractNumber, fullName, address, suite, city, state,
					zip, firstName, lastName, phoneNumber, billingAddress, billingSuite, billingCity, billingState, billingZip, accountNumber, newAccountNumber, zone, isRowSelectedforSave, reqFlowStartDate, enrollmentType );

                if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
				{
                    if (ds.Tables[0].Rows[0][0].ToString().Equals( "E" ))
					{
						errorMessage = ds.Tables[0].Rows[0][2].ToString();
						success = false;
					}
					else
					{
						errorMessage = ds.Tables[0].Rows[0][2].ToString();
						success = true;
					}
				}
				else
				{
					success = false;
				}
			}

			return success;
		}

		public static DataSet GetContractAccountList( string username, string contractNumber, string accountNumber )
		{
			DataSet ds = DAL.ProspectManagementSqlDal.GetContractAccountList( username, contractNumber, accountNumber );
            //Commented due to circular reference Aug 23 2013
//            //Add the minStartDate for each account
//          if( ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0 )
//            {
//                ds.Tables[0].Columns.Add("MinRenewalStartDate",typeof(System.DateTime));
//                ds.AcceptChanges();
//                foreach (DataRow dr in ds.Tables[0].Rows)
//                {
//                    DateTime? MinRenStartDate=null;
//                    try
//                    {
//                        MinRenStartDate = GetMinRenewalStartDate(dr["account_number"].ToString(), dr["utility_id"].ToString());
//                        dr["MinRenewalStartDate"] = MinRenStartDate;
//                    }
//                    catch
//                    {
////If a new account is added then we cannot find the min renewal startdate
//                    }
                  
//                }
//                ds.AcceptChanges();
//            }


			return ds;
		}

        //public static DateTime GetMinRenewalStartDate(string accountNumber,string utilityCode)
        //{
        //    LibertyPower.Business.CustomerManagement.AccountManagement.CompanyAccount ca = null;

        //    ca = LibertyPower.Business.CustomerManagement.AccountManagement.CompanyAccountFactory.GetCompanyAccount(accountNumber, utilityCode);
        //    return ca.MinimumAccountRenewalStartDate;

        //}

		public static DataSet GetProspectRenewalContract( string contractNumber )
		{
			DataSet ds = DAL.ProspectManagementSqlDal.GetProspectRenewalContract( contractNumber );
			return ds;
		}

		public static DataSet GetProspectRenewalContractAccount( string contractNumber, string accountNumber )
		{
			DataSet ds = DAL.ProspectManagementSqlDal.GetProspectRenewalContractAccount( contractNumber, accountNumber );
			return ds;
		}

		public static List<ProspectAccount> FillContractAccounts( string username, ProspectContract contract, string contractNumberToUseForSearch )
		{
			DataSet ds = GetContractAccountList( username, contractNumberToUseForSearch, "" );
			List<ProspectAccount> lstAccount = new List<ProspectAccount>();
            foreach (DataRow dr in ds.Tables[ds.Tables.Count - 1].Rows)
			{
				ProspectAccount account = new ProspectAccount( dr["account_number"].ToString() );
				account.ContractNumber = contract.ContractNumber;
				account.ZoneCode = dr["zone"].ToString();
				//account.TransferRate = contract.Rate;
				account.Status = dr["status"].ToString();
                if (!dr["utility_id"].ToString().Trim().Contains( "NONE" ))
					account.Utility = MarketManagement.UtilityManagement.UtilityFactory.GetUtilityByCode( dr["utility_id"].ToString().Trim() );
				account.AccountName = dr["full_name"].ToString();

                if (dr["contract_type"].ToString().Trim().Contains( "PRE-PRINTED" ))
					account.ContractType = "PAPER";
				else
					account.ContractType = dr["contract_type"].ToString().Trim();

				account.AccountType = dr["account_type"].ToString().Trim();
                if (dr["account_type"] != DBNull.Value)
				{
                    if (dr["account_type"].ToString().Trim() == "3")
					{
						account.AccountType = LibertyPower.Business.CustomerAcquisition.ProductManagement.AccountType.Lci.ToString();
					}
                    else if (dr["account_type"].ToString().Trim() == "1")
					{
						account.AccountType = LibertyPower.Business.CustomerAcquisition.ProductManagement.AccountType.Smb.ToString();
					}
                    else if (dr["account_type"].ToString().Trim() == "2")
					{
						account.AccountType = LibertyPower.Business.CustomerAcquisition.ProductManagement.AccountType.Residential.ToString();
					}
                    else if (dr["account_type"].ToString().Trim() == "4")
					{
						account.AccountType = LibertyPower.Business.CustomerAcquisition.ProductManagement.AccountType.Soho.ToString();
					}
				}
                //default requested flow start date added
                //Aug 15 2013
                if (dr["requested_flow_start_date"] != DBNull.Value)
				account.RequestedFlowStartDate = Convert.ToDateTime( dr["requested_flow_start_date"] );
                else
                    account.RequestedFlowStartDate = contract.RequestedFlowStartDate;

				account.EnrollmentType = Convert.ToInt32( dr["enrollment_type"] );
				account.Rate = Convert.ToDecimal( dr["rate"] );
				account.RateId = Convert.ToInt32( dr["rate_id"] );
				account.CustomerNameLink = Convert.ToInt32( dr["customer_name_link"] );
				account.CustomerAddressLink = Convert.ToInt32( dr["customer_address_link"] );
				account.CustomerContactLink = Convert.ToInt32( dr["customer_contact_link"] );
				account.BillingAddressLink = Convert.ToInt32( dr["billing_address_link"] );
				account.BillingContactLink = Convert.ToInt32( dr["billing_contact_link"] );
				account.OwnerNameLink = Convert.ToInt32( dr["owner_name_link"] );
				account.ServiceAddressLink = Convert.ToInt32( dr["service_address_link"] );
				account.AccountNameLink = Convert.ToInt32( dr["account_name_link"] );
				account.MeterNumber = dr["meter_number"].ToString().Trim();
				account.Comment = dr["comment"].ToString().Trim();
				account.DateComment = Convert.ToDateTime( dr["date_comment"] );
				account.AdditionalIdNumber = dr["additional_id_nbr"].ToString().Trim();
				account.AdditionalIdNumberType = dr["additional_id_nbr_type"].ToString().Trim();
				account.SalesChannelRole = dr["sales_channel_role"].ToString().Trim();
				account.SalesRep = dr["sales_rep"].ToString().Trim();
				account.DateDeal = Convert.ToDateTime( dr["date_deal"].ToString().Trim() );

				account.CustomerFirstName = dr["first_name"].ToString().Trim();
				account.CustomerLastName = dr["last_name"].ToString().Trim();
				account.BillingFirstName = dr["BillingFirstName"].ToString().Trim();
				account.BillingLastName = dr["BillingLastName"].ToString().Trim();
				account.CustomerTitle = dr["title"].ToString().Trim();
				account.BillingTitle = dr["BillingTitle"].ToString().Trim();
				account.CustomerPhone = dr["phone"].ToString().Trim();
				account.CustomerFax = dr["fax"].ToString().Trim();
				account.CustomerEmail = dr["email"].ToString().Trim();
				account.BillingPhone = dr["BillingPhone"].ToString().Trim();
				account.BillingFax = dr["BillingFax"].ToString().Trim();
				account.BillingEmail = dr["BillingEmail"].ToString().Trim();
				account.CustomerName = dr["CustomerName"].ToString().Trim();
				account.OwnerName = dr["OwnerName"].ToString().Trim();
				account.AccountId = dr["account_id"].ToString().Trim();
				account.DateSubmit = Convert.ToDateTime( dr["date_submit"].ToString().Trim() );
				account.BusinessType = dr["business_type"].ToString().Trim();
				account.BusinessActivity = dr["business_activity"].ToString().Trim();
				account.EffStartDate = Convert.ToDateTime( dr["contract_eff_start_date"].ToString().Trim() );
				account.TermMonths = Convert.ToInt32( dr["term_months"].ToString().Trim() );
				account.DateEnd = Convert.ToDateTime( dr["date_end"].ToString().Trim() );
				account.DateCreated = Convert.ToDateTime( dr["date_created"].ToString().Trim() );
				account.Origin = dr["origin"].ToString().Trim();
				account.DealType = dr["deal_type"].ToString().Trim();
				account.CustomerCode = dr["customer_code"].ToString().Trim();
				account.CustomerGroup = dr["customer_group"].ToString().Trim();
                if (dr["SSNEncrypted"] != DBNull.Value)
					account.SSNEncrypted = dr["SSNEncrypted"].ToString().Trim();
				else
					account.SSNEncrypted = "";
				string taxStatus = dr["TaxStatus"].ToString().Trim();
                if (taxStatus == "1")
					account.TaxStatus = "EXEMPT";
				else
					account.TaxStatus = "FULL";



				account.CustomerAddress = dr["CustomerAddress"].ToString().Trim();
				account.CustomerSuite = dr["CustomerSuite"].ToString().Trim();
				account.CustomerState = dr["CustomerState"].ToString().Trim();
				account.CustomerZip = dr["CustomerZip"].ToString().Trim();
				account.CustomerCity = dr["CustomerCity"].ToString().Trim();

				account.BillingAddressStreet = dr["Billingaddress"].ToString().Trim();
				account.BillingSuite = dr["Billingsuite"].ToString().Trim();
				account.BillingState = dr["Billingstate"].ToString().Trim();
				account.BillingZip = dr["Billingzip"].ToString().Trim();
				account.BillingCity = dr["Billingcity"].ToString().Trim();

				account.ServiceAddressStreet = dr["address"].ToString().Trim();
				account.ServiceSuite = dr["suite"].ToString().Trim();
				account.ServiceState = dr["state"].ToString().Trim();
				account.ServiceZip = dr["zip"].ToString().Trim();
				account.ServiceCity = dr["city"].ToString().Trim();

                if (dr["contract_nbr_amend"] != DBNull.Value)
					account.ContractAmendNumber = dr["contract_nbr_amend"].ToString().Trim();

                if (!dr["retail_mkt_id"].ToString().Trim().Contains( "NN" ))
					account.Market = MarketManagement.UtilityManagement.MarketFactory.GetRetailMarket( dr["retail_mkt_id"].ToString().Trim() );
                if (!dr["product_id"].ToString().Trim().Contains( "NONE" ))
					account.Product = ProductManagement.ProductFactory.CreateProduct( dr["product_id"].ToString().Trim() );

                if (dr["PriceID"].ToString().Trim() != "")
                {
                    account.PriceID = Convert.ToInt64(dr["PriceID"].ToString().Trim());
                }
                else
                {
                    throw new Exception("Price not found for account #" + account.AccountNumber);
                }
				account.EstimatedAnnualUsage = contract.EstimatedAnnualUsage;

				if (account.Product.IsMultiTerm)
				{
					account.TransferRate = DailyPricing.DailyPricingFactory.GetMultiTermByPriceID( account.PriceID )[0].Price;
				}
				else
				{
					account.TransferRate = DailyPricing.DailyPricingFactory.GetPrice( account.PriceID ).Price;
				}

                //This was  removed for contract prepolutation, as the contract prepopulation didn't have the field ISFORSAVE.
                //This code has to be there so that we don't always default the IsFORSAVE to true
                //So, added the validation to check for the existence of the field 
                //NOv 15 2013
                if (dr.Table.Columns.Contains( "IsForSave" ))
                {
                if (dr["IsForSave"] != DBNull.Value)
                    {
						account.IsForSave = Convert.ToBoolean( dr["IsForSave"] );
                    }
                    else
					{
                        account.IsForSave = true;
                }  
				}
                else
                {
                    account.IsForSave = true;
                }
                if (dr["RatesString"] != DBNull.Value)
				{
					account.RatesString = dr["RatesString"].ToString();
				}

				//removed By Lev Rosenblum due contract.Rate sometimes has a total value (commision+tranferrate)
				//account.TransferRate = contract.Rate; 
				lstAccount.Add( account );

			}
			return lstAccount;
		}

		public static List<ProspectAccount> FillContractAccounts( string username, ProspectContract contract )
		{
			return FillContractAccounts( username, contract, contract.ContractNumber );
		}

		public static FileParserResult ParseFile( Stream file, string fileName, bool saveIfValid, int userId )
		{
			ProspectFileParser fileParser = new ProspectFileParser( file, fileName );
			FileParserResult result = new FileParserResult();
			result.ItemCollection = file;
			fileParser.UserId = userId;
			fileParser.SaveToPermanentStorage = saveIfValid;
			return fileParser.ParseFile();
		}

        //Raju- Added this new method for Contract Pre Population Tool
		public static FileParserResult ContractPrepopulateParseFile( Stream file, string fileName, bool saveIfValid, int userId )
        {
			ContractPrepopulateFileParser fileParser = new ContractPrepopulateFileParser( file, fileName );
            FileParserResult result = new FileParserResult();
            result.ItemCollection = file;
            fileParser.UserId = userId;
            fileParser.SaveToPermanentStorage = saveIfValid;
            return fileParser.ParseFile();
        }

		public static List<ProspectContract> MountProspectContractFromExcel( DataSet ds, int userId )
		{
			List<ProspectContract> lstContract = new List<ProspectContract>();
			Dictionary<string, string> dic = new Dictionary<string, string>();

			Dictionary<string, string> States = ProspectContractFactory.GetStatesDropDown( "libertypower\\tnogueira" );
			System.Text.RegularExpressions.Regex regex = new System.Text.RegularExpressions.Regex( "^[0-9]+$" );

			string contractNbr = "";
			int contractNbrColumnIdx = 1;
			User user = UserFactory.GetUser( userId );

            for (int i = 1; i < ds.Tables[0].Rows.Count; i++)
			{
				ProspectAccount account = new ProspectAccount( ds.Tables[0].Rows[i][2].ToString() );

                if (ds.Tables[0].Rows[i][contractNbrColumnIdx].ToString().ToUpper().Contains( "PRINT" ))
				{
                    if (dic.ContainsKey( ds.Tables[0].Rows[i][contractNbrColumnIdx].ToString().ToUpper() ))
					{
						contractNbr = dic[ds.Tables[0].Rows[i][contractNbrColumnIdx].ToString().ToUpper()];
					}
					else
					{
						contractNbr = GenerateContractNumber( "libertypower\\dlima" );
						dic.Add( ds.Tables[0].Rows[i][contractNbrColumnIdx].ToString().ToUpper(), contractNbr );
					}
				}
				else
				{
					contractNbr = ds.Tables[0].Rows[i][contractNbrColumnIdx].ToString();
				}

				account.ContractNumber = contractNbr;

				account.ContractType = ds.Tables[0].Rows[i][36].ToString().Trim().ToUpper();

                if (account.ContractType.ToUpper().Contains( "PAPER" ))
				{
					//as part of MD084, the business decided to not support paper contracts in batch upload anymore
					continue;
				}

				ProspectContract contract = lstContract.Find( delegate( ProspectContract pc ) { return pc.ContractNumber == account.ContractNumber; }
					);

				//ContractNumber	AccountNumber	AccountName	ServiceStreet	ServiceSuite	ServiceCity	ServiceState	
				//ServiceZip	ServiceZipPlus4	BillingStreet	BillingSuite	BillingCity	BillingState	BillingZip	BillingZipPlus4	
				//ContactFirstName	ContactLastName	ContactPhoneNumber	Meter Number	Name Key	Billing Account	MDMA	MSP	
				//Meter Installer	Meter Reader	Schedule Coordinator	SalesChannel	Market	Utility	AccountType	EffectiveStartDate	
				//ContractDate	Term	TransferRate	ContractRate
				account.AccountId = DAL.ProspectManagementSqlDal.GetNewAccountId( user.Username );
				account.AccountName = ds.Tables[0].Rows[i][3].ToString().Trim();
				account.ServiceAddressStreet = ds.Tables[0].Rows[i][4].ToString().Trim();
				account.ServiceSuite = ds.Tables[0].Rows[i][5].ToString().Trim();
				account.ServiceCity = ds.Tables[0].Rows[i][6].ToString().Trim();
				account.ServiceState = ds.Tables[0].Rows[i][7].ToString().Trim();
				account.ServiceZip = ds.Tables[0].Rows[i][8].ToString().Trim() + ds.Tables[0].Rows[i][9].ToString().Trim();
				//+ServiceZipPlus4
				account.BillingAddressStreet = ds.Tables[0].Rows[i][10].ToString().Trim();
				account.BillingSuite = ds.Tables[0].Rows[i][11].ToString().Trim();
				account.BillingCity = ds.Tables[0].Rows[i][12].ToString().Trim();
				account.BillingState = ds.Tables[0].Rows[i][13].ToString().Trim();
				account.BillingZip = ds.Tables[0].Rows[i][14].ToString().Trim() + ds.Tables[0].Rows[i][15].ToString().Trim();
				//+BillingZipPlus4
				account.BillingFirstName = ds.Tables[0].Rows[i][16].ToString().Trim();
				account.BillingLastName = ds.Tables[0].Rows[i][17].ToString().Trim();
				account.BillingPhone = ds.Tables[0].Rows[i][18].ToString().Trim();
				account.MeterNumber = ds.Tables[0].Rows[i][19].ToString().Trim();
				account.NameKey = ds.Tables[0].Rows[i][20].ToString().Trim();
                account.CustomerCode = ds.Tables[0].Rows[i][20].ToString().Trim();
				account.BillingAccount = ds.Tables[0].Rows[i][21].ToString().Trim();
				account.MDMA = ds.Tables[0].Rows[i][22].ToString().Trim();
				account.MSP = ds.Tables[0].Rows[i][23].ToString().Trim();
				account.MeterInstaller = ds.Tables[0].Rows[i][24].ToString().Trim();
				account.MeterReader = ds.Tables[0].Rows[i][25].ToString().Trim();
				account.ScheduleCoordinator = ds.Tables[0].Rows[i][26].ToString().Trim();
				account.SalesChannelRole = "Sales Channel/" + ds.Tables[0].Rows[i][27].ToString().Trim().Replace( "Sales Channel/", "" );
				account.Market = MarketManagement.UtilityManagement.MarketFactory.GetRetailMarket( ds.Tables[0].Rows[i][28].ToString().Trim().ToUpper() );

                if (account.Market == null)
				{
					throw new Exception( "Market not found:" + ds.Tables[0].Rows[i][28].ToString().Trim().ToUpper() );
				}

				account.Utility = MarketManagement.UtilityManagement.UtilityFactory.GetUtilityByCode( ds.Tables[0].Rows[i][29].ToString().Trim().ToUpper() );

                if (account.Utility == null)
                {
                    throw new Exception("Utility not found:" + ds.Tables[0].Rows[i][29].ToString().Trim().ToUpper());
                }
                else
                {
                    var reqData = UtilityRequiredData.GetUtilityRequiredDataByUtility(account.Utility.ToString());

                    if (reqData.Tables[0].Rows.Count > 0)
                    {
                        for (int reqDataCount = 0; reqData.Tables[0].Rows.Count > reqDataCount; reqDataCount++)
                        {
                            if (reqData.Tables[0].Rows[reqDataCount]["account_info_field"].ToString() == "BillingAccount" && account.BillingAccount.Trim().Length == 0)
                            {
                                throw new Exception("BillingAccount not found");
                            }
                        }
                    }
                }

				account.AccountType = ds.Tables[0].Rows[i][30].ToString().Trim().ToUpper();
				//account.EffStartDate = Convert.ToDateTime(ds.Tables[0].Rows[i][31].ToString().Trim());
				bool isSucceeded = false;
				isSucceeded = DateParsing.ParseDate( ds.Tables[0].Rows[i][31].ToString().Trim(), out account.EffStartDate );
				if (isSucceeded)
				{ account.RequestedFlowStartDate = account.EffStartDate; }
				else
				{
					throw new Exception( "EffStartDate is not in correct format" );
				}
				//account.DateDeal = Convert.ToDateTime(ds.Tables[0].Rows[i][32].ToString().Trim());
				isSucceeded = DateParsing.ParseDate( ds.Tables[0].Rows[i][32].ToString().Trim(), out account.DateDeal );
				if (!isSucceeded)
				{ throw new Exception( "DealDate is not in correct format" ); }
				account.TermMonths = Convert.ToInt32( ds.Tables[0].Rows[i][33].ToString().Trim() );
				account.TransferRate = Convert.ToDecimal( ds.Tables[0].Rows[i][34].ToString().Trim() );
				account.Rate = Convert.ToDecimal( ds.Tables[0].Rows[i][35].ToString().Trim() );

				account.Tier = ds.Tables[0].Rows[i][46].ToString().Trim().ToUpper();
                account.Email = ds.Tables[0].Rows[i][47].ToString().Trim().ToUpper();
                account.PromoCode = ds.Tables[0].Rows[i][48].ToString().Trim();
				string productType = ds.Tables[0].Rows[i][40].ToString().Trim().ToUpper();
				string serviceClass = ds.Tables[0].Rows[i][41].ToString().Trim().ToUpper();
				string zone = ds.Tables[0].Rows[i][42].ToString().Trim().ToUpper();
				int rateId = -1;

				try
				{
					Int64 priceId = -1;
					int brandId = -1;
					int flex = -1;
					bool isCustomChecked = false;
					string productId = null;

					string channelName = ds.Tables[0].Rows[i][27].ToString().Trim().Replace( "Sales Channel/", "" );
					string accountType = (account.AccountType == "RESIDENTIAL") ? "RES" : account.AccountType;
					sc.SalesChannel slChnl = SalesChannelFactory.GetSalesChannel( channelName );
					int accountTypeId = ConfigurationFactory.GetSegment( accountType ).Identity;

					PriceTier priceTier = CacheManager.GetPriceTier( account.Tier );

                    if (priceTier != null)
					{
						//First try to match the rate against the custom rates, if a match is found, then the rate is a custom rate
                        if (priceTier.PriceTierID == 0) //no Tier pricing
						{
							DailyPricingFactory.GetCustomRateIdAndPriceId( slChnl, account.EffStartDate, account.DateDeal, account.Utility.RetailMarketCode, account.Utility.Code, account.ContractType, account.AccountType, account.TermMonths, account.TransferRate, out rateId, out priceId, out productId );
							isCustomChecked = true;
						}

						//check for a priceID in case we didnt find a custom rate or in case we didnt check the custom rate
                        if ((isCustomChecked && priceId == -1) || !isCustomChecked)
						{
                            if (!string.IsNullOrEmpty( productType ) && productType.Trim().ToUpper() == "MULTI-TERM")
							{
								priceId = DailyPricingFactory.GetPriceIDMultiTerm( slChnl, accountTypeId, priceTier, account.EffStartDate, account.DateDeal, account.Utility, account.TermMonths, account.TransferRate, account.ContractType, out brandId, out flex );
							}
							else
							{
								priceId = DailyPricingFactory.GetPriceID( slChnl, accountTypeId, priceTier, account.EffStartDate, account.DateDeal, account.Utility, account.TermMonths, account.TransferRate, account.ContractType, out brandId, out flex );
							}
						}
                        //if (priceId == -1)
                        //{
                        //    throw new Exception( "Rate cannot be found" );
                        //}
					}
                    //else
                    //{
                    //    throw new Exception( "Tier Pricing is invalid" );
		
                    //}
                    if (priceId != -1)
                    {
                        account.PriceID = priceId;
                    }
					

                    if (ConfigurationManager.AppSettings["RunOldAPI"].ToString().Equals( "0" ))
					{
                        if (string.IsNullOrEmpty( productId ))
						{
							productId = ProductFactory.GetProductID( brandId, account.Utility.Code, DailyPricingFactory.ConvertAccountTypeID( accountTypeId, "LEGACY" ), flex );
						}

                        if (rateId == -1)
						{
							rateId = ProductRateFactory.GetNewRateID();
						}

						account.Product = ProductFactory.CreateProduct( productId );
						account.RateId = rateId;
					}
				}
                catch (Exception ex)
				{
					account.ErrorMsg = "Rate does not match selections made: " + ex.Message + "\n\r" + ex.InnerException;
				}

                if (account.Utility.RetailMarketID != account.Market.ID)
				{
					account.ErrorMsg = "Utility does not belong to this Market.";
				}

				//account.RateId = rateId;
				account.ContractType = ds.Tables[0].Rows[i][36].ToString().Trim().ToUpper();
				account.ProductType = productType;
				account.ServiceClass = serviceClass;
				account.ZoneCode = zone;

                if (String.IsNullOrEmpty( account.BillingAddressStreet.Trim() ))
					account.ErrorMsg = "Invalid Billing Address.";
                else if (String.IsNullOrEmpty( account.ServiceAddressStreet.Trim() ))
					account.ErrorMsg = "Invalid Service Address.";
                else if (String.IsNullOrEmpty( account.BillingCity.Trim() ))
					account.ErrorMsg = "Invalid Billing City.";
                else if (String.IsNullOrEmpty( account.ServiceCity.Trim() ))
					account.ErrorMsg = "Invalid Service City.";
                else if (!States.Values.Contains( account.BillingState.Trim() ))
					account.ErrorMsg = "Invalid Billing State.";
                else if (!States.Values.Contains( account.ServiceState.Trim() ))
					account.ErrorMsg = "Invalid Service State.";
                else if (String.IsNullOrEmpty( account.BillingZip.Trim() ) || !regex.IsMatch( account.BillingZip.Trim() ))
					account.ErrorMsg = "Invalid Billing Zip.";
                else if (String.IsNullOrEmpty( account.ServiceZip.Trim() ) || !regex.IsMatch( account.ServiceZip.Trim() ))
					account.ErrorMsg = "Invalid Service Zip.";

				account.Origin = "EXCEL";
				account.BusinessType = "CORPORATION";
				account.BusinessActivity = "CORPORATION";
				account.DateEnd = account.EffStartDate.AddMonths( account.TermMonths );
				account.DateCreated = DateTime.Now;
				account.DateReEnrollment = DateTime.MinValue;
				account.DateDeEnrollment = DateTime.MinValue;
				account.DatePorEnrollment = DateTime.MinValue;
				account.BillingTitle = ds.Tables[0].Rows[i][43].ToString().Trim().ToUpper();
				account.AccountNameLink = 2;
				account.ServiceAddressLink = 2;
				account.CustomerNameLink = 1;
				account.OwnerNameLink = 1;
				account.CustomerAddressLink = 1;
				account.CustomerAddress = account.ServiceAddressStreet;
				account.CustomerCity = account.ServiceCity;
				account.CustomerState = account.ServiceState;
				account.CustomerSuite = account.ServiceSuite;
				account.CustomerZip = account.ServiceZip;
				account.DateSubmit = DateTime.Now;
				account.BillingAddressLink = 3;
				account.CustomerContactLink = 2;
				account.BillingContactLink = 1;
				account.AdditionalIdNumber = ds.Tables[0].Rows[i][38].ToString().Trim().ToUpper();
				account.AdditionalIdNumberType = ds.Tables[0].Rows[i][39].ToString().Trim().ToUpper();
				account.SalesRep = ds.Tables[0].Rows[i][37].ToString().Trim().ToUpper();

                if (ConfigurationManager.AppSettings["RunOldAPI"].ToString().Equals( "0" ))
				{
                    if (account.AdditionalIdNumberType.ToUpper() == "SSN")
					{
						string ssn = account.AdditionalIdNumber;
						try
						{
							SocialSecurityNumber.Validate( ssn );
							//account.AdditionalIdNumber = "***-**-****";
							account.SSNEncrypted = Crypto.Encrypt( ssn.Replace( "-", "" ).Trim() );
						}
                        catch (EncryptionException ex)
						{
							throw new EncryptionException( "Could not encrypt SSN " + ssn + ": " + ex.Message );
						}
					}
				}
				string taxStatus = ds.Tables[0].Rows[i][44].ToString().Trim().ToUpper();
                if (taxStatus == "YES")
					taxStatus = "EXEMPT";
				else
					taxStatus = "FULL";
				account.TaxStatus = taxStatus;
				account.EnrollmentType = 1;
				account.CustomerFirstName = account.BillingFirstName;
				account.CustomerLastName = account.BillingLastName;
				account.CustomerTitle = account.BillingTitle;
				account.CustomerPhone = account.BillingPhone;
				account.CustomerName = account.AccountName;
				account.CustomerFax = "";
				account.CustomerEmail = "";
				account.BillingFax = "";
				account.BillingEmail = "";
				account.OwnerName = account.AccountName;

				account.ContractVersion = ds.Tables[0].Rows[i][45].ToString().Trim().ToUpper();

                if (contract == null)
				{
					contract = new ProspectContract();
					contract.Accounts = new List<ProspectAccount>();
					contract.ContractNumber = account.ContractNumber;
					contract.ExcelContractNumber = ds.Tables[0].Rows[i][contractNbrColumnIdx].ToString().ToUpper();
					contract.Market = account.Market;
					contract.Utility = account.Utility;
					contract.ContractType = account.ContractType;
					contract.Status = "DRAFT";
					contract.DateDeal = account.DateDeal;
					contract.Product = account.Product;
					contract.RateId = account.RateId;
					contract.SalesChannelRole = account.SalesChannelRole;
					contract.SalesRep = account.SalesRep;
					contract.Rate = account.Rate;
					contract.TermMonths = account.TermMonths;
					contract.RequestedFlowStartDate = account.EffStartDate;

					contract.CustomerFirstName = account.BillingFirstName;
					contract.CustomerLastName = account.BillingLastName;
					contract.BillingFirstName = account.BillingFirstName;
					contract.BillingLastName = account.BillingLastName;
					contract.CustomerTitle = account.BillingTitle;
					contract.BillingTitle = account.BillingTitle;
					contract.CustomerPhone = account.BillingPhone;
					contract.BillingPhone = account.BillingPhone;
					contract.CustomerName = account.AccountName;
					contract.OwnerName = account.AccountName;
					contract.Username = user;
					contract.DateSubmit = account.DateSubmit;
					contract.ServiceAddressLink = 1;
					contract.CustomerNameLink = 1;
					contract.OwnerNameLink = 1;
					contract.CustomerAddressLink = 1;
					contract.BillingAddressLink = 1;
					contract.CustomerContactLink = 1;
					contract.BillingContactLink = 1;
					contract.AdditionalIdNumber = account.AdditionalIdNumber;
					contract.AdditionalIdNumberType = account.AdditionalIdNumberType;
					contract.SSNEncrypted = account.SSNEncrypted;
					contract.EnrollmentType = 1;
					contract.ContractVersion = account.ContractVersion;
					contract.TemplateName = String.Empty;
					contract.TemplateVersionID = -1;
                    contract.PromotionCodes = new List<string>();
                    lstContract.Add(contract);

				}
                if (account.PromoCode.Trim() != "")
                {
                    contract.PromotionCodes.Add(account.PromoCode);
                }
                
				contract.Accounts.Add( account );
                
			}

			return lstContract;
		}

		public static List<ProspectContract> MountContractPrepopulateFromExcel( DataSet ds, int userId )
        {
            List<ProspectContract> lstContract = new List<ProspectContract>();
            Dictionary<string, string> dic = new Dictionary<string, string>();

			Dictionary<string, string> States = ProspectContractFactory.GetStatesDropDown( "libertypower\\tnogueira" );
			System.Text.RegularExpressions.Regex regex = new System.Text.RegularExpressions.Regex( "^[0-9]+$" );

            string contractNbr = "";
            int contractNbrColumnIdx = 1;
			User user = UserFactory.GetUser( userId );

            for (int i = 1; i < ds.Tables[0].Rows.Count; i++)
            {
				ProspectAccount account = new ProspectAccount( ds.Tables[0].Rows[i][2].ToString() );

                if (ds.Tables[0].Rows[i][contractNbrColumnIdx].ToString().ToUpper().Contains( "PRINT" ))
                {
                    if (dic.ContainsKey( ds.Tables[0].Rows[i][contractNbrColumnIdx].ToString().ToUpper() ))
                    {
                        contractNbr = dic[ds.Tables[0].Rows[i][contractNbrColumnIdx].ToString().ToUpper()];
                    }
                    else
                    {
						contractNbr = GenerateContractNumber( "libertypower\\dlima" );
						dic.Add( ds.Tables[0].Rows[i][contractNbrColumnIdx].ToString().ToUpper(), contractNbr );
                    }
                }
                else
                {
                    contractNbr = ds.Tables[0].Rows[i][contractNbrColumnIdx].ToString();
                }

                account.ContractNumber = contractNbr;

                account.ContractType = ds.Tables[0].Rows[i][36].ToString().Trim().ToUpper();

                if (account.ContractType.ToUpper().Contains( "PAPER" ))
                {
                    //as part of MD084, the business decided to not support paper contracts in batch upload anymore
                    continue;
                }

				ProspectContract contract = lstContract.Find( delegate( ProspectContract pc ) { return pc.ContractNumber == account.ContractNumber; }
                    );

                //ContractNumber	AccountNumber	AccountName	ServiceStreet	ServiceSuite	ServiceCity	ServiceState	
                //ServiceZip	ServiceZipPlus4	BillingStreet	BillingSuite	BillingCity	BillingState	BillingZip	BillingZipPlus4	
                //ContactFirstName	ContactLastName	ContactPhoneNumber	Meter Number	Name Key	Billing Account	MDMA	MSP	
                //Meter Installer	Meter Reader	Schedule Coordinator	SalesChannel	Market	Utility	AccountType	EffectiveStartDate	
                //ContractDate	Term	TransferRate	ContractRate
				account.AccountId = DAL.ProspectManagementSqlDal.GetNewAccountId( user.Username );
                account.AccountName = ds.Tables[0].Rows[i][3].ToString().Trim();
                account.ServiceAddressStreet = ds.Tables[0].Rows[i][4].ToString().Trim();
                account.ServiceSuite = ds.Tables[0].Rows[i][5].ToString().Trim();
                account.ServiceCity = ds.Tables[0].Rows[i][6].ToString().Trim();
                account.ServiceState = ds.Tables[0].Rows[i][7].ToString().Trim();
                account.ServiceZip = ds.Tables[0].Rows[i][8].ToString().Trim() + ds.Tables[0].Rows[i][9].ToString().Trim();
                //+ServiceZipPlus4
                account.BillingAddressStreet = ds.Tables[0].Rows[i][10].ToString().Trim();
                account.BillingSuite = ds.Tables[0].Rows[i][11].ToString().Trim();
                account.BillingCity = ds.Tables[0].Rows[i][12].ToString().Trim();
                account.BillingState = ds.Tables[0].Rows[i][13].ToString().Trim();
                account.BillingZip = ds.Tables[0].Rows[i][14].ToString().Trim() + ds.Tables[0].Rows[i][15].ToString().Trim();
                //+BillingZipPlus4
                account.BillingFirstName = ds.Tables[0].Rows[i][16].ToString().Trim();
                account.BillingLastName = ds.Tables[0].Rows[i][17].ToString().Trim();
                account.BillingPhone = ds.Tables[0].Rows[i][18].ToString().Trim();
                //account.MeterNumber = ds.Tables[0].Rows[i][19].ToString().Trim();
                account.NameKey = ds.Tables[0].Rows[i][19].ToString().Trim();
                account.CustomerCode = ds.Tables[0].Rows[i][19].ToString().Trim();
                account.BillingAccount = ds.Tables[0].Rows[i][20].ToString().Trim();
                //Deleted some columns in excel as mentioned in 25417 so all dataset column index has been changed.
                //account.MDMA = ds.Tables[0].Rows[i][22].ToString().Trim();
                //account.MSP = ds.Tables[0].Rows[i][23].ToString().Trim();
                //account.MeterInstaller = ds.Tables[0].Rows[i][24].ToString().Trim();
                //account.MeterReader = ds.Tables[0].Rows[i][25].ToString().Trim();
                //account.ScheduleCoordinator = ds.Tables[0].Rows[i][26].ToString().Trim();
                account.SalesChannelRole = "Sales Channel/" + ds.Tables[0].Rows[i][21].ToString().Trim().Replace( "Sales Channel/", "" );
                account.Market = MarketManagement.UtilityManagement.MarketFactory.GetRetailMarket( ds.Tables[0].Rows[i][22].ToString().Trim().ToUpper() );

                if (account.Market == null)
                {
					throw new Exception( "Market Cannot be empty:" + "Contract Grouping:" + " " + ds.Tables[0].Rows[i][1].ToString().Trim().ToUpper() + "  " + " and Account Number:" + " " + ds.Tables[0].Rows[i][2].ToString().Trim().ToUpper() );
                }

                account.Utility = MarketManagement.UtilityManagement.UtilityFactory.GetUtilityByCode( ds.Tables[0].Rows[i][23].ToString().Trim().ToUpper() );

                if (account.Utility == null)
                {
					throw new Exception( "Utility cannot be empty:" + "Contract Grouping:" + " " + ds.Tables[0].Rows[i][1].ToString().Trim().ToUpper() + "  " + " and Account Number:" + " " + ds.Tables[0].Rows[i][2].ToString().Trim().ToUpper() );
                }

                account.AccountType = ds.Tables[0].Rows[i][24].ToString().Trim().ToUpper();
                if (string.IsNullOrEmpty( account.AccountType ))
                {
					throw new Exception( "AccountType cannot be empty:" + "Contract Grouping:" + " " + ds.Tables[0].Rows[i][1].ToString().Trim().ToUpper() + "  " + " and Account Number:" + " " + ds.Tables[0].Rows[i][2].ToString().Trim().ToUpper() );
                }

                //account.EffStartDate = Convert.ToDateTime(ds.Tables[0].Rows[i][31].ToString().Trim());
                bool isSucceeded = false;
                isSucceeded = DateParsing.ParseDate( ds.Tables[0].Rows[i][25].ToString().Trim(), out account.EffStartDate );
                if (isSucceeded)
                { account.RequestedFlowStartDate = account.EffStartDate; 
          
                }
                else
                {
                    account.EffStartDate = DateTime.MinValue;
                   // throw new Exception("EffStartDate is not in correct format"); // As per Michael Cofer
                }
                //account.DateDeal = Convert.ToDateTime(ds.Tables[0].Rows[i][32].ToString().Trim());
                isSucceeded = DateParsing.ParseDate( ds.Tables[0].Rows[i][26].ToString().Trim(), out account.DateDeal );
                //PBI 35057 added the code to change the deal datetime to date only to resolve the bug when loading a file which has records containing only the required fields and multiplae accounts in a contract group, the system is displaying an error
                account.DateDeal = account.DateDeal.Date;
                if (!isSucceeded)
                {
                    // throw new Exception("DealDate is not in correct format"); // As per Michael Cofer
                }
                string channel = ds.Tables[0].Rows[i][21].ToString().Trim().Replace( "Sales Channel/", "" );
                sc.SalesChannel saleslChannel = SalesChannelFactory.GetSalesChannel( channel );
                if (saleslChannel == null || (string.IsNullOrEmpty( channel )))
                {
					throw new Exception( "Sales channel cannot be empty: " + "Contract Grouping:" + " " + ds.Tables[0].Rows[i][1].ToString().Trim().ToUpper() + "  " + " and Account Number:" + " " + ds.Tables[0].Rows[i][2].ToString().Trim().ToUpper() );
                }
                int intTermMonth;
                if(int.TryParse( ds.Tables[0].Rows[i][27].ToString().Trim(),out intTermMonth))
                    account.TermMonths = intTermMonth;
               //account.TransferRate = Convert.ToDecimal(ds.Tables[0].Rows[i][34].ToString().Trim());
                Decimal decRate;
                if(decimal.TryParse( ds.Tables[0].Rows[i][28].ToString(),out decRate))
                    account.Rate = decRate;
                account.TransferRate = decRate;
                account.Tier = ds.Tables[0].Rows[i][37].ToString().Trim().ToUpper();
                if (ds.Tables[0].Rows[i][38].ToString().Trim() != "")
                    account.Language = ds.Tables[0].Rows[i][38].ToString().Trim().ToUpper();
                else
                    account.Language = "ENG";
                //account.DoorToDoor = ds.Tables[0].Rows[i][40].ToString().Trim().ToUpper();
                account.Email = ds.Tables[0].Rows[i][39].ToString().Trim().ToUpper();
                string productType = ds.Tables[0].Rows[i][32].ToString().Trim().ToUpper();
                if (string.IsNullOrEmpty( productType ))
                {
					throw new Exception( "Product Type  cannot be empty: " + "Contract Grouping:" + " " + ds.Tables[0].Rows[i][1].ToString().Trim().ToUpper() + "  " + " and Account Number:" + " " + ds.Tables[0].Rows[i][2].ToString().Trim().ToUpper() );
                }
               
                string serviceClass = ds.Tables[0].Rows[i][33].ToString().Trim().ToUpper();
                string zone = ds.Tables[0].Rows[i][34].ToString().Trim().ToUpper();
                int rateId = -1;

                try
                {
                    Int64 priceId = -1;
                    int brandId = -1;
                    int flex = -1;
                    bool isCustomChecked = false;
                    string productId = null;

                    string channelName = ds.Tables[0].Rows[i][21].ToString().Trim().Replace( "Sales Channel/", "" );
                    string accountType = (account.AccountType == "RESIDENTIAL") ? "RES" : account.AccountType;
					sc.SalesChannel slChnl = SalesChannelFactory.GetSalesChannel( channelName );
					int accountTypeId = ConfigurationFactory.GetSegment( accountType ).Identity;
                    if (!string.IsNullOrEmpty( productType ))
                    {
                        //ProductType productTypeList = ProductTypeFactory.GetProductType(productType);
                        if (!ProductFactory.IsProductBrandExists( productType ))
                            throw new Exception( "Invalid Product Type.Please refer to Sheet3 of the template. " + "Contract Grouping:" + " " + ds.Tables[0].Rows[i][1].ToString().Trim().ToUpper() + "  " + " and Account Number:" + " " + ds.Tables[0].Rows[i][2].ToString().Trim().ToUpper() );
                       
                        //Validate the producttype from database.
                        //List<String> str = new List<string>() { "INDEPENDENCE PLAN", "SUPER SAVER", "HOUSE VARIABLE", "LIBERTY FLEX", "LIBERTY", "MCPE", "INDEX", "CUSTOM FIXED", "CUSTOM INDEX", "CUSTOM BLOCK INDEX", "CUSTOM HEAT RATE WITH ADDER", "GUARENTEED", "FREEDOM TO SAVE", "HYBRID", "CUSTOM HYBRID", "POLR", "SMART STEP", "FIXED IL WIND", "FIXED NATIONAL GREEN E", "CUSTOM SMARTSTEP", "FIXED CT GREEN", "FIXED MD GREEN", "FIXED PA GREEN", "PRICE DROP" };
                        //if (!str.Contains(productType.Trim().ToUpper()))
                        //    throw new Exception("Invalid Product Type.Please refer to Sheet3 of the template. " + "Contract Grouping:" + " " + ds.Tables[0].Rows[i][1].ToString().Trim().ToUpper() + "  " + " and Account Number:" + " " + ds.Tables[0].Rows[i][2].ToString().Trim().ToUpper());

                    }
					PriceTier priceTier = CacheManager.GetPriceTier( account.Tier );

                    if (priceTier != null)
                    {
                        //First try to match the rate against the custom rates, if a match is found, then the rate is a custom rate
                        if (priceTier.PriceTierID == 0) //no Tier pricing
                        {
							DailyPricingFactory.GetCustomRateIdAndPriceId( slChnl, account.EffStartDate, account.DateDeal, account.Utility.RetailMarketCode, account.Utility.Code, account.ContractType, account.AccountType, account.TermMonths, account.TransferRate, out rateId, out priceId, out productId );
                            isCustomChecked = true;
                        }

                        //check for a priceID in case we didnt find a custom rate or in case we didnt check the custom rate
                        if ((isCustomChecked && priceId == -1) || !isCustomChecked)
                        {
                            if (!string.IsNullOrEmpty( productType ) && productType.Trim().ToUpper() == "MULTI-TERM")
                            {
								priceId = DailyPricingFactory.GetPriceIDMultiTerm( slChnl, accountTypeId, priceTier, account.EffStartDate, account.DateDeal, account.Utility, account.TermMonths, account.TransferRate, account.ContractType, out brandId, out flex );
                            }
                            else
                            {
								priceId = DailyPricingFactory.GetPriceID( slChnl, accountTypeId, priceTier, account.EffStartDate, account.DateDeal, account.Utility, account.TermMonths, account.TransferRate, account.ContractType, out brandId, out flex );
                            }
                        }
                        // As per Michael Cofer
                        if (priceId == -1)
                        {
                           // throw new Exception("Rate cannot be found"); 
                            flex = 0; // If flex is -1 then usp_ProductIdSelect sp is throwing an exception. 
							var ProductBrand = ProductFactory.GetProductBrands().Where( x => x.Name.ToUpper() == productType.ToUpper() ).FirstOrDefault();
                            brandId = ProductBrand.ProductBrandID;
                            
                        }
                    }
                    //else
                    //{
                    //    throw new Exception( "Tier Pricing is invalid" );
                    //}
                    if (priceId != -1)
                    {
                        account.PriceID = priceId;
                    }
                    else
                    {
                        // throw new Exception("Rate cannot be found"); 
                        flex = 0; // If flex is -1 then usp_ProductIdSelect sp is throwing an exception. 
                        var ProductBrand = ProductFactory.GetProductBrands().Where(x => x.Name.ToUpper() == productType.ToUpper()).FirstOrDefault();
                        brandId = ProductBrand.ProductBrandID;
                    }

                    if (ConfigurationManager.AppSettings["RunOldAPI"].ToString().Equals( "0" ))
                    {
                        if (string.IsNullOrEmpty( productId ))
                        {
							productId = ProductFactory.GetProductID( brandId, account.Utility.Code, DailyPricingFactory.ConvertAccountTypeID( accountTypeId, "LEGACY" ), flex );
                        }

                        if (rateId == -1)
                        {
                            rateId = ProductRateFactory.GetNewRateID();
                        }

						account.Product = ProductFactory.CreateProduct( productId );
                        account.RateId = rateId;
                    }
                }
                catch (Exception ex)
                {
                    account.ErrorMsg = ex.Message + "\n\r" + ex.InnerException; // Raju- Re- Verify this Error Message
                }

                if (account.Utility.RetailMarketID != account.Market.ID)
                {
                    account.ErrorMsg = "Utility does not belong to this Market.";
                }

                //account.RateId = rateId;
               // account.ContractType = ds.Tables[0].Rows[i][36].ToString().Trim().ToUpper();
                account.ProductType = productType;
                account.ServiceClass = serviceClass;
                account.ZoneCode = zone;

                // As per Michael Cofer
                //if (String.IsNullOrEmpty(account.BillingAddressStreet.Trim()))
                //    account.ErrorMsg = "Invalid Billing Address.";
                //else if (String.IsNullOrEmpty(account.ServiceAddressStreet.Trim()))
                //    account.ErrorMsg = "Invalid Service Address.";
                //else if (String.IsNullOrEmpty(account.BillingCity.Trim()))
                //    account.ErrorMsg = "Invalid Billing City.";
                //else if (String.IsNullOrEmpty(account.ServiceCity.Trim()))
                //    account.ErrorMsg = "Invalid Service City.";
                //else if (!States.Values.Contains(account.BillingState.Trim()))
                //    account.ErrorMsg = "Invalid Billing State.";
                //else if (!States.Values.Contains(account.ServiceState.Trim()))
                //    account.ErrorMsg = "Invalid Service State.";
                //else if (String.IsNullOrEmpty(account.BillingZip.Trim()) || !regex.IsMatch(account.BillingZip.Trim()))
                //    account.ErrorMsg = "Invalid Billing Zip.";
                //else if (String.IsNullOrEmpty(account.ServiceZip.Trim()) || !regex.IsMatch(account.ServiceZip.Trim()))
                //    account.ErrorMsg = "Invalid Service Zip.";

                account.Origin = "EXCEL";
                account.BusinessType = "CORPORATION";
                account.BusinessActivity = "CORPORATION";
				account.DateEnd = account.EffStartDate.AddMonths( account.TermMonths );
                account.DateCreated = DateTime.Now;
                account.DateReEnrollment = DateTime.MinValue;
                account.DateDeEnrollment = DateTime.MinValue;
                account.DatePorEnrollment = DateTime.MinValue;
                account.BillingTitle = ds.Tables[0].Rows[i][36].ToString().Trim().ToUpper();
                account.AccountNameLink = 2;
                account.ServiceAddressLink = 2;
                account.CustomerNameLink = 1;
                account.OwnerNameLink = 1;
                account.CustomerAddressLink = 1;
                account.CustomerAddress = account.ServiceAddressStreet;
                account.CustomerCity = account.ServiceCity;
                account.CustomerState = account.ServiceState;
                account.CustomerSuite = account.ServiceSuite;
                account.CustomerZip = account.ServiceZip;
                account.DateSubmit = DateTime.Now;
                account.BillingAddressLink = 3;
                account.CustomerContactLink = 2;
                account.BillingContactLink = 1;
                account.AdditionalIdNumber = ds.Tables[0].Rows[i][30].ToString().Trim().ToUpper();
                account.AdditionalIdNumberType = ds.Tables[0].Rows[i][31].ToString().Trim().ToUpper();
                account.SalesRep = ds.Tables[0].Rows[i][29].ToString().Trim().ToUpper();

                // As per Michael Cofer
                //if (ConfigurationManager.AppSettings["RunOldAPI"].ToString().Equals("0"))
                //{
                //    if (account.AdditionalIdNumberType.ToUpper() == "SSN")
                //    {
                //        string ssn = account.AdditionalIdNumber;
                //        try
                //        {
                //            SocialSecurityNumber.Validate(ssn);
                //            //account.AdditionalIdNumber = "***-**-****";
                //            account.SSNEncrypted = Crypto.Encrypt(ssn.Replace("-", "").Trim());
                //        }
                //        catch (EncryptionException ex)
                //        {
                //            throw new EncryptionException("Could not encrypt SSN " + ssn + ": " + ex.Message);
                //        }
                //    }
                //}
                string taxStatus = ds.Tables[0].Rows[i][36].ToString().Trim().ToUpper();
                if (taxStatus == "YES")
                    taxStatus = "EXEMPT";
                else
                    taxStatus = "FULL";
                account.TaxStatus = taxStatus;
                account.EnrollmentType = 1;
                account.CustomerFirstName = account.BillingFirstName;
                account.CustomerLastName = account.BillingLastName;
                account.CustomerTitle = account.BillingTitle;
                account.CustomerPhone = account.BillingPhone;
                account.CustomerName = account.AccountName;
                account.CustomerFax = "";
                account.CustomerEmail = "";
                account.BillingFax = "";
                account.BillingEmail = "";
                account.OwnerName = account.AccountName;

                //account.ContractVersion = ds.Tables[0].Rows[i][45].ToString().Trim().ToUpper();

                if (contract == null)
                {
                    contract = new ProspectContract();
                    contract.Accounts = new List<ProspectAccount>();
                    contract.ContractNumber = account.ContractNumber;
                    contract.ExcelContractNumber = ds.Tables[0].Rows[i][contractNbrColumnIdx].ToString().ToUpper();
                    contract.Market = account.Market;
                    contract.Utility = account.Utility;
                    contract.ContractType = account.ContractType;
                    contract.Status = "DRAFT";
                    contract.DateDeal = account.DateDeal;
                    contract.Product = account.Product;
                    contract.RateId = account.RateId;
                    contract.SalesChannelRole = account.SalesChannelRole;
                    contract.SalesRep = account.SalesRep;
                    contract.Rate = account.Rate;
                    contract.TermMonths = account.TermMonths;
                    contract.RequestedFlowStartDate = account.EffStartDate;

                    contract.CustomerFirstName = account.BillingFirstName;
                    contract.CustomerLastName = account.BillingLastName;
                    contract.BillingFirstName = account.BillingFirstName;
                    contract.BillingLastName = account.BillingLastName;
                    contract.CustomerTitle = account.BillingTitle;
                    contract.BillingTitle = account.BillingTitle;
                    contract.CustomerPhone = account.BillingPhone;
                    contract.BillingPhone = account.BillingPhone;
                    contract.CustomerName = account.AccountName;
                    contract.OwnerName = account.AccountName;
                    contract.Username = user;
                    contract.DateSubmit = account.DateSubmit;
                    contract.ServiceAddressLink = 1;
                    contract.CustomerNameLink = 1;
                    contract.OwnerNameLink = 1;
                    contract.CustomerAddressLink = 1;
                    contract.BillingAddressLink = 1;
                    contract.CustomerContactLink = 1;
                    contract.BillingContactLink = 1;
                    contract.AdditionalIdNumber = account.AdditionalIdNumber;
                    contract.AdditionalIdNumberType = account.AdditionalIdNumberType;
                    contract.SSNEncrypted = account.SSNEncrypted;
                    contract.EnrollmentType = 1;
                    contract.ContractVersion = account.ContractVersion;
                    contract.TemplateName = String.Empty;
                    contract.TemplateVersionID = -1;

					lstContract.Add( contract );
                }

				contract.Accounts.Add( account );
            }

			return lstContract;
		}

		public static MemoryStream ExportToExcel( DataTable dt )
		{
			Infragistics.Excel.Workbook wo = new Infragistics.Excel.Workbook( WorkbookFormat.Excel2007 );
			Infragistics.Excel.Worksheet ws = wo.Worksheets.Add( "Sheet1" );


			// Create column headers for each column
            for (int columnIndex = 0; columnIndex < dt.Columns.Count; columnIndex++)
			{
				ws.Rows[0].Cells[columnIndex].Value = dt.Columns[columnIndex].ColumnName;
			}

			// Starting at row index 1, copy all data rows in
			// the data table to the worksheet
			int rowIndex = 1;
            foreach (DataRow dataRow in dt.Rows)
			{
				WorksheetRow row = ws.Rows[rowIndex++];

                for (int columnIndex = 0; columnIndex < dataRow.ItemArray.Length; columnIndex++)
				{
					row.Cells[columnIndex].Value = dataRow.ItemArray[columnIndex];
				}
			}

			ws.Rows[0].CellFormat.BottomBorderColor = Color.Black;
			ws.Rows[0].CellFormat.TopBorderColor = Color.Black;
			ws.Rows[0].CellFormat.RightBorderColor = Color.Black;
			ws.Rows[0].CellFormat.LeftBorderColor = Color.Black;
			ws.Rows[0].CellFormat.FillPatternForegroundColor = Color.LightGray;

			MemoryStream ms = new MemoryStream();
			wo.Save( ms );
			return ms;
		}

		public static MemoryStream ExportToExcelSample()
		{
			bool hasLicense = SetAsposeLicenses();

            if (hasLicense)
			{
				Aspose.Cells.Workbook wo = new Aspose.Cells.Workbook();
				Aspose.Cells.Worksheet ws = wo.Worksheets.GetSheetByCodeName( "Sheet1" );

				List<string> columns = new List<string>() { "Error", "ContractNumber", "AccountNumber", "AccountName", "ServiceStreet", "ServiceSuite", "ServiceCity", "ServiceState", "ServiceZip", "ServiceZipPlus4", "BillingStreet", "BillingSuite", "BillingCity", "BillingState", "BillingZip", "BillingZipPlus4", "ContactFirstName", "ContactLastName", "ContactPhoneNumber", "MeterNumber", "NameKey", "BillingAccount", "MDMA", "MSP", "MeterInstaller", "MeterReader", "ScheduleCoordinator", "SalesChannel", "Market", "Utility", "AccountType", "EffectiveStartDate", "ContractDate", "Term", "TransferRate", "ContractRate", "ContractType", "SalesAgent", "IDNumber", "IDType", "ProductType", "ServiceClass", "Zone", "Title", "TaxExempt", "ContractVersion", "Tier", "Email","PromoCode" };
				List<string> sampleRow = new List<string>() { " ", "2658295", "0948300011", "John Doe", "20 West Kinzie St.", "", "Chicago", "IL", "60654", "", "1600 Amphitheatre Parkway", "", "Mountain View", "CA", "94043", "", "John", "Doe", "6502530000", "", "", "", "", "", "", "", "", "NEBO", "IL", "COMED", "SMB", "2/1/2012", "1/10/2011", "12", "0.04995", "0.04995", "Corporate", "Will", "111112814", "SSN", "Fixed", "", "", "Owner", "No", "", "0-100 MWh", "admin@libertypowercorp.com","" };

				// Create column headers for each column
                for (int columnIndex = 0; columnIndex < columns.Count; columnIndex++)
				{
					ws.Cells[0, columnIndex].Value = columns[columnIndex];
				}

				// Inserting sample data
                for (int columnIndex = 0; columnIndex < sampleRow.Count; columnIndex++)
				{
					ws.Cells[1, columnIndex].Value = sampleRow[columnIndex];
				}

				ws.AutoFitColumns();

				int index = wo.Styles.Add();
				Style style = wo.Styles[index];

				style.Borders[BorderType.TopBorder].Color = Color.Black;
				style.Borders[BorderType.BottomBorder].Color = Color.Black;
				style.Borders[BorderType.LeftBorder].Color = Color.Black;
				style.Borders[BorderType.RightBorder].Color = Color.Black;
				style.BackgroundColor = Color.LightGray;

				StyleFlag flag = new StyleFlag();
				flag.All = true;

				Range contractHeader = ws.Cells.CreateRange( "A1", "AT1" );
				contractHeader.ApplyStyle( style, flag );

				//Starting templates sheet process
				Aspose.Cells.Worksheet ws2 = wo.Worksheets.Add( "Sheet2" );

				DataSet ds = DAL.ProspectManagementSqlDal.GetDocumentsTemplate();

				ws2.Cells["A1"].Value = "Product";
				ws2.Cells["B1"].Value = "Contract";

				int rowIndex = 1;
                foreach (DataRow dataRow in ds.Tables[0].Rows)
				{
                    for (int columnIndex = 0; columnIndex < dataRow.ItemArray.Length; columnIndex++)
					{
						ws2.Cells[rowIndex, columnIndex].Value = dataRow.ItemArray[columnIndex].ToString().Trim();
					}
					rowIndex++;
				}

				int rowCount = ds.Tables[0].Rows.Count + 1;

				Range productStart = ws2.Cells.CreateRange( "A1" );
				productStart.Name = "ProductStart";
				Range productColumn = ws2.Cells.CreateRange( "A1", "A" + rowCount.ToString() );
				productColumn.Name = "ProductColumn";
				Range contractColumn = ws2.Cells.CreateRange( "B1", "B" + rowCount.ToString() );
				contractColumn.Name = "ContractColumn";

				ValidationCollection validations = ws.Validations;
				Validation contractTemplateValidation = validations[validations.Add()];
				contractTemplateValidation.Type = ValidationType.List;
				contractTemplateValidation.InCellDropDown = true;
				contractTemplateValidation.Formula1 = "=OFFSET(ProductStart,MATCH(SUBSTITUTE(AC2&AE2&AO2,\" \",\"\"),ProductColumn,0)-1,1,COUNTIF(ProductColumn,SUBSTITUTE(AC2&AE2&AO2,\" \",\"\")),1)";

				CellArea contractTemplateCell;
				contractTemplateCell.StartRow = 1;
				contractTemplateCell.EndRow = 1;
				contractTemplateCell.StartColumn = 45;
				contractTemplateCell.EndColumn = 45;

				contractTemplateValidation.AreaList.Add( contractTemplateCell );

				MemoryStream ms = new MemoryStream();
				wo.Save( ms, SaveFormat.Xlsx );
				return ms;
			}
			else
			{
				return null;
			}
		}


		public static bool SetAsposeLicenses()
		{
			bool result = false;

			try
			{
				Aspose.Cells.License cellsLicense = new Aspose.Cells.License();
				cellsLicense.SetLicense( "Aspose.Cells.lic" );
				result = true;
			}
            catch (Exception)
			{
				result = false;
			}

			return result;
		}

		public static List<ProductRate> GetIndependencePlanRates( string UserGuid, string UtilityId,
			string AccountType, DateTime DealDate, DateTime ContractStartDate )
		{
			List<ProductRate> rateList = new List<ProductRate>();

			SalesChannelUser SalesChannel = SalesChannelUserFactory.GetSalesChannelUser( UserGuid );
			string SalesChannelUsername = SalesChannel.ChannelUser.Username;

			int AccountTypeId = ProspectContractFactory.GetAccountTypeId( AccountType );
			string ProductId = ProspectContractFactory.GetIndependencePlanProduct( SalesChannelUsername, UtilityId, AccountTypeId );
			Product product = ProductFactory.CreateProduct( ProductId );

			DataSet dsRates = ProspectManagementSqlDal.GetDailyPricingDefaultRates( SalesChannelUsername, UtilityId, ProductId, "12", ContractStartDate, DealDate.Date );
            if (dsRates != null && dsRates.Tables.Count > 0 && dsRates.Tables[0].Rows.Count > 0)
			{
				rateList.Add( BuildProductRate( dsRates.Tables[0].Rows[0], product ) );
			}

			dsRates = ProspectManagementSqlDal.GetDailyPricingDefaultRates( SalesChannelUsername, UtilityId, ProductId, "24", ContractStartDate, DealDate.Date );
            if (dsRates != null && dsRates.Tables.Count > 0 && dsRates.Tables[0].Rows.Count > 0)
			{
				rateList.Add( BuildProductRate( dsRates.Tables[0].Rows[0], product ) );
			}

			return rateList;
		}

		public static List<ProductRate> GetIndependencePlanRates( string UserGuid, string UtilityId,
			string AccountType, DateTime DealDate, DateTime ContractStartDate, bool ABCRates, double MarkupValue )
		{
			List<ProductRate> rateList = new List<ProductRate>();
			SalesChannelUser SalesChannel = SalesChannelUserFactory.GetSalesChannelUser( UserGuid );
			string SalesChannelUsername = SalesChannel.ChannelUser.Username;

			int AccountTypeId = ProspectContractFactory.GetAccountTypeId( AccountType );
			string ProductId = ProspectContractFactory.GetIndependencePlanProduct( SalesChannelUsername, UtilityId, AccountTypeId, ABCRates );
			Product product = ProductFactory.CreateProduct( ProductId );


			DataSet dsRates = ProspectManagementSqlDal.GetDailyPricingDefaultRates( SalesChannelUsername, UtilityId, ProductId, "12", ContractStartDate, DealDate.Date );
            if (dsRates != null && dsRates.Tables.Count > 0 && dsRates.Tables[0].Rows.Count > 0)
			{
				rateList.Add( ProspectContractFactory.BuildProductRate( dsRates.Tables[0].Rows[0], product, MarkupValue ) );
			}

			dsRates = ProspectManagementSqlDal.GetDailyPricingDefaultRates( SalesChannelUsername, UtilityId, ProductId, "24", ContractStartDate, DealDate.Date );
            if (dsRates != null && dsRates.Tables.Count > 0 && dsRates.Tables[0].Rows.Count > 0)
			{
				rateList.Add( ProspectContractFactory.BuildProductRate( dsRates.Tables[0].Rows[0], product, MarkupValue ) );
			}

			return rateList;
		}

		private static FixedProductRate BuildProductRate( DataRow dataRow, Product product, double markupValue )
		{
			FixedProductRate prodRate = new FixedProductRate();
			prodRate.Product = product;
			prodRate.Rate = Convert.ToDecimal( dataRow["rate"] ) + Convert.ToDecimal( markupValue );
			prodRate.RateId = Convert.ToInt32( dataRow["return_value"].ToString() );
			prodRate.Term = Convert.ToInt32( dataRow["term_months"] );
			prodRate.RateDescription = dataRow["option_id"].ToString();
			prodRate.RateDescription = prodRate.RateDescription.Replace( dataRow["rate"].ToString(), prodRate.Rate.ToString() );

			return prodRate;
		}

		private static FixedProductRate BuildProductRate( DataRow dataRow, Product product )
		{
			FixedProductRate prodRate = new FixedProductRate();
			prodRate.Product = product;
			prodRate.Rate = Convert.ToDecimal( dataRow["rate"] );
			prodRate.RateId = Convert.ToInt32( dataRow["return_value"].ToString() );
			prodRate.Term = Convert.ToInt32( dataRow["term_months"] );
			prodRate.RateDescription = dataRow["option_id"].ToString();

			return prodRate;
		}

		private static string GetIndependencePlanProduct( string SalesChannelUsername, string UtilityId, int AccountTypeId )
		{
			DataSet ds = ProductSql.GetProducts( SalesChannelUsername, UtilityId, AccountTypeId );
			List<string> products = new List<string>();
			List<string> productsFiltered = new List<string>();
            if (DataSetHelper.HasRow( ds ))
			{
                foreach (DataRow dr in ds.Tables[0].Rows)
					products.Add( dr["ProductId"].ToString() );
			}

			var filtered =
				from p in products
				where p.Contains( "_IP" ) && !p.Contains( "_AB" )
				select p;

            foreach (string p in filtered)
				productsFiltered.Add( p );

            if (productsFiltered.Count > 1)
				throw new Exception( "More than one IP product for the informed utility and account type" );
			else
				return productsFiltered.ElementAt( 0 );
		}

		private static string GetIndependencePlanProduct( string SalesChannelUsername, string UtilityId, int AccountTypeId, bool ABCRates )
		{
			DataSet ds = ProductSql.GetProducts( SalesChannelUsername, UtilityId, AccountTypeId );

			List<string> products = new List<string>();
			List<string> productsFiltered = new List<string>();

            if (DataSetHelper.HasRow( ds ))
			{
                foreach (DataRow dr in ds.Tables[0].Rows)
					products.Add( dr["ProductId"].ToString() );
			}

			var filtered =
				from p in products
				where p.Contains( "_IP" ) && ((!ABCRates && !p.Contains( "_AB" )) || (ABCRates && p.Contains( "_AB" )))
				select p;

            foreach (string p in filtered)
				productsFiltered.Add( p );

            if (productsFiltered.Count > 1)
				throw new Exception( "More than one IP product for the informed utility and account type" );
			else
				return productsFiltered.ElementAt( 0 );
		}

		private static int GetAccountTypeId( string AccountType )
		{
			DataSet ds = AccountSql.getAccountTypes();
            if (ds.Tables[0].Rows.Count > 0)
			{
                foreach (DataRow dr in ds.Tables[0].Rows)
				{
                    if (dr["account_type"].ToString().Trim().ToUpper().Contains( AccountType ))
					{
						return Convert.ToInt32( dr["account_type_id"].ToString() );
					}
				}
			}
			return -1;
		}

		public static string GetNewAccountId( string username )
		{
			string accountId = null;
			accountId = DAL.ProspectManagementSqlDal.GetNewAccountId( username );
			return accountId;
		}

		public static DataSet GetProducts( string salesChannelUsername, string utilityId )
		{
			return ProductSql.GetProducts( salesChannelUsername, utilityId );
		}

		public static DataSet GetProducts( string salesChannelUsername, string utilityId, int accountTypeId )
		{
			return ProductSql.GetProducts( salesChannelUsername, utilityId, accountTypeId );
		}      
		public static DataSet GetPricingFromProductRate( string username, string utilityCode, int accountTypeID, DateTime startDate, DateTime contractDate, int term, Int64 rateId )
        {
			return DAL.ProspectManagementSqlDal.GetPricingFromProductRate( username, utilityCode, accountTypeID, startDate, contractDate, term, rateId );
        }
		public static void UpdateRateSubmitInd( long PriceId )
        {
			DAL.ProspectManagementSqlDal.UpdateRateSubmitInd( PriceId );
        }
        

        //PBI: 14201- Refactoring and cleanup of Deal Capture
        //July 2013
		public static ProspectContract GetContractInfoEF( string username, string contractNumber, string accountNumber, int estimatedAnnualusage = 0 )
        {
            ProspectContract objContract = new ProspectContract();

			DataTable dtRecord = EFDAL.ContractDal.GetContractInfo( username, contractNumber, accountNumber );

            if (dtRecord != null && dtRecord.Rows.Count > 0)
            {
                objContract.ContractNumber = dtRecord.Rows[0]["contract_nbr"].ToString().Trim();
                objContract.Status = dtRecord.Rows[0]["status"].ToString().Trim();
                objContract.Comment = dtRecord.Rows[0]["comment"].ToString().Trim();
                objContract.BusinessActivity = dtRecord.Rows[0]["business_activity"].ToString().Trim();
                objContract.BusinessType = dtRecord.Rows[0]["business_type"].ToString().Trim();
                objContract.AdditionalIdNumberType = dtRecord.Rows[0]["additional_id_nbr_type"].ToString().Trim();
                objContract.SalesChannelRole = dtRecord.Rows[0]["sales_channel_role"].ToString().Trim();

				objContract.ContractEffectiveStartDate = Convert.ToDateTime( dtRecord.Rows[0]["contract_eff_start_date"] );
				objContract.DateEnd = Convert.ToDateTime( dtRecord.Rows[0]["date_end"] );
                objContract.SalesRep = dtRecord.Rows[0]["sales_rep"].ToString().Trim();

                if (dtRecord.Rows[0]["sales_mgr"] != DBNull.Value)
                    objContract.SalesManager = dtRecord.Rows[0]["sales_mgr"].ToString().Trim();
                if (dtRecord.Rows[0]["initial_pymt_option_id"] != DBNull.Value)
					objContract.InitialPymtOptionId = Convert.ToInt32( dtRecord.Rows[0]["initial_pymt_option_id"] );
                if (dtRecord.Rows[0]["residual_option_id"] != DBNull.Value)
					objContract.ResidualOptionId = Convert.ToInt32( dtRecord.Rows[0]["residual_option_id"] );
                if (dtRecord.Rows[0]["residual_commission_end"] != DBNull.Value)
					objContract.ResidualCommisionEnd = Convert.ToDateTime( dtRecord.Rows[0]["residual_commission_end"] );
                if (dtRecord.Rows[0]["evergreen_option_id"] != DBNull.Value)
					objContract.EvergreenOptionId = Convert.ToInt32( dtRecord.Rows[0]["evergreen_option_id"] );
                if (dtRecord.Rows[0]["evergreen_commission_end"] != DBNull.Value)
					objContract.EvergreenCommissionEnd = Convert.ToDateTime( dtRecord.Rows[0]["evergreen_commission_end"] );
                if (dtRecord.Rows[0]["evergreen_commission_rate"] != DBNull.Value)
					objContract.EvergreenCommisionRate = Convert.ToDouble( dtRecord.Rows[0]["evergreen_commission_rate"] );
                objContract.CustomerGroup = dtRecord.Rows[0]["customer_group"].ToString().Trim();
				objContract.RequestedFlowStartDate = Convert.ToDateTime( dtRecord.Rows[0]["requested_flow_start_date"] );
				objContract.CustomerNameLink = Convert.ToInt32( dtRecord.Rows[0]["customer_name_link"] );
                objContract.CustomerName = dtRecord.Rows[0]["customer_name"].ToString().Trim();
				objContract.OwnerNameLink = Convert.ToInt32( dtRecord.Rows[0]["owner_name_link"] );
                objContract.OwnerName = dtRecord.Rows[0]["owner_name"].ToString().Trim();
				objContract.CustomerAddressLink = Convert.ToInt32( dtRecord.Rows[0]["customer_address_link"] );
                objContract.CustomerAddress = dtRecord.Rows[0]["customer_address"].ToString().Trim();
                objContract.CustomerSuite = dtRecord.Rows[0]["customer_suite"].ToString().Trim();
                objContract.CustomerCity = dtRecord.Rows[0]["customer_city"].ToString().Trim();
                objContract.CustomerZip = dtRecord.Rows[0]["customer_zip"].ToString().Trim();
                objContract.CustomerState = dtRecord.Rows[0]["customer_state"].ToString().Trim();
				objContract.ServiceAddressLink = Convert.ToInt32( dtRecord.Rows[0]["service_address_link"] );
                objContract.ServiceAddress = dtRecord.Rows[0]["service_address"].ToString().Trim();
                objContract.ServiceSuite = dtRecord.Rows[0]["service_suite"].ToString().Trim();
                objContract.ServiceCity = dtRecord.Rows[0]["service_city"].ToString().Trim();
                objContract.ServiceZip = dtRecord.Rows[0]["service_zip"].ToString().Trim();
                objContract.ServiceState = dtRecord.Rows[0]["service_state"].ToString().Trim();
				objContract.BillingAddressLink = Convert.ToInt32( dtRecord.Rows[0]["billing_address_link"] );
                objContract.BillingAddress = dtRecord.Rows[0]["billing_address"].ToString().Trim();
                objContract.BillingSuite = dtRecord.Rows[0]["billing_suite"].ToString().Trim();
                objContract.BillingCity = dtRecord.Rows[0]["billing_city"].ToString().Trim();
                objContract.BillingZip = dtRecord.Rows[0]["billing_zip"].ToString().Trim();
                objContract.BillingState = dtRecord.Rows[0]["billing_state"].ToString().Trim();
				objContract.CustomerContactLink = Convert.ToInt32( dtRecord.Rows[0]["customer_contact_link"] );
                objContract.CustomerFirstName = dtRecord.Rows[0]["customer_first_name"].ToString().Trim();
                objContract.CustomerLastName = dtRecord.Rows[0]["customer_last_name"].ToString().Trim();
                objContract.CustomerTitle = dtRecord.Rows[0]["customer_title"].ToString().Trim();
                objContract.CustomerPhone = dtRecord.Rows[0]["customer_phone"].ToString().Trim();
                objContract.CustomerFax = dtRecord.Rows[0]["customer_fax"].ToString().Trim();
                objContract.CustomerEmail = dtRecord.Rows[0]["customer_email"].ToString().Trim();
                objContract.CustomerBirthday = dtRecord.Rows[0]["customer_birthday"].ToString().Trim();
				objContract.BillingContactLink = Convert.ToInt32( dtRecord.Rows[0]["billing_contact_link"] );
                objContract.BillingFirstName = dtRecord.Rows[0]["billing_first_name"].ToString().Trim();
                objContract.BillingLastName = dtRecord.Rows[0]["billing_last_name"].ToString().Trim();
                objContract.BillingTitle = dtRecord.Rows[0]["billing_title"].ToString().Trim();
                objContract.BillingPhone = dtRecord.Rows[0]["billing_phone"].ToString().Trim();
                objContract.BillingFax = dtRecord.Rows[0]["billing_fax"].ToString().Trim();
                objContract.BillingEmail = dtRecord.Rows[0]["billing_email"].ToString().Trim();
                objContract.BillingBirthday = dtRecord.Rows[0]["billing_birthday"].ToString().Trim();
                if (!dtRecord.Rows[0]["retail_mkt_id"].ToString().Trim().Contains( "NN" ))
					objContract.Market = MarketManagement.UtilityManagement.MarketFactory.GetRetailMarket( dtRecord.Rows[0]["retail_mkt_id"].ToString().Trim() );
                if (!dtRecord.Rows[0]["utility_id"].ToString().Trim().Contains( "NONE" ))
					objContract.Utility = MarketManagement.UtilityManagement.UtilityFactory.GetUtilityByCode( dtRecord.Rows[0]["utility_id"].ToString().Trim() );
                objContract.SSNEncrypted = dtRecord.Rows[0]["SSNEncrypted"].ToString().Trim();
                objContract.AdditionalIdNumber = dtRecord.Rows[0]["additional_id_nbr"].ToString().Trim();
                if (dtRecord.Rows[0]["account_type"] != DBNull.Value)
                {
                    if (dtRecord.Rows[0]["account_type"].ToString().Trim() == "3")
                    {
                        objContract.AccountType = LibertyPower.Business.CustomerAcquisition.ProductManagement.AccountType.Lci;
                    }
                    else if (dtRecord.Rows[0]["account_type"].ToString().Trim() == "1")
                    {
                        objContract.AccountType = LibertyPower.Business.CustomerAcquisition.ProductManagement.AccountType.Smb;
                    }
                    else if (dtRecord.Rows[0]["account_type"].ToString().Trim() == "2")
                    {
                        objContract.AccountType = LibertyPower.Business.CustomerAcquisition.ProductManagement.AccountType.Residential;
                    }
                    else if (dtRecord.Rows[0]["account_type"].ToString().Trim() == "4")
                    {
                        objContract.AccountType = LibertyPower.Business.CustomerAcquisition.ProductManagement.AccountType.Soho;
                    }
                }

                objContract.ContractRateType = dtRecord.Rows[0]["contract_rate_type"].ToString().Trim();
                if (!dtRecord.Rows[0]["product_id"].ToString().Trim().Contains( "NONE" ))
					objContract.Product = ProductManagement.ProductFactory.CreateProduct( dtRecord.Rows[0]["product_id"].ToString().Trim() );
                if (objContract.Product != null)
                {
                    int productAccountTypeId = 0;
					int.TryParse( dtRecord.Rows[0]["account_type"].ToString().Trim(), out productAccountTypeId );
                    objContract.Product.AccountTypeID = productAccountTypeId;
                }
				objContract.DateDeal = Convert.ToDateTime( dtRecord.Rows[0]["date_deal"] );
				objContract.DateSubmit = Convert.ToDateTime( dtRecord.Rows[0]["date_submit"] );
				objContract.TermMonths = Convert.ToInt32( dtRecord.Rows[0]["term_months"] );
				objContract.RateId = Convert.ToInt32( dtRecord.Rows[0]["rate_id"] );
				objContract.Rate = Convert.ToDecimal( dtRecord.Rows[0]["rate"] );
				objContract.EnrollmentType = Convert.ToInt32( dtRecord.Rows[0]["enrollment_type"] );
                objContract.HeaderEnrollment1 = dtRecord.Rows[0]["header_enrollment_1"].ToString().Trim();
                objContract.HeaderEnrollment2 = dtRecord.Rows[0]["header_enrollment_2"].ToString().Trim();
                objContract.ContractType = dtRecord.Rows[0]["contract_type"].ToString().Trim();
				objContract.Username = UserFactory.GetUserByLogin( dtRecord.Rows[0]["username"].ToString().Trim() );
				objContract.ProductBrandID = dtRecord.Rows[0]["ProductBrandID"] == DBNull.Value ? 0 : Convert.ToInt32( dtRecord.Rows[0]["ProductBrandID"] );
				objContract.PriceID = dtRecord.Rows[0]["PriceID"] == DBNull.Value ? 0 : Convert.ToInt64( dtRecord.Rows[0]["PriceID"] );
				objContract.PriceTier = dtRecord.Rows[0]["PriceTier"] == DBNull.Value ? 0 : Convert.ToInt32( dtRecord.Rows[0]["PriceTier"] );

				int taxStatus = dtRecord.Rows[0]["TaxExempt"] == DBNull.Value ? 0 : Convert.ToInt32( dtRecord.Rows[0]["TaxExempt"] );
                objContract.TaxExempt = taxStatus;
                objContract.EstimatedAnnualUsage = estimatedAnnualusage;
            }
            return objContract;
        }

        //Added isRowSelectedforSave field for sending them to the LP.
        //July 16 2013 IT 121- PBI14205
		public static void UpdateAccountSetFlagIsForSave( string ContractNumber, string AccountNumber, bool FlagIsForSave )
		{
			DAL.ProspectManagementSqlDal.UpdateAccountSetFlagIsForSave( ContractNumber, AccountNumber, FlagIsForSave );
		}
		public static void UpdateALLAccountsSetFlagIsForSave( string ContractNumber, bool FlagIsForSave )
        {
			DAL.ProspectManagementSqlDal.UpdateALLAccountsSetFlagIsForSave( ContractNumber, FlagIsForSave );
        }

		public static DataSet GetCustomRate( Int64 priceID )
        {
			return DAL.ProspectManagementSqlDal.GetCustomRate( priceID );
        }


		public static bool IsContractNumberintheSystem( string ContractNumber )
        {
			return EFDAL.ContractDal.IsContractNumberInTheSystem( ContractNumber );
     
        }
        //GetContractNumberfromAccountNumber

        public static string GetContractNumberfromAccountNumber(string ContractNumber, int? utilityId)
        {
            return EFDAL.ContractDal.GetContractNumberfromAccountNumber(ContractNumber, utilityId);

        }
		public static bool IsAccountNumberintheSystem( string AccountNumber )
        {
			return EFDAL.ContractDal.IsAccountNumberInTheSystem( AccountNumber );
       //    return true;
        }
        public static bool CheckifAtleastOneAccountisFlowing(string ContractNumber,bool isContractNo, int? utilityId)
        {
            return EFDAL.ContractDal.IsAtleastOneAccountflowinginSystem(ContractNumber, isContractNo, utilityId);
      //   return true;
        }
		public static bool IsContractNumberinDealCapture( string ContractNumber )
        {
			return EFDAL.ContractDal.IsContractNumberinDealCapture( ContractNumber );
          //  return true;
        }

		public static string GetSalesChannelByUserName( string username )
        {
			DataSet ds = new DataSet();
			string salesChannel = "";

			ds = DAL.ProspectManagementSqlDal.GetSalesChannelByUserName( username );
            if (ds.Tables.Count > 0)
            {
                if (ds.Tables[0].Rows.Count > 0)
                {
					salesChannel = ds.Tables[0].Rows[0][0].ToString();
                }
            }
return salesChannel;

        }


        //Update Contract Details
		public static void UpdateContractforRenewal( string userName, string newcontractNumber, int? marketId, string utility_id, string salesChannelRole, string businessType, string businessActivity )
        {

			DAL.ProspectManagementSqlDal.UpdateContractforRenewal( userName, newcontractNumber, marketId, utility_id, salesChannelRole, businessType, businessActivity );
        }
        //Update Contract Details
		public static void InsertAccountforRenewal( string newcontractNumber, string accountNumber, string accountId, int? accounType, int? accountNameId )
        {

			DAL.ProspectManagementSqlDal.InsertAccountforRenewal( newcontractNumber, accountNumber, accountId, accounType, accountNameId );
        }

        //Update enrollment type and requested flow start date for all accounts

		public static void UpdateEnrollmentTypeIdAndFlowStartDateforAllAccounts( string contractNumber, string accountNumber, int enrollmentTypeId, DateTime? requestedFlowStartDate )
        {
			DAL.ProspectManagementSqlDal.UpdateEnrollmentTypeIdandRequestedFlowStartDateforAllAccounts( contractNumber, accountNumber, enrollmentTypeId, requestedFlowStartDate );
        }

        //Update rates for all the Accounts

		public static void UpdateRateforAllAccounts( string contractNumber, string accountNumber, decimal rate, int rateID, string ProductID, Int64 priceID )
        {

			DAL.ProspectManagementSqlDal.UpdateRateforAllAccounts( contractNumber, accountNumber, rate, rateID, ProductID, priceID );
        }

        //Delelte all the rates for the give contract and its accounts
		public static void DeleteRateforAllAccounts( string contractNumber )
        {

			DAL.ProspectManagementSqlDal.DeleteRateforAllAccounts( contractNumber );
        }

        //Sept 26 2013 - PBI 20710
        //Added for Promotion Codes on Deal capture
		public static int GetContractIDFromContractNumber( string ContractNumber )
        {
			DataSet ds = new DataSet();
			int ContractId = 0;

			ds = DAL.ProspectManagementSqlDal.GetContractIDFromContractNumber( ContractNumber );
            if (ds.Tables.Count > 0)
            {
                if (ds.Tables[0].Rows.Count > 0)
                {
					ContractId = Convert.ToInt32( ds.Tables[0].Rows[0][0] );
                }
            }
            return ContractId;
        }
        
		public static List<String> GetPromotionCodesforaContract( string ContractNumber )
        {
            List<String> promotionList = new List<String>();
			int ContractID = GetContractIDFromContractNumber( ContractNumber );
            if (ContractID == 0)
                return null;

			DataSet ds = DAL.ProspectManagementSqlDal.GetPromotionCodeDetailsbyContractID( ContractID );

            string PromotionCode;
            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    PromotionCode = dr["Code"].ToString().Trim();
					promotionList.Add( PromotionCode );
                }
            return promotionList;
            }
            return null;
        }

		public static void UpdatePromotionCodeIDforContract( int ContractID, int PromotionCodeID )
        {

			DAL.ProspectManagementSqlDal.UpdatePromotionCodeIDforContract( ContractID, PromotionCodeID );
        }

        public static DateTime GetFirstAvailableBusinessDayForNextMonth()
        {
            var now = DateTime.Now;
			var result = (new DateTime( now.Year, now.Month, 1 )).AddMonths( 1 );

            return result.DayOfWeek == DayOfWeek.Saturday ? 
				result.AddDays( 2 ) : result.DayOfWeek == DayOfWeek.Sunday ?
					result.AddDays( 1 ) : result;
        }

		//may 20 2014
		//UnSubmitted deals should pull the renenwal info also in submit closed deals page
		public static Tuple<string,string> GetCurrentContractNumberFromContractNumber( string ContractNumber )
		{
			DataSet ds = new DataSet();
			string CurrentNumber="";
			string CurrentContractAccount = "";

			ds = DAL.ProspectManagementSqlDal.GetCurrentContractNumberFromContractNumber( ContractNumber );
			if( ds.Tables.Count > 0 )
			{
				if( ds.Tables[0].Rows.Count > 0 )
				{
					CurrentContractAccount = ds.Tables[0].Rows[0][0]==null ? "" : ds.Tables[0].Rows[0][0].ToString();
					CurrentNumber = ds.Tables[0].Rows[0][1]==null ? "" : ds.Tables[0].Rows[0][1].ToString();
				}
			}
			return Tuple.Create(CurrentContractAccount,CurrentNumber);
		}

	}

}




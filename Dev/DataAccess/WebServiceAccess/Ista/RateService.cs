using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.Web.Services2.Security.Tokens;
using Microsoft.Web.Services2.Security;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Data;
using LibertyPower.DataAccess.SqlAccess.IstaSql;

namespace LibertyPower.DataAccess.WebServiceAccess.IstaWebService
{

	/// <summary>
	/// Encapsulates the Ista web service "RateService"
	/// </summary>

	public static class RateService
	{
		#region Obsolete

		/// <summary>
		/// Calls Ista web service RateService.UpdateCustomerRate to update rate information for variable account types and renewals
		/// Use UpdateCustomerRate
		/// </summary>
		/// <param name="accountNumber"></param>
		/// <param name="LDCRateCode"></param>
		/// <param name="rate"></param>
		/// <param name="switchDate"></param>
		/// <returns></returns>
		[Obsolete]
		public static bool UpdateCustomVariableCustomerRate( string accountNumber, string LDCRateCode, decimal rate, DateTime switchDate )
		{
			return false;
		}

		/// <summary>
		/// Updates the fixed customer rate.
		/// Use UpdateCustomerRate
		/// </summary>
		/// <param name="accountNumber">The account number.</param>
		/// <param name="LDCRateCode">The LDC rate code.</param>
		/// <param name="rate">The rate.</param>
		/// <param name="switchDate">The switch date.</param>
		/// <returns></returns>
		[Obsolete]
		public static bool UpdateFixedCustomerRate( string accountNumber, string LDCRateCode, decimal rate, DateTime switchDate )
		{
			return false;
		}

		/// <summary>
		/// Updates the custom billing customer rate.
		/// Use UpdateCustomerRate
		/// </summary>
		/// <param name="accountNumber">The account number.</param>
		/// <param name="LDCRateCode">The LDC rate code.</param>
		/// <param name="rate">The rate.</param>
		/// <param name="switchDate">The switch date.</param>
		/// <returns></returns>
		[Obsolete]
		public static bool UpdateCustomBillingCustomerRate( string accountNumber, string LDCRateCode, decimal rate, DateTime switchDate )
		{
			return false;
		}

		#endregion

		/// <summary>
		/// Returns the IstaClassID given an LPC account number
		/// </summary>
		/// <param name="accountNumber"></param>
		/// <returns></returns>
		private static Object GetIstaClassIDByAccount( string accountNumber )
		{
			Object istaClassID = null;
			DataSet ds = IstaSql.GetIstaCustomer( accountNumber );
			if( ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0 )
			{
				istaClassID = ds.Tables[0].Rows[0]["ista_class_id"];
			}
			return istaClassID;
		}

		/// <summary>
		/// Updates the portfolio variable customer rate.
		/// </summary>
		/// <param name="accountNumber">The account number.</param>
		/// <param name="LDCRateCode">The LDC rate code.</param>
		/// <param name="rate">The rate.</param>
		/// <param name="switchDate">The switch date.</param>
		/// <returns></returns>

		/// <summary>
		/// Updates the MCPE customer rate.
		/// </summary>
		/// <param name="accountNumber">The account number.</param>
		/// <param name="LDCRateCode">The LDC rate code.</param>
		/// <param name="rate">The rate.</param>
		/// <param name="switchDate">The switch date.</param>
		/// <returns></returns>
		public static bool UpdateMCPECustomerRate( string accountNumber, string LDCRateCode, decimal rate, DateTime switchDate )
		{
			throw new NotImplementedException();
		}

		/// <summary>
		/// Calls Ista web service to retrieve the templateInfoList given a valid plan type
		/// </summary>
		/// <param name="planType"></param>
		/// <returns></returns>
		public static IstaRateService.RateTemplateInfo[] GetRateTemplateInfoListByPlanType( IstaRateService.PlanTypeOptions planType )
		{
			IstaRateService.RateTemplateInfo[] result = null;

			try
			{
				IstaRateService.RateService rateService = new LibertyPower.DataAccess.WebServiceAccess.IstaWebService.IstaRateService.RateService();
				rateService.Url = Helper.IstaRateWebService;
				string clientIdentifier = Helper.IstaClientGuid;

				UsernameToken token = new UsernameToken( clientIdentifier, clientIdentifier, PasswordOption.SendNone );

				rateService.RequestSoapContext.Security.Tokens.Add( token );
				rateService.RequestSoapContext.Security.Elements.Add( new MessageSignature( token ) );
				result = rateService.GetRateTemplateInfoListByPlanType( planType );
			}
			catch( SoapException exception )
			{
				throw exception;
			}
			catch( Exception exception )
			{
				throw exception;
			}

			return result;
		}

		/// <summary>
		/// Calls Ista web service RateService.UpdateCustomerRate to update rate information for variable account types and renewals
		/// </summary>
		/// <param name="accountNumber"></param>
		/// <param name="utilityId"></param>
		/// <param name="productType"></param>
		/// <param name="rate"></param>
		/// <param name="meterCharge"></param>
		/// <param name="rateEffectiveDate"></param>
		/// <param name="rateEndDate"></param>
		public static void UpdateCustomerRate( string accountNumber, string utilityId, ProductPlanType productType, decimal rate, decimal meterCharge, DateTime rateEffectiveDate, DateTime rateEndDate )
		{
			UpdateCustomerRate( accountNumber, utilityId, productType, rate, meterCharge, rateEffectiveDate, rateEndDate, "", 1 );
		}

		public static void UpdateCustomerRate( string accountNumber, string utilityId, ProductPlanType productType, decimal rate, decimal meterCharge, DateTime rateEffectiveDate, DateTime rateEndDate, string rateCode )
		{
			UpdateCustomerRate( accountNumber, utilityId, productType, rate, meterCharge, rateEffectiveDate, rateEndDate, rateCode, 1, null );
		}

		public static void UpdateCustomerRate( string accountNumber, string utilityId, ProductPlanType productType, decimal rate, decimal meterCharge, DateTime rateEffectiveDate, DateTime rateEndDate, string rateCode, bool? with814Option )
		{
			UpdateCustomerRate( accountNumber, utilityId, productType, rate, meterCharge, rateEffectiveDate, rateEndDate, rateCode, 1, with814Option );
		}

		public static void UpdateCustomerRate( string accountNumber, string utilityId, ProductPlanType productType, decimal rate, decimal meterCharge, DateTime rateEffectiveDate, DateTime rateEndDate, string rateCode, int variableTypeID )
		{
			UpdateCustomerRate( accountNumber, utilityId, productType, rate, 0, 0, meterCharge, rateEffectiveDate, rateEndDate, rateCode, variableTypeID, null );
		}

		public static void UpdateCustomerRate( string accountNumber, string utilityId, ProductPlanType productType, decimal rate, decimal meterCharge, DateTime rateEffectiveDate, DateTime rateEndDate, string rateCode, int variableTypeID, bool? with814Option )
		{
			UpdateCustomerRate( accountNumber, utilityId, productType, rate, 0, 0, meterCharge, rateEffectiveDate, rateEndDate, rateCode, variableTypeID, with814Option );
		}

		public static void UpdateCustomerRate( string accountNumber, string utilityId, ProductPlanType productType, decimal rate1, decimal rate2, decimal rate3, decimal meterCharge, DateTime rateEffectiveDate, DateTime rateEndDate, string rateCode, int variableTypeID )
		{
			UpdateCustomerRate( accountNumber, utilityId, productType, rate1, rate2, rate3, meterCharge, rateEffectiveDate, rateEndDate, rateCode, variableTypeID, null );
		}

		public static void UpdateCustomerRate( string accountNumber, string utilityId, ProductPlanType productType, decimal rate1, decimal rate2, decimal rate3, decimal meterCharge, DateTime rateEffectiveDate, DateTime rateEndDate, string rateCode, int variableTypeID, bool? with814Option )
		{
			//utilityId in this method is UtilityCode from LibertyPower..Utility table
			bool result = false;
			try
			{
				// Prepare data to pass

				Decimal.TryParse( string.Format( "{0:0.00000}", rate1 ), out rate1 );
				Decimal.TryParse( string.Format( "{0:0.00000}", rate2 ), out rate2 );
				Decimal.TryParse( string.Format( "{0:0.00000}", rate3 ), out rate3 );

				// TFS 52802 - Ensure that if a customer's plan type is variable, and the rate is the default rate  of 0.1000, that we send "FALSE" for the </UpdateCustomerRateWith814Option>
				with814Option = (((productType == ProductPlanType.PortfolioVarialble) || (productType == ProductPlanType.CustomVariable)) && rate1 == .1m) ? false : with814Option;

				int istaCustomerID = IstaSql.GetCustIDByAccountAndUtility( accountNumber, utilityId ) == null ? 0 : (int) IstaSql.GetCustIDByAccountAndUtility( accountNumber, utilityId );
				//istaCustomerID = 579186; was used just for test perposes.
				if( istaCustomerID == 0 )
				{
					throw new Exception( "Cannot find IstaCustomerId for accountNumber=" + accountNumber + " and utilityId=" + utilityId + " into Promise table. The update was not submitted to ISTA." );
				}

				int istaClassID = IstaSql.GetClassIdByAccountAndUtility( accountNumber, utilityId ) == null ? 0 : (int) IstaSql.GetClassIdByAccountAndUtility( accountNumber, utilityId );
				string planType = ((int) productType).ToString();

				IstaRateService.RateRollover rollover = new LibertyPower.DataAccess.WebServiceAccess.IstaWebService.IstaRateService.RateRollover();

				rollover.RateRolloverDetailList = HelperMethods.GetISTARolloverRateList( planType, rateEffectiveDate, rateEndDate, rate1, rate2, rate3, istaClassID.ToString(), meterCharge, variableTypeID );

				rollover.CustomerID = istaCustomerID;
				rollover.ESIID = accountNumber;
				rollover.PlanType = HelperMethods.GetPlanType( planType );
				rollover.LDCRateCode = rateCode;
				rollover.SwitchDate = rateEffectiveDate;
				rollover.ContractStartDate = rateEffectiveDate;
				rollover.ContractStopDate = rateEndDate;

				IstaRateService.RateService rateService = new LibertyPower.DataAccess.WebServiceAccess.IstaWebService.IstaRateService.RateService();
				rateService.Url = Helper.IstaRateWebService;
				string clientIdentifier = Helper.IstaClientGuid;

				UsernameToken token = new UsernameToken( clientIdentifier, clientIdentifier, PasswordOption.SendNone );

				rateService.RequestSoapContext.Security.Tokens.Add( token );
				rateService.RequestSoapContext.Security.Elements.Add( new MessageSignature( token ) );

				//Building the WebCall of the Account.
				//try
				//{                
				//System.Xml.Serialization.XmlSerializer writer =
				//   new System.Xml.Serialization.XmlSerializer(rollover.GetType());

				//System.IO.StreamWriter file = new System.IO.StreamWriter(
				//    @"C:\RafaelVasques\SerializationOverview.xml");
				//writer.Serialize(file, rollover);
				//file.Close();
				//}
				//catch (Exception)
				//{                    
				//}

				if( with814Option == null || with814Option == false )
				{
					result = rateService.UpdateCustomerRate( rollover );
				}
				else
				{
					result = rateService.UpdateCustomerRateWith814Option( rollover, with814Option.Value );
				}
			}
			catch( SoapException exception )
			{
				string ex = (exception.Detail).InnerText;

				if( ex.Contains( "Could not find custID" ) )
				{
					throw new Exception( "Account does not exist at ISTA.  Might need to change the status to 'create utility file'." );
				}
				//1-166369020
				/*if( ex.Contains( "ESIID cannot be found" ) )
				{
				    throw new Exception( "Account is in status 'Drop Accepted' at ISTA which prevents the transaction from being sent.  Please confirm this status with ISTA." );
				}*/

				throw new Exception( ex );
			}
			catch( Exception exception )
			{
				throw exception;
			}

			if( !result )
			{
				throw new Exception( "Rate submission failed." );
			}
		}

	}
}

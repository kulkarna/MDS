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
	/// 
	/// </summary>
	public static class RateDueAccountsService
	{

		/// <summary>
		/// Gets the rate due accounts.
		/// </summary>
		/// <returns></returns>
		public static DataSet GetRateDueAccounts()
		{
			DataSet result = null;
			try
			{
				IstaBillingService.Rate billingService = new LibertyPower.DataAccess.WebServiceAccess.IstaWebService.IstaBillingService.Rate();
				billingService.Url = Helper.IstaBillingWebService;
				string clientIdentifier = Helper.IstaClientGuid;

				UsernameToken token = new UsernameToken( clientIdentifier, clientIdentifier, PasswordOption.SendNone );

				billingService.RequestSoapContext.Security.Tokens.Add( token );
				billingService.RequestSoapContext.Security.Elements.Add( new MessageSignature( token ) );

				result = billingService.ListUnbilledConsumptionCustomers();

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
		/// Updates the account rate amount.
		/// </summary>
		/// <param name="accountNumber">The account number.</param>
		/// <param name="newRateAmount">The new rate amount.</param>
		/// <param name="startDate">The start date.</param>
		/// <param name="endDate">The end date.</param>
		/// <returns></returns>
		[Obsolete()]
		public static bool UpdateAccountRateAmount( string accountNumber, decimal newRateAmount, DateTime startDate, DateTime endDate )
		{
			int istaCustomerId = (int) IstaSql.GetCustIDByAccountNumber( accountNumber );
			//BugTracker #2962 Rate Data To Ista Should be Rounded To 5 Digits After The Decimal And Truncated
			bool chk = Decimal.TryParse( string.Format( "{0:0.00000}", newRateAmount ), out newRateAmount );
			return RateDueAccountsService.UpdateAccountRate( istaCustomerId, newRateAmount, startDate, endDate );
		}

		/// <summary>
		/// Updates the account rate amount.
		/// </summary>
		/// <param name="accountNumber"></param>
		/// <param name="newRateAmount"></param>
		/// <param name="startDate"></param>
		/// <param name="endDate"></param>
		/// <returns></returns>
		public static bool UpdateAccountRateAmount( string accountNumber, string utilityId, decimal newRateAmount, DateTime startDate, DateTime endDate )
		{
			int istaCustomerId = (int) IstaSql.GetCustIDByAccountAndUtility( accountNumber, utilityId );
			//BugTracker #2962 Rate Data To Ista Should be Rounded To 5 Digits After The Decimal And Truncated
			bool chk = Decimal.TryParse( string.Format( "{0:0.00000}", newRateAmount ), out newRateAmount );
			return RateDueAccountsService.UpdateAccountRate( istaCustomerId, newRateAmount, startDate, endDate );
		}

		/// <summary>
		/// Updates the account rate amount.
		/// </summary>
		/// <param name="istaCustomerId">The ista customer id.</param>
		/// <param name="newRateAmount">The new rate amount.</param>
		/// <param name="effectiveDate">The effective date.</param>
		/// <param name="expirationDate">The expiration date.</param>
		/// <returns></returns>
		public static bool UpdateAccountRateAmount( int istaCustomerId, decimal newRateAmount, DateTime effectiveDate, DateTime expirationDate )
		{
			return RateDueAccountsService.UpdateAccountRate( istaCustomerId, newRateAmount, effectiveDate, expirationDate );
		}

		/// <summary>
		/// Updates the account rate amount.
		/// </summary>
		/// <param name="istaCustomerId">The ista customer id.</param>
		/// <param name="newRateAmount">The new rate amount.</param>
		/// <param name="effectiveDate">The effective date.</param>
		/// <returns></returns>
		public static bool UpdateAccountRateAmount( int istaCustomerId, decimal newRateAmount, DateTime effectiveDate )
		{
			return RateDueAccountsService.UpdateAccountRate( istaCustomerId, newRateAmount, effectiveDate, null );
		}

		/// <summary>
		/// Updates the account rate amount.
		/// </summary>
		/// <param name="istaCustomerId">The ista customer id.</param>
		/// <param name="newRateAmount">The new rate amount.</param>
		/// <param name="effectiveDate">The effective date.</param>
		/// <param name="expirationDate">The expiration date.</param>
		/// <returns></returns>
		private static bool UpdateAccountRate( int istaCustomerId, decimal newRateAmount, DateTime effectiveDate, DateTime? expirationDate )
		{
			bool success = false;
			try
			{
				IstaBillingService.Rate billingService = new LibertyPower.DataAccess.WebServiceAccess.IstaWebService.IstaBillingService.Rate();
				billingService.Url = Helper.IstaBillingWebService;
				string clientIdentifier = Helper.IstaClientGuid;

				UsernameToken token = new UsernameToken( clientIdentifier, clientIdentifier, PasswordOption.SendNone );

				billingService.RequestSoapContext.Security.Tokens.Add( token );
				billingService.RequestSoapContext.Security.Elements.Add( new MessageSignature( token ) );
				if( expirationDate.HasValue )
					billingService.UpdateRateAmount( istaCustomerId, newRateAmount, effectiveDate, expirationDate.Value );
				else
					billingService.UpdateRateAmount( istaCustomerId, newRateAmount, effectiveDate );
				success = true;
			}
			catch( SoapException )
			{
				success = false;
			}
			catch( Exception exception )
			{
				throw exception;
			}
			return success;
		}



	}
}

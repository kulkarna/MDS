using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.Web.Services2.Security.Tokens;
using Microsoft.Web.Services2.Security;
using System.Web.Services;
using System.Web.Services.Protocols;

namespace LibertyPower.DataAccess.WebServiceAccess.IstaWebService
{
    /// <summary>
    /// Invoice Ista Web Service
    /// </summary>
	public static class InvoiceService
	{
		private static IstaInvoiceService.InvoiceService invoiceService;

		static InvoiceService()
		{
			invoiceService = new IstaInvoiceService.InvoiceService();
			invoiceService.Url = Helper.IstaInvoiceWebService;

			string clientIdentifier = Helper.IstaClientGuid;
			UsernameToken token = new UsernameToken( clientIdentifier, clientIdentifier, PasswordOption.SendNone );

			invoiceService.RequestSoapContext.Security.Tokens.Add( token );
			invoiceService.RequestSoapContext.Security.Elements.Add( new MessageSignature( token ) );

		}


		/// <summary>
		/// Submits the invoice to ISTA for processing
		/// </summary>
		/// <param name="customerID">ISTA Customer ID</param>
		/// <param name="accountNumber">Liberty Power Account Number</param>
		/// <param name="etfAmount">Amount to be invoiced (can be negative to indicate waive)</param>
		/// <param name="doNotPrint">If true, actual invoice will be send to customer, if false customer has already paid.</param>
		/// <returns></returns>
		public static string SubmitEtfInvoice( int customerID, string accountNumber, Decimal etfAmount, bool doNotPrint )
		{
			IstaInvoiceService.ETFSpecialCharge etfSpecialCharge = new IstaInvoiceService.ETFSpecialCharge();
			etfSpecialCharge.CustomerID = customerID;
			etfSpecialCharge.ESIID = accountNumber;
			etfSpecialCharge.Amount = etfAmount;
			etfSpecialCharge.DoNotPrint = doNotPrint;

			string istaInvoiceNumber = null;
			try
			{
				//Web Service method does not return a value
				IstaInvoiceService.ETFSpecialCharge[] etfSpecialChargeList = new IstaInvoiceService.ETFSpecialCharge[1];
				etfSpecialChargeList[0] = etfSpecialCharge;
				invoiceService.CreateETFSpecialCharge( ref etfSpecialChargeList );

				if ( etfSpecialChargeList[0].InvoiceID.HasValue )
				{
					istaInvoiceNumber = etfSpecialChargeList[0].InvoiceID.ToString();
				}
				if ( String.IsNullOrEmpty( istaInvoiceNumber ) )
				{
					throw new Exception( "Submission to ISTA was successful, but ISTA did not return an InvoiceNumber" );
				}
			}
			catch ( SoapException ex )
			{
				throw new Exception( "Soap Exception: " + ex.Detail.InnerText );
			}
			catch ( Exception ex )
			{
				throw ex;
			}

			return istaInvoiceNumber;
		}

	}
}

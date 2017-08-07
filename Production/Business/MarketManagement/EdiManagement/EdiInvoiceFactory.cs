using System;
using System.Collections.Generic;
using System.Text;
using LibertyPower.DataAccess.WebServiceAccess.IstaWebService;
using LibertyPower.DataAccess.SqlAccess.IstaSql;

namespace LibertyPower.Business.MarketManagement.EdiManagement
{
	public static class EdiInvoiceFactory
	{

		public static string SubmitEtfInvoice( string accountNumber, decimal etfAmount, bool isPaid )
		{
			//Get customer id from ISTA database
			int customerID = EdiEnrollmentFactory.GetIstaCustIDByAccountNumber( accountNumber );

			bool doNotPrint = false;
			if ( isPaid )
			{
				doNotPrint = true;
			}

			string istaInvoiceNumber = InvoiceService.SubmitEtfInvoice( customerID, accountNumber, etfAmount, doNotPrint );
			return istaInvoiceNumber;
		}

	}
}

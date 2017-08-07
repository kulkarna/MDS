using System;
using System.Collections.Generic;
using System.Text;
using LibertyPower.DataAccess.WebServiceAccess.IstaWebService;

namespace LibertyPower.Business.MarketManagement.EdiManagement
{
	public static class EdiCustomerFactory
	{
		public static void UpdateCustomer( int customerID, string customerName, string lastName, string firstName, string middleName, string dba, int billingCustomerID, int masterCustomerID, string billingContact, string billingAddress1, string billingAddress2, string billingCity, string billingState, string billingZip, string billingPhone, string billingEmail, string customerGroupName )
		{
			////Get customer id from ISTA database
			//int customerID = GetIstaCustIDByAccountNumber( accountNumber );
			CustomerService.UpdateCustomer( customerID, customerName, lastName, firstName, middleName, dba, billingCustomerID, masterCustomerID, billingContact, billingAddress1, billingAddress2, billingCity, billingState, billingZip, billingPhone, billingEmail, customerGroupName );

		}

	}
}

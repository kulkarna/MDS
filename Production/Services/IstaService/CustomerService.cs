using System;
using System.Collections.Generic;
using System.Text;
using System.Web;
using System.Configuration;
using Microsoft.Web.Services2.Security.Tokens;
using Microsoft.Web.Services2.Security;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Data;

namespace LibertyPower.DataAccess.WebServiceAccess.IstaWebService
{
    /// <summary>
    /// Customer Service Ista Web Service
    /// </summary>
	public static class CustomerService
	{
		private static IstaCustomerService.CustomerService customerService;

		static CustomerService()
		{
			customerService = new IstaCustomerService.CustomerService();
			customerService.Url = Helper.IstaCustomerWebService;
			//"http://uat.ws.libertypowerbilling.com/CustomerService.asmx"

			string clientIdentifier = Helper.IstaClientGuid;
			UsernameToken token = new UsernameToken( clientIdentifier, clientIdentifier, PasswordOption.SendNone );

			customerService.RequestSoapContext.Security.Tokens.Add( token );
			customerService.RequestSoapContext.Security.Elements.Add( new MessageSignature( token ) );

		}

        /// <summary>
        /// Updates the customer.
        /// </summary>
        /// <param name="customerID">The customer ID.</param>
        /// <param name="customerName">Name of the customer.</param>
        /// <param name="lastName">The last name.</param>
        /// <param name="firstName">The first name.</param>
        /// <param name="middleName">Name of the middle.</param>
        /// <param name="dba">The dba.</param>
        /// <param name="billingCustomerID">The billing customer ID.</param>
        /// <param name="masterCustomerID">The master customer ID.</param>
        /// <param name="billingContact">The billing contact.</param>
        /// <param name="billingAddress1">The billing address1.</param>
        /// <param name="billingAddress2">The billing address2.</param>
        /// <param name="billingCity">The billing city.</param>
        /// <param name="billingState">State of the billing.</param>
        /// <param name="billingZip">The billing zip.</param>
        /// <param name="billingPhone">The billing phone.</param>
        /// <param name="billingEmail">The billing email.</param>
        /// <param name="customerGroupName">Name of the customer group.</param>
        /// <returns></returns>
		public static bool UpdateCustomer( int customerID, string customerName, string lastName, string firstName, string middleName, string dba, int billingCustomerID, int masterCustomerID, string billingContact, string billingAddress1, string billingAddress2, string billingCity, string billingState, string billingZip, string billingPhone, string billingEmail, string customerGroupName )
		{

			IstaCustomerService.Customer customer = new IstaCustomerService.Customer();
			customer.CustomerID = customerID;
			customer.CustomerName = customerName;
			customer.LastName = lastName;
			customer.FirstName = firstName;
			customer.MiddleName = middleName;
			customer.DBA = dba;
			customer.BillingCustomerID = billingCustomerID;
			customer.MasterCustomerID = masterCustomerID;
			customer.BillingContact = billingContact;
			customer.BillingAddress1 = billingAddress1;
			customer.BillingAddress2 = billingAddress2;
			customer.BillingCity = billingCity;
			customer.BillingState = billingState;
			customer.BillingZip = billingZip;
			customer.BillingPhone = billingPhone;
			customer.BillingEmail = billingEmail;
			customer.CustomerGroupName = customerGroupName;

			bool result;
			try
			{
				result = customerService.UpdateCustomerInfo( customer );
			}
			catch ( SoapException ex )
			{
				throw new Exception( "Soap Exception: " + ex.Detail.InnerText );
			}
			catch ( Exception ex )
			{
				throw ex;
			}
			return result;
		}

	}






}

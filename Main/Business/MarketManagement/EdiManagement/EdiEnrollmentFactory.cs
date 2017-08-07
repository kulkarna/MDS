using System;
using System.Data;
using System.Collections.Generic;
using System.Text;
using LibertyPower.DataAccess.WebServiceAccess.IstaWebService;
using LibertyPower.DataAccess.SqlAccess.IstaSql;

namespace LibertyPower.Business.MarketManagement.EdiManagement
{
	public static class EdiEnrollmentFactory
	{
#pragma warning disable 0612 // LibertyPower.DataAccess.SqlAccess.IstaSql.IstaSql.GetCustIDByAccountNumber(string accountNumber)' is obsolete.  Refactor to GetCustIDByAccountAndUtility(string accountNumber, string utilityId);

        #region De-Enrollment

        public static void Deenroll(string accountNumber, DateTime requestDate, string userName)
        {
            Deenroll(false, 0, accountNumber, requestDate, userName);
        }

        public static void Deenroll(bool sendToEsg, int utilityId, string accountNumber, DateTime requestDate, string userName)
        {
            // Get customer id from ISTA database
            int customerID = 0;
            if(!sendToEsg)
                customerID = GetIstaCustIDByAccountNumber(accountNumber);

            // Use hardcoded B38 Status code  
            LibertyPower.DataAccess.WebServiceAccess.IstaWebService.IstaCustomerService.DropStatusCodeOptions statusCode = LibertyPower.DataAccess.WebServiceAccess.IstaWebService.IstaCustomerService.DropStatusCodeOptions.B38;
            string statusReason = "Dropped by customer request"; //Use hardcoded statusReason

            // Call WebService to deenroll account
            EnrollmentService.DeenrollAccount(customerID, utilityId, accountNumber, requestDate, statusCode, statusReason);
        }

        #endregion

        #region Re-Enrollment

        public static void Reenroll(string accountNumber, DateTime requestDate, string userName, bool creditInsuranceFlag)
		{
			// Get customer id from ISTA database
			int customerID = GetIstaCustIDByAccountNumber( accountNumber );

			// Call WebService to deenroll account
            EnrollmentService.ReenrollAccount(customerID, accountNumber, requestDate, creditInsuranceFlag);
		}

        public static void Reenroll(string accountNumber, DateTime requestDate, string userName, DateTime startDate, DateTime endDate, bool creditInsuranceFlag)
        {
            Reenroll(false, 0, accountNumber, requestDate, userName, startDate, endDate, creditInsuranceFlag, 0, null);
        }

        public static void Reenroll(
            bool sendToEsg,
            int utilityId,
            string accountNumber,
            DateTime requestDate,
            string userName,
            DateTime startDate,
            DateTime endDate,
            bool creditInsuranceFlag,
            int currentContractId,
            string rateCode
            )
        {
            // Get customer id from ISTA database
            int customerID = 0;
            if(!sendToEsg)
                customerID = GetIstaCustIDByAccountNumber(accountNumber);

            // Call WebService to deenroll account
            EnrollmentService.ReenrollAccount(customerID, utilityId, accountNumber, requestDate, startDate, endDate, creditInsuranceFlag, currentContractId, rateCode);
        }

        #endregion

        public static void Enroll( DataRow accountData, DateTime startDate, string enrollmentType )
		{
			//Call WebService to Enroll account
			EnrollmentService.EnrollAccount( accountData, startDate, enrollmentType );
		}

		public static int GetIstaCustIDByAccountNumber( string accountNumber )
		{
			Object obj = IstaSql.GetCustIDByAccountNumber( accountNumber );
			if( obj == null )
			{
				throw new Exception( "Account " + accountNumber + " does not exist at ISTA.  Might need to change the status to 'create utility file'." );
			}
			return int.Parse( obj.ToString() );
		}

	}
}

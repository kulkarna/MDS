using System;
using System.Collections.Generic;
using System.Text;
using System.Web;
using System.Configuration;
//using Microsoft.Web.Services3.Security.Tokens;
//using Microsoft.Web.Services3.Security;
using Microsoft.Web.Services2.Security.Tokens;
using Microsoft.Web.Services2.Security;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Data;
using System.Xml.Serialization;
using System.IO;
using System.Xml;

namespace LibertyPower.DataAccess.WebServiceAccess.IstaWebService
{

    /// <summary>
    /// Encapsulates Ista web service enrollment service
    /// </summary>

    public static class EnrollmentService
    {
        private static IstaCustomerService.CustomerService customerService;
        private static IstaEnrollmentService.EnrollmentService enrollmentService;

        static EnrollmentService()
        {

            customerService = new IstaCustomerService.CustomerService();
            customerService.Url = Helper.IstaCustomerWebService;
            //"http://uat.ws.libertypowerbilling.com/CustomerService.asmx"

            enrollmentService = new IstaWebService.IstaEnrollmentService.EnrollmentService();
			enrollmentService.Url = Helper.IstaEnrollmentWebService;
            //"http://uat.ws.libertypowerbilling.com/EnrollmentService.asmx"

            string clientIdentifier = Helper.IstaClientGuid;
            UsernameToken token = new UsernameToken(clientIdentifier, clientIdentifier, PasswordOption.SendNone);

            customerService.RequestSoapContext.Security.Tokens.Add(token);
            customerService.RequestSoapContext.Security.Elements.Add(new MessageSignature(token));

            token = new UsernameToken(clientIdentifier, clientIdentifier, PasswordOption.SendNone);

            enrollmentService.RequestSoapContext.Security.Tokens.Add(token);
            enrollmentService.RequestSoapContext.Security.Elements.Add(new MessageSignature(token));

        }

        /// <summary>
        /// Sends De-Enrollment request to Ista
        /// </summary>
        /// <param name="customerID">Ista's internal customer id</param>
        /// <param name="accountNumber">Liberty Power account number</param>
        /// <param name="requestDate">De-Enrollment request date</param>
        /// <param name="statusCode">StatusCode required by Ista</param>
        /// <param name="statusReason">Description of StatusCode</param>
        public static void DeenrollAccount(int customerID, string accountNumber, DateTime requestDate, IstaCustomerService.DropStatusCodeOptions statusCode, string statusReason)
        {
            IstaCustomerService.DropRequest dropRequest = new IstaCustomerService.DropRequest();
            dropRequest.CustomerID = customerID;
            dropRequest.ESIID = accountNumber;
            dropRequest.RequestDate = requestDate;
            dropRequest.StatusCode = statusCode;
            dropRequest.StatusReason = statusReason;

            try
            {
                //Web Service method does not return a value
                customerService.CreateDropRequest(dropRequest);
            }
            catch (SoapException ex)
            {
                throw new Exception("Soap Exception: " + ex.Detail.InnerText);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        /// <summary>
        /// Reenroll specified account
        /// </summary>
        /// <param name="customerID"></param>
        /// <param name="accountNumber"></param>
        /// <param name="requestDate"></param>
        public static void ReenrollAccount(int customerID, string accountNumber, DateTime requestDate, bool creditInsuranceFlag)
        {
            try
            {
                ReenrollAccount(customerID, accountNumber, requestDate, null, null, creditInsuranceFlag);
            }
            catch (Exception ex)
            {
                if (ex.Message.Contains("Could not find custID"))
                    throw new Exception("Account does not exist at ISTA.  Might need to change the status to 'create utility file'.");
                if (ex.Message.Contains("ESIID cannot be found"))
                    throw new Exception("Account is in status 'Active' at ISTA which prevents the reenrollment from being sent.  Please confirm this status with ISTA.  If they are correct, account at Liberty needs to be updated to Enrolled.");
                if (ex.Message.Contains("Premise record is currently active"))
                    throw new Exception("Account at ISTA has an end date which is blank or in the future.  Therefore, the account appears to be active and prevents the reenrollment from being sent.  Please verify this date value at ISTA.");
                throw ex;
            }
        }

        /// <summary>
        /// Reenroll specified account
        /// </summary>
        /// <param name="customerID"></param>
        /// <param name="accountNumber"></param>
        /// <param name="requestDate"></param>
        /// <param name="contractStartDate"></param>
        /// <param name="contractStopDate"></param>
        public static void ReenrollAccount(int customerID, string accountNumber, DateTime requestDate, DateTime? contractStartDate, DateTime? contractStopDate, bool creditInsuranceFlag)
        {
            IstaEnrollmentService.ReEnrollment reEnrollmentRequest = new IstaEnrollmentService.ReEnrollment();
            reEnrollmentRequest.CustomerID = customerID;
            reEnrollmentRequest.ESIID = accountNumber;
            reEnrollmentRequest.RequestDate = requestDate;
            if (contractStartDate != null)
                reEnrollmentRequest.ContractStartDate = (DateTime)contractStartDate;
            if (contractStopDate != null)
                reEnrollmentRequest.ContractStopDate = (DateTime)contractStopDate;

            reEnrollmentRequest.CreditInsuranceFlag = creditInsuranceFlag;
            try
            {
                //Web Service method does not return a value
                enrollmentService.SubmitReEnrollment(reEnrollmentRequest);
            }
            catch (SoapException ex)
            {
                if (ex.Message.Contains("Could not find custID"))
                    throw new Exception("Account does not exist at ISTA.  Might need to change the status to 'create utility file'.");
                if (ex.Message.Contains("ESIID cannot be found"))
                    throw new Exception("Account is in status 'Active' at ISTA which prevents the reenrollment from being sent.  Please confirm this status with ISTA.  If they are correct, account at Liberty needs to be updated to Enrolled.");
                if (ex.Message.Contains("Premise record is currently active"))
                    throw new Exception("Account at ISTA has an end date which is blank or in the future.  Therefore, the account appears to be active and prevents the reenrollment from being sent.  Please verify this date value at ISTA.");
                throw new Exception("Soap Exception: " + ex.Detail.InnerText);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// Send Enrollment to Ista
        /// </summary>
        /// <param name="accountData"></param>
        /// <param name="startDate"></param>
        /// <param name="enrollmentType"></param>
        public static void EnrollAccount(DataRow accountData, DateTime startDate, string enrollmentType)
        {
            IstaEnrollmentService.EnrollCustomer enrollmentRequest = HelperMethods.BuildCustomer(accountData, startDate, enrollmentType);

            try
            {
                int customerID = enrollmentService.CreateEnrollment(enrollmentRequest);
                //Web Service method does not return a value
                enrollmentService.ProcessEnrollment(customerID);
            }
            catch (SoapException ex)
            {
                throw new Exception("Soap Exception: " + ex.Detail.InnerText);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}

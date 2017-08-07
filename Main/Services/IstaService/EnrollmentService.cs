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
using System.Linq;

namespace LibertyPower.DataAccess.WebServiceAccess.IstaWebService
{

    /// <summary>
    /// Encapsulates Ista web service enrollment service
    /// </summary>

    public static class EnrollmentService
    {
        private const string ENROLLMENT_APPLICATION_NAME = "Enrollment";

        private static IstaCustomerService.CustomerService customerService;
        private static IstaEnrollmentService.EnrollmentService enrollmentService;
        private static RequestService.Request requestService;

        static EnrollmentService()
        {

            customerService = new IstaCustomerService.CustomerService();
            customerService.Url = Helper.IstaCustomerWebService;
            //"http://uat.ws.libertypowerbilling.com/CustomerService.asmx"

            enrollmentService = new IstaWebService.IstaEnrollmentService.EnrollmentService();
			enrollmentService.Url = Helper.IstaEnrollmentWebService;
            //"http://uat.ws.libertypowerbilling.com/EnrollmentService.asmx"

            requestService = new RequestService.Request();

            string clientIdentifier = Helper.IstaClientGuid;
            UsernameToken token = new UsernameToken(clientIdentifier, clientIdentifier, PasswordOption.SendNone);

            customerService.RequestSoapContext.Security.Tokens.Add(token);
            customerService.RequestSoapContext.Security.Elements.Add(new MessageSignature(token));

            token = new UsernameToken(clientIdentifier, clientIdentifier, PasswordOption.SendNone);

            enrollmentService.RequestSoapContext.Security.Tokens.Add(token);
            enrollmentService.RequestSoapContext.Security.Elements.Add(new MessageSignature(token));
        }

        #region De-Enrollment

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
            DeenrollAccount(customerID, 0, accountNumber, requestDate, statusCode, statusReason);
        }

        /// <summary>
        /// Sends De-Enrollment request to Ista or ESG, according to application configuration.
        /// </summary>
        /// <param name="customerID">Ista's internal customer id</param>
        /// <param name="utilityId">Liberty power account utility id.</param>
        /// <param name="accountNumber">Liberty Power account number</param>
        /// <param name="requestDate">De-Enrollment request date</param>
        /// <param name="statusCode">StatusCode required by Ista</param>
        /// <param name="statusReason">Description of StatusCode</param>
        public static void DeenrollAccount(int customerID, int utilityId, string accountNumber, DateTime requestDate, IstaCustomerService.DropStatusCodeOptions statusCode, string statusReason)
        {
            if (Helper.UseEsgForDeEnrollmentRequest)
            {
                RequestService.DeEnrollmentRequestDTO deEnrollmentRequestParams = new RequestService.DeEnrollmentRequestDTO
                {
                    ApplicationName = ENROLLMENT_APPLICATION_NAME,
                    UtilityId = utilityId,
                    AccountNumber = accountNumber,
                    EffectiveDate = requestDate.CompareTo(DateTime.MinValue) == 0 ? null : requestDate.ToString("yyyy-MM-dd"),

                    UtilityIdSpecified = true,
                };

                RequestService.ResponseDTO[] deEnrollmentRequestResponse = requestService.DeEnroll(deEnrollmentRequestParams);
                HelperMethods.ValidateRequestServiceResponse(deEnrollmentRequestResponse);
            }
            else
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
        }

        #endregion

        #region Re-Enrollment

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
            ReenrollAccount(customerID, 0, accountNumber, requestDate, contractStartDate, contractStopDate, creditInsuranceFlag, 0, null);
        }

        /// <summary>
        /// Reenroll specified account
        /// </summary>
        /// <param name="customerID"></param>
        /// <param name="utilityId"></param>
        /// <param name="accountNumber"></param>
        /// <param name="requestDate"></param>
        /// <param name="contractStartDate"></param>
        /// <param name="contractStopDate"></param>
        /// <param name="creditInsuranceFlag"></param>
        public static void ReenrollAccount(
            int customerID,
            int utilityId,
            string accountNumber,
            DateTime requestDate,
            DateTime? contractStartDate,
            DateTime? contractStopDate,
            bool creditInsuranceFlag,
            int currentContractId,
            string rateCode
            )
        {
            if (Helper.UseEsgForReEnrollmentRequest)
            {
                var reEnrollmentRequestParams = new RequestService.ReEnrollmentRequestDTO
                {
                    ApplicationName = ENROLLMENT_APPLICATION_NAME,
                    UtilityId = utilityId,
                    AccountNumber = accountNumber,
                    EffectiveDate = requestDate.CompareTo(DateTime.MinValue) == 0 ? null : requestDate.ToString("yyyy-MM-dd"),
                    ContractId = currentContractId,
                    RateCode = string.IsNullOrWhiteSpace(rateCode) ? null : rateCode.Trim(),

                    UtilityIdSpecified = true,
                    ContractIdSpecified = true,
                };

                var reEnrollmentRequestResponse = requestService.ReEnroll(reEnrollmentRequestParams);
                HelperMethods.ValidateRequestServiceResponse(reEnrollmentRequestResponse);
            }
            else
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
        }

        #endregion

        #region Enrollment

        /// <summary>
        /// Send Enrollment to Ista
        /// </summary>
        /// <param name="accountData"></param>
        /// <param name="startDate"></param>
        /// <param name="enrollmentType"></param>
        public static void EnrollAccount(DataRow accountData, DateTime startDate, string enrollmentType)
        {
            if (Helper.UseEsgForEnrollmentRequest)
            {
                #region Data parsing

                // 1. Utility Id
                var utilityId = HelperMethods.GetIntValueFromColumnOfDataRow(accountData, "utility_id");

                // 2. Account Number
                var accountNumber = HelperMethods.GetStringValueFromColumnOfDataRow(accountData, "account_number");

                // 3. Enrollment Type
                var requestEnrollmentType = "Standard";
                if (enrollmentType == "OffCycle" || enrollmentType == "OffCycleNoPostcard")
                    requestEnrollmentType = "Self Selected";
                if (enrollmentType == "MoveIn" || enrollmentType == "PriorityMoveIn")
                    requestEnrollmentType = "Move In";

                // 4. Effective Date
                var effectiveDate = startDate.CompareTo(DateTime.MinValue) == 0 ? null : startDate.ToString("yyyy-MM-dd");

                // 5. Contract Id
                var currentContractId = HelperMethods.GetIntValueFromColumnOfDataRow(accountData, "CurrentContractId");

                // 6. Rate Code
                var rateCode = HelperMethods.GetStringValueFromColumnOfDataRow(accountData, "ratecode");
                if (string.IsNullOrWhiteSpace(rateCode))
                    rateCode = null;
                else
                    rateCode = rateCode.Trim();

                // 7. Is Priority Move In?
                var priorityMoveIn = (requestEnrollmentType == "Move In") ? (bool?)(enrollmentType == "PriorityMoveIn") : null;

                #endregion

                var enrollmentRequestParams = new RequestService.EnrollmentRequestDTO
                {
                    ApplicationName = ENROLLMENT_APPLICATION_NAME,
                    UtilityId = utilityId,
                    AccountNumber = accountNumber,
                    EnrollmentType = requestEnrollmentType,
                    EffectiveDate = effectiveDate,
                    ContractId = currentContractId,
                    RateCode = rateCode,
                    PriorityMoveIn = priorityMoveIn,

                    UtilityIdSpecified = true,
                    ContractIdSpecified = true,
                    PriorityMoveInSpecified = true,
                };

                RequestService.ResponseDTO[] enrollmentRequestResponse = requestService.Enroll(enrollmentRequestParams);
                HelperMethods.ValidateRequestServiceResponse(enrollmentRequestResponse);
            }
            else
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

        #endregion
    }
}

using System;
using System.Collections.Generic;
using Common.Logging;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Web;
using Microsoft.Web.Services2.Security.Tokens;
using Microsoft.Web.Services2.Security;
using System.Web.Services;
using System.Web.Services.Protocols;
using LibertyPower.DataAccess.SqlAccess.AccountSql;
using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;
using LibertyPower.DataAccess.WebServiceAccess.IstaWebService.RequestService;
using LibertyPower.DataAccess.WebServiceAccess.IstaWebService.Business;


namespace LibertyPower.DataAccess.WebServiceAccess.IstaWebService
{
    /// <summary>
    /// Usage service
    /// </summary>
    public static class UsageService
    {
        private static IstaEnrollmentService.EnrollmentService wsvcIsta;
        //private static RequestClient wsvcRequest;
        private static RequestService.Request wsvcRequest;
        const string NAMESPACE = "LibertyPower.DataAccess.WebServiceAccess.IstaWebService";
        const string CLASS = "UsageService";
        private static string strUseESGForUsageRequest = string.Empty;
        //private static UtilityLogging.ILogger _logger;
        private static readonly ILog _logger = LogManager.GetCurrentClassLogger();
        private static IUtilityBO utilityBO;

        static UsageService()
        {
            DateTime beginDate = DateTime.Now;
            string method = string.Format("{0}.{1}.UsageService()", NAMESPACE, CLASS);
            try
            {
                //_logger = new Logger();//UtilityUnityLogging.UnityLoggerGenerator.GenerateLogger();
                _logger.Info(string.Format("{0} - {1} BEGIN", beginDate.ToString(), method));

                wsvcIsta = new IstaWebService.IstaEnrollmentService.EnrollmentService();

                wsvcIsta.Url = Helper.IstaEnrollmentWebService;
                strUseESGForUsageRequest = Helper.UseESGForUsageRequest;
                string clientIdentifier = Helper.IstaClientGuid;
                UsernameToken token = new UsernameToken(clientIdentifier, clientIdentifier, PasswordOption.SendNone);

                wsvcIsta.RequestSoapContext.Security.Tokens.Add(token);
                wsvcIsta.RequestSoapContext.Security.Elements.Add(new MessageSignature(token));

                utilityBO = new UtilityBO();

                _logger.Info(string.Format("{0} - {1} END; Execute Time (ms):{2}", DateTime.Now.ToString(), method, DateTime.Now.Subtract(beginDate).TotalMilliseconds.ToString()));
            }
            catch (Exception exc)
            {
                _logger.Error(string.Format("{0} - {1} ERROR {3}; Execute Time (ms):{2}", DateTime.Now.ToString(), method, DateTime.Now.Subtract(beginDate).TotalMilliseconds.ToString(), NullSafeString(exc.Message)));
                throw;
            }
        }

        /// <summary>
        ///  Submits historical usage request to ISTA
        /// </summary>
        /// <param name="accountNumber">utility account number</param>
        /// <param name="domainUser"></param>
        /// <param name="AppName"></param>
        /// <param name="utility"></param>
        public static void SubmitHistoricalUsageRequest(DataRow dr, string domainUser, string appName, string usageType = null)
        {
            SubmitUsageRequest(dr, domainUser, appName, usageType);
        }

        /// <summary>
        ///  Submits historical usage request to ISTA
        /// </summary>
        /// <param name="accountNumber">utility account number</param>
        /// <param name="domainUser"></param>
        /// <param name="AppName"></param>
        /// <param name="utility"></param>
        public static void SubmitHistoricalUsageRequest(string accountNumber, string domainUser, string AppName, string utility)
        {
            DataRow dr = null;
            //DataSet ds = AccountSql.GetISTAEnrollmentServiceDataByAccountNumber( accountNumber );
            DataSet ds = AccountSql.GetISTAEnrollmentServiceDataByAccountNumberAndUtility(accountNumber, utility);
            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                dr = ds.Tables[0].Rows[0];
            else
                return;

            SubmitUsageRequest(dr, domainUser, AppName);
        }


        private static void SubmitUsageRequest(DataRow dr, string domainUser, string AppName)
        {
            SubmitUsageRequest(dr, domainUser, AppName, null);
        }
        private static string UsageRequestDTOToString(UsageRequestDTO usageRequestDTO)
        {
            StringBuilder returnValue = new StringBuilder("usageRequestDTO == NULL VALUE");
            if (usageRequestDTO != null)
            {
                returnValue = new StringBuilder("usageRequestDTO:{");

                returnValue.AppendFormat("ApplicationName:{0}", NullSafeString(usageRequestDTO.ApplicationName));
                returnValue.AppendFormat(",AccountNumber:{0}", NullSafeString(usageRequestDTO.AccountNumber));
                returnValue.AppendFormat(",NameKey:{0}", NullSafeString(usageRequestDTO.NameKey));
                returnValue.AppendFormat(",BillingAccount:{0}", NullSafeString(usageRequestDTO.BillingAccount));
                returnValue.AppendFormat(",UtilityId:{0}", NullSafeString(usageRequestDTO.UtilityId));
                returnValue.AppendFormat(",UsageType:{0}", NullSafeString(usageRequestDTO.UsageType));
            }
            return returnValue.ToString();
        }
        private static string UsageResponseDTOToString(ResponseDTO usageResponseDTO)
        {
            StringBuilder returnValue = new StringBuilder("usageResponseDTO == NULL VALUE");
            if (usageResponseDTO != null)
            {
                returnValue = new StringBuilder("usageResponseDTO:{");
                returnValue.AppendFormat("  UtilityId:{0}", NullSafeString(usageResponseDTO.UtilityId));
                returnValue.AppendFormat(", UtilityCode:{0}", NullSafeString(usageResponseDTO.UtilityCode));
                returnValue.AppendFormat(", AccountNumber:{0}", NullSafeString(usageResponseDTO.AccountNumber));
                returnValue.AppendFormat(", TransactionRequestId:{0}", NullSafeString(usageResponseDTO.TransactionRequestId));
                returnValue.AppendFormat(", MessageCode:{0}", NullSafeString(usageResponseDTO.MessageCode));
                returnValue.AppendFormat(", Message:{0}", NullSafeString(usageResponseDTO.Message));
            }
            return returnValue.ToString();
        }

        private static string IstaCustomerToString(IstaEnrollmentService.EnrollCustomer enrollCustomer)
        {
            StringBuilder returnValue = new StringBuilder("enrollCustomer == NULL VALUE");
            if (enrollCustomer != null)
            {
                returnValue = new StringBuilder("enrollCustomer:{");

                returnValue.AppendFormat("ApplyLateFees:{0}", NullSafeString(enrollCustomer.ApplyLateFees));
                returnValue.AppendFormat(",ARTerms:{0}", NullSafeString(enrollCustomer.ARTerms));
                returnValue.AppendFormat(",BillingAddress1:{0}", NullSafeString(enrollCustomer.BillingAddress1));
                returnValue.AppendFormat(",BillingAddress2:{0}", NullSafeString(enrollCustomer.BillingAddress2));
                returnValue.AppendFormat(",BillingCity:{0}", NullSafeString(enrollCustomer.BillingCity));
                returnValue.AppendFormat(",BillingContact:{0}", NullSafeString(enrollCustomer.BillingContact));
                returnValue.AppendFormat(",BillingCustomerID:{0}", NullSafeString(enrollCustomer.BillingCustomerID));
                returnValue.AppendFormat(",BillingEmail:{0}", NullSafeString(enrollCustomer.BillingEmail));
                returnValue.AppendFormat(",BillingPhone:{0}", NullSafeString(enrollCustomer.BillingPhone));
                returnValue.AppendFormat(",BillingState:{0}", NullSafeString(enrollCustomer.BillingState));
                returnValue.AppendFormat(",BillingType:{0}", NullSafeString(enrollCustomer.BillingType));
                returnValue.AppendFormat(",BillingZip:{0}", NullSafeString(enrollCustomer.BillingZip));
                returnValue.AppendFormat(",Comments:{0}", NullSafeString(enrollCustomer.Comments));
                returnValue.AppendFormat(",ContractEndDate:{0}", NullSafeString(enrollCustomer.ContractEndDate));
                returnValue.AppendFormat(",ContractStartDate:{0}", NullSafeString(enrollCustomer.ContractStartDate));
                returnValue.AppendFormat(",CreditInsuranceFlag:{0}", NullSafeString(enrollCustomer.CreditInsuranceFlag));
                returnValue.AppendFormat(",CustomerAccountNumber:{0}", NullSafeString(enrollCustomer.CustomerAccountNumber));
                returnValue.AppendFormat(",CustomerGroup:{0}", NullSafeString(enrollCustomer.CustomerGroup));
                returnValue.AppendFormat(",CustomerName:{0}", NullSafeString(enrollCustomer.CustomerName));
                returnValue.AppendFormat(",CustomerType:{0}", NullSafeString(enrollCustomer.CustomerType.ToString()));
                returnValue.AppendFormat(",DBA:{0}", NullSafeString(enrollCustomer.DBA));
                returnValue.AppendFormat(",DigitalSignature:{0}", NullSafeString(enrollCustomer.DigitalSignature));
                returnValue.AppendFormat(",DisableTransactions:{0}", NullSafeString(enrollCustomer.DisableTransactions));
                returnValue.AppendFormat(",EnrollDefaultRate:{0}", NullSafeString(enrollCustomer.EnrollDefaultRate.LDCRateCode) + NullSafeString(enrollCustomer.EnrollDefaultRate.PlanType) + NullSafeString(enrollCustomer.EnrollDefaultRate.SwitchDate));
                returnValue.AppendFormat(",EnrollPremise:{0}", NullSafeString(enrollCustomer.EnrollPremise));
                returnValue.AppendFormat(",EnrollRate:{0}", NullSafeString(enrollCustomer.EnrollRate));
                returnValue.AppendFormat(",ESPDuns:{0}", NullSafeString(enrollCustomer.ESPDuns));
                returnValue.AppendFormat(",FederalTaxId:{0}", NullSafeString(enrollCustomer.FederalTaxId));
                returnValue.AppendFormat(",FirstName:{0}", NullSafeString(enrollCustomer.FirstName));
                returnValue.AppendFormat(",HistoricalUsageType:{0}", NullSafeString(enrollCustomer.HistoricalUsageType));
                returnValue.AppendFormat(",IsLifeSupport:{0}", NullSafeString(enrollCustomer.IsLifeSupport));
                returnValue.AppendFormat(",IsSpanishBill:{0}", NullSafeString(enrollCustomer.IsSpanishBill));
                returnValue.AppendFormat(",IsTaxable:{0}", NullSafeString(enrollCustomer.IsTaxable));
                returnValue.AppendFormat(",LastName:{0}", NullSafeString(enrollCustomer.LastName));
                returnValue.AppendFormat(",LateFeeGracePeriod:{0}", NullSafeString(enrollCustomer.LateFeeGracePeriod));
                returnValue.AppendFormat(",LateFeeMaxAmount:{0}", NullSafeString(enrollCustomer.LateFeeMaxAmount));
                returnValue.AppendFormat(",LateFeeRate:{0}", NullSafeString(enrollCustomer.LateFeeRate));
                returnValue.AppendFormat(",MasterCustomerID:{0}", NullSafeString(enrollCustomer.MasterCustomerID));
                returnValue.AppendFormat(",MiddleName:{0}", NullSafeString(enrollCustomer.MiddleName));
                returnValue.AppendFormat(",NotificationWaiver:{0}", NullSafeString(enrollCustomer.NotificationWaiver));
                returnValue.AppendFormat(",PORFlag:{0}", NullSafeString(enrollCustomer.PORFlag));
                returnValue.AppendFormat(",PrintLayout:{0}", NullSafeString(enrollCustomer.PrintLayout.ToString()));
                returnValue.AppendFormat(",Salutation:{0}", NullSafeString(enrollCustomer.Salutation));
                returnValue.AppendFormat(",SubmitHURequest:{0}", NullSafeString(enrollCustomer.SubmitHURequest));
                returnValue.AppendFormat(",TDSPDuns:{0}}}", NullSafeString(enrollCustomer.TDSPDuns));
            }
            return returnValue.ToString();
        }

        private static string NullSafeNullableIntToString(int? value)
        {
            string returnValue = "NULL VALUE";
            if (value != null)
            {
                returnValue = value.ToString();
            }
            return returnValue;
        }

        private static string NullSafeString(object value)
        {
            string returnValue = "NULL VALUE";
            if (value != null)
            {
                returnValue = value.ToString();
            }
            return returnValue;
        }




        private static void SubmitUsageRequest(DataRow dr, string domainUser, string AppName, string UsageFlag = null)
        {
            DateTime beginDate = DateTime.Now;
            string method = string.Format("{0}.{1}.SubmitUsageRequest(DataRow dr, string domainUser:{2}, string AppName:{3}, string UsageFlag:{4} = null)", NAMESPACE, CLASS, NullSafeString(domainUser), NullSafeString(AppName), NullSafeString(UsageFlag));
            _logger.Info(string.Format("{0} - {1} BEGIN", beginDate.ToString(), method));

            try
            {
                //string HURequestType = string.Empty;
                IstaEnrollmentService.EnrollCustomer istaCustomer = new IstaEnrollmentService.EnrollCustomer();
                string accountNumber = Convert.ToString(dr["AccountNumber"]);
                string utilityCode = Convert.ToString(dr["utility"]);
                int iUseESGForUsageRequest = 0;
                int.TryParse(strUseESGForUsageRequest, out iUseESGForUsageRequest);
                int custId = 0;
                bool isIDR = false;
                try
                {
                    isIDR = UtilitySql.IsUtilityIdrEdiCapable(Convert.ToString(dr["utility"]));
                }
                catch { }

                istaCustomer = ServiceHelper.BuildCustomer(dr, DateTime.Now, "OnCycle", toEsg: (iUseESGForUsageRequest == 1));

                istaCustomer.EnrollPremise.TaxAssessmentList = ServiceHelper.GetIstaTaxAssessmentList((int)dr["taxcode"]);

                istaCustomer.SubmitHURequest = false;
                istaCustomer.HistoricalUsageType = "HU";
                if (!String.IsNullOrEmpty(UsageFlag))
                {
                    UsageFlag = UsageFlag.ToUpper();
                }

                switch (UsageFlag)
                {
                    case "HI":
                    case "HU":
                        istaCustomer.HistoricalUsageType = UsageFlag.ToUpper();
                        break;
                    default:
                        if (isIDR && dr["meter_type"].ToString().Equals("IDR"))
                        {
                            istaCustomer.HistoricalUsageType = "HI";
                        }
                        break;
                }

                //get the Request type: it is HI is utility is IDR EDI capable and meter type = IDR
                //bool isIDR = UtilitySql.IsUtilityIdrEdiCapable(dr["utility"].ToString());
                //if( dr["utility_duns"].ToString().Equals( "007909427AC", StringComparison.CurrentCultureIgnoreCase ) )
                //    HURequestType = "HI";

                //string HURequestType = "HU";
                //istaCustomer.HistoricalUsageType = "HU";
                switch (iUseESGForUsageRequest)
                {
                    case 0:
                        {
                            try
                            {
                                _logger.Info(string.Format("{0} - {1} CALLING custId = wsvcIsta.CreateEnrollment(istaCustomer:{2});", DateTime.Now.ToString(), method, IstaCustomerToString(istaCustomer)));
                                custId = wsvcIsta.CreateEnrollment(istaCustomer);
                                _logger.Info(string.Format("{0} - {1} CALLED custId = wsvcIsta.CreateEnrollment(istaCustomer:{2});", DateTime.Now.ToString(), method, IstaCustomerToString(istaCustomer)));

                                //send request
                                _logger.Info(string.Format("{0} - {1} CALLING wsvcIsta.CreateHistoricalUsageRequest(custId:{2}, istaCustomer.HistoricalUsageType:{3});", DateTime.Now.ToString(), method, NullSafeString(custId), istaCustomer == null ? "NULL" : NullSafeString(istaCustomer.HistoricalUsageType)));
                                wsvcIsta.CreateHistoricalUsageRequest(custId, istaCustomer.HistoricalUsageType);
                                _logger.Info(string.Format("{0} - {1} CALLED wsvcIsta.CreateHistoricalUsageRequest(custId:{2}, istaCustomer.HistoricalUsageType:{3});", DateTime.Now.ToString(), method, NullSafeString(custId), istaCustomer == null ? "NULL" : NullSafeString(istaCustomer.HistoricalUsageType)));

                                break;

                            }
                            catch (SoapException ex)
                            {
                                _logger.Error(string.Format("{0} - {1} ERROR; Soap Exception:Message={3} StackTrace={4} Execute Time (ms):{2}",
                                    DateTime.Now.ToString(),
                                    method,
                                    DateTime.Now.Subtract(beginDate).TotalMilliseconds.ToString(),
                                    ex == null || ex.Message == null ? "NULL" : ex.Message,
                                    ex == null || ex.StackTrace == null ? "NULL" : ex.StackTrace
                                    ));
                                throw new Exception("Soap Exception: " + ex.Message + "<br/>" +
                                    "<br/>" + ex.Detail.InnerText + "<br/>" +
                                    "<br/> Data Transmitted: <br/>" +
                                    "IDR= " + isIDR.ToString() + "<br/>" +
                                    "Request type = " + istaCustomer.HistoricalUsageType + "<br/>" +
                                    "ApplyLateFees = " + istaCustomer.ApplyLateFees + "<br/>" +
                                    "ARTerms = " + istaCustomer.ARTerms + "<br/>" +
                                    "BillingAddress1 = " + istaCustomer.BillingAddress1 + "<br/>" +
                                    "BillingAddress2 = " + istaCustomer.BillingAddress2 + "<br/>" +
                                    "BillingCity = " + istaCustomer.BillingCity + "<br/>" +
                                    "BillingContact = " + istaCustomer.BillingContact + "<br/>" +
                                    "BillingCustomerID = " + istaCustomer.BillingCustomerID + "<br/>" +
                                    "BillingEmail = " + istaCustomer.BillingEmail + "<br/>" +
                                    "BillingPhone = " + istaCustomer.BillingPhone + "<br/>" +
                                    "BillingState = " + istaCustomer.BillingState + "<br/>" +
                                    "BillingType = " + istaCustomer.BillingType + "<br/>" +
                                    "BillingZip = " + istaCustomer.BillingZip + "<br/>" +
                                    "Comments = " + istaCustomer.Comments + "<br/>" +
                                    "CustomerAccountNumber = " + istaCustomer.CustomerAccountNumber + "<br/>" +
                                    "ContractEndDate = " + istaCustomer.ContractEndDate + "<br/>" +
                                    "ContractStartDate = " + istaCustomer.ContractStartDate + "<br/>" +
                                    "CustomerGroup = " + istaCustomer.CustomerGroup + "<br/>" +
                                    "CustomerName = " + istaCustomer.CustomerName + "<br/>" +
                                    "CustomerType = " + istaCustomer.CustomerType + "<br/>" +
                                    "DBA = " + istaCustomer.DBA + "<br/>" +
                                    "DigitalSignature = " + istaCustomer.DigitalSignature + "<br/>" +
                                    "DisableTransactions = " + istaCustomer.DisableTransactions + "<br/>" +
                                    "EnrollDefaultRate.PlanType = " + istaCustomer.EnrollDefaultRate.PlanType + "<br/>" +
                                    "EnrollDefaultRate.SwitchDate = " + istaCustomer.EnrollDefaultRate.SwitchDate + "<br/>" +
                                    "EnrollDefaultRate.LDCRateCode = " + istaCustomer.EnrollDefaultRate.LDCRateCode + "<br/>" +
                                    "EnrollDefaultRate.EnrollRateDetailList = " + istaCustomer.EnrollDefaultRate.EnrollRateDetailList + "<br/>" +
                                    "EnrollPremise Address1 = " + istaCustomer.EnrollPremise.Address1 + "<br/>" +
                                    "EnrollPremise Address2 = " + istaCustomer.EnrollPremise.Address2 + "<br/>" +
                                    "EnrollPremise BillingAccountNumber = " + istaCustomer.EnrollPremise.BillingAccountNumber + "<br/>" +
                                    "EnrollPremise City = " + istaCustomer.EnrollPremise.City + "<br/>" +
                                    "EnrollPremise EnrollmentType = " + istaCustomer.EnrollPremise.EnrollmentType + "<br/>" +
                                    "EnrollPremise EnrollPremiseTaxPercentageList = " + istaCustomer.EnrollPremise.EnrollPremiseTaxPercentageList.Length + " " + istaCustomer.EnrollPremise.EnrollPremiseTaxPercentageList.Rank + "<br/>" +
                                    "EnrollPremise EsiId = " + istaCustomer.EnrollPremise.EsiId + "<br/>" +
                                    "EnrollPremise LBMPID = " + istaCustomer.EnrollPremise.LBMPID + "<br/>" +
                                    "EnrollPremise MeterNumber = " + istaCustomer.EnrollPremise.MeterNumber + "<br/>" +
                                    //"EnrollPremise MeterServiceProvider = " + istaCustomer.EnrollPremise.MeterServiceProvider + "<br/>" + 
                                    "EnrollPremise NameKey = " + istaCustomer.EnrollPremise.NameKey + "<br/>" +
                                    "EnrollPremise SpecialReadDate = " + istaCustomer.EnrollPremise.SpecialReadDate + "<br/>" +
                                    "EnrollPremise State = " + istaCustomer.EnrollPremise.State + "<br/>" +
                                    "EnrollPremise TaxAssessmentList = " + istaCustomer.EnrollPremise.TaxAssessmentList.Length + "" + istaCustomer.EnrollPremise.TaxAssessmentList.Rank + "<br/>" +
                                    "EnrollPremise = Zip " + istaCustomer.EnrollPremise.Zip + "<br/>" +


                                    "EnrollRate.PlanType = " + istaCustomer.EnrollRate.PlanType + "<br/>" +
                                    "EnrollRate.LDCRateCode = " + istaCustomer.EnrollRate.LDCRateCode + "<br/>" +
                                    "EnrollRate.EnrollRateDetailList = " + istaCustomer.EnrollRate.EnrollRateDetailList + "<br/>" +
                                    "ESPDuns = " + istaCustomer.ESPDuns + "<br/>" +
                                    "FederalTaxId = " + istaCustomer.FederalTaxId + "<br/>" +
                                    "FirstName = " + istaCustomer.FirstName + "<br/>" +
                                    "HistoricalUsageType = " + istaCustomer.HistoricalUsageType + "<br/>" +
                                    "IsLifeSupport = " + istaCustomer.IsLifeSupport + "<br/>" +
                                    "IsSpanishBill = " + istaCustomer.IsSpanishBill + "<br/>" +
                                    "IsTaxable = " + istaCustomer.IsTaxable + "<br/>" +
                                    "LastName = " + istaCustomer.LastName + "<br/>" +
                                    "LateFeeGracePeriod = " + istaCustomer.LateFeeGracePeriod + "<br/>" +
                                    "LateFeeMaxAmount = " + istaCustomer.LateFeeMaxAmount + "<br/>" +
                                    "LateFeeRate = " + istaCustomer.LateFeeRate + "<br/>" +
                                    "MasterCustomerID = " + istaCustomer.MasterCustomerID + "<br/>" +
                                    "MiddleName = " + istaCustomer.MiddleName + "<br/>" +
                                    "NotificationWaiver = " + istaCustomer.NotificationWaiver + "<br/>" +
                                    "PrintLayout = " + istaCustomer.PrintLayout + "<br/>" +
                                    "Salutation = " + istaCustomer.Salutation + "<br/>" +
                                    "SubmitHURequest = " + istaCustomer.SubmitHURequest + "<br/>" +
                                    "TDSPDuns = " + istaCustomer.TDSPDuns + "<br/>"

                                    + "<br/> Trace: " + ex.StackTrace);
                            }
                            catch (Exception ex)
                            {
                                _logger.Error(string.Format("{0} - {1} ERROR; Exception:{3} Execute Time (ms):{2}", DateTime.Now.ToString(), method, DateTime.Now.Subtract(beginDate).TotalMilliseconds.ToString(), ex == null || ex.Message == null ? "NULL" : ex.Message));
                                throw;
                            }
                        }
                    case 1:
                        {
                            _logger.Info(string.Format("{0} - {1} Calling request service for ESG :", DateTime.Now.ToString(), method, IstaCustomerToString(istaCustomer)));
                            wsvcRequest = new Request();
                            UsageRequestDTO usageRequest = new UsageRequestDTO();
                            _logger.Info(string.Format("{0} - {1} Usage Request Object Created:", DateTime.Now.ToString(), method, IstaCustomerToString(istaCustomer)));
                            ResponseDTO[] usageResponseLst;
                            usageRequest.AccountNumber = accountNumber;
                            usageRequest.BillingAccount = istaCustomer.EnrollPremise.BillingAccountNumber == null ? null : istaCustomer.EnrollPremise.BillingAccountNumber.Trim();
                            usageRequest.ApplicationName = AppName;
                            int utilityId = 0;
                            DataSet dsUtility = UtilitySql.GetUtility(utilityCode);
                            if (dsUtility.Tables.Count > 0 & dsUtility.Tables[0].Rows.Count > 0)
                                int.TryParse(Convert.ToString(dsUtility.Tables[0].Rows[0]["Id"]), out utilityId);
                            
                            usageRequest.UtilityIdSpecified = true;
                            usageRequest.UtilityId = utilityId;
                            usageRequest.NameKey = utilityBO.AdjustNameKey(utilityId, istaCustomer.EnrollPremise.NameKey);

                            switch (istaCustomer.HistoricalUsageType.ToUpper())
                            {
                                case "HU":
                                    {
                                        usageRequest.UsageType = UsageType.HU;
                                        usageRequest.UsageTypeSpecified = true;
                                        break;
                                    }

                                case "HI":
                                    {
                                        usageRequest.UsageType = UsageType.HI;
                                        usageRequest.UsageTypeSpecified = true;
                                        break;
                                    }
                            }

                            _logger.Info(string.Format("{0} - {1} CALLING usageResponseLst = wsvcRequest.GetUsage(usageRequest:{2});", DateTime.Now.ToString(), method, UsageRequestDTOToString(usageRequest)));
                            usageResponseLst = wsvcRequest.GetUsage(usageRequest);
                            _logger.Info(string.Format("{0} - {1} CALLED usageResponseLst = wsvcRequest.GetUsage(usageRequest:{2});", DateTime.Now.ToString(), method, UsageRequestDTOToString(usageRequest)));
                            _logger.Info(string.Format("{0} - {1} UsageResponse {2} Rows Received:", DateTime.Now.ToString(), method, Convert.ToString(usageResponseLst.Length)));
                            foreach (ResponseDTO UsageResponseOutPut in usageResponseLst)
                                _logger.Info(string.Format("{0} - {1} - {2};", DateTime.Now.ToString(), method, UsageResponseDTOToString(UsageResponseOutPut)));
                            HelperMethods.ValidateRequestServiceResponse(usageResponseLst);
                            _logger.Info(string.Format("{0} - {1} End  Calling request service for ESG :", DateTime.Now.ToString(), method, IstaCustomerToString(istaCustomer)));

                            break;
                        }
                }
                //send request
                _logger.Info(string.Format("{0} - {1} CALLING AccountSql.UsageLogInsert(dr['AccountNumber']:{2}, dr['utility_duns']:{3}, custId:{4}, AppName:{5}, domainUser:{6});", DateTime.Now.ToString(), method, NullSafeString(dr["AccountNumber"]), NullSafeString(dr["utility_duns"]), NullSafeString(custId), NullSafeString(AppName), NullSafeString(domainUser)));
                int iRecords = AccountSql.UsageLogInsert(dr["AccountNumber"].ToString(), dr["utility_duns"].ToString(), custId, AppName, domainUser);
                _logger.Info(string.Format("{0} - {1} CALLED AccountSql.UsageLogInsert(dr['AccountNumber']:{2}, dr['utility_duns']:{3}, custId:{4}, AppName:{5}, domainUser:{6});iRecords={7}", DateTime.Now.ToString(), method, NullSafeString(dr["AccountNumber"]), NullSafeString(dr["utility_duns"]), NullSafeString(custId), NullSafeString(AppName), NullSafeString(domainUser), NullSafeString(iRecords)));


                _logger.Info(string.Format("{0} - {1} CALLING AccountSql.UsageStatusUpdate(dr['account_id']:{2}, domainUser:{3});", DateTime.Now.ToString(), method, NullSafeString(dr["account_id"]), NullSafeString(domainUser)));
                iRecords = AccountSql.UsageStatusUpdate(dr["account_id"].ToString(), domainUser);
                _logger.Info(string.Format("{0} - {1} CALLED AccountSql.UsageStatusUpdate(dr['account_id']:{2}, domainUser:{3}); iRecords={4}", DateTime.Now.ToString(), method, NullSafeString(dr["account_id"]), NullSafeString(domainUser), NullSafeString(iRecords)));

            }

            catch (Exception ex)
            {
                _logger.Error(string.Format("{0} - {1} ERROR; Exception:{3} Execute Time (ms):{2}", DateTime.Now.ToString(), method, DateTime.Now.Subtract(beginDate).TotalMilliseconds.ToString(), ex == null || ex.Message == null ? "NULL" : ex.Message));
                throw;
            }
        }

        /// <summary>
        /// Submits historical usage request to ISTA
        /// </summary>
        /// <param name="accountNumber"></param>
        /// <param name="CustomerName"></param>
        /// <param name="LPC_Duns"></param>
        /// <param name="utility_duns"></param>
        /// <param name="NameKey"></param>
        /// <param name="Meter"></param>
        /// <param name="BillingAccountNumber"></param>
        /// <param name="domainUser"></param>
        /// <param name="AppName"></param>
        public static void SubmitHistoricalUsageRequestPreEnrollment(string accountNumber, string CustomerName, string LPC_Duns, string utility_duns, string NameKey, string Meter, string BillingAccountNumber, string domainUser, string AppName)
        {
            string method = string.Format("{0}.{1}. SubmitHistoricalUsageRequestPreEnrollment(string accountNumber : {2}, string CustomerName : {3} , string LPC_Duns : {4}, string utility_duns : {5}, string NameKey : {6}, string Meter : {7}, string BillingAccountNumber : {8}, string domainUser : {9}, string AppName : {10})",
               NAMESPACE, CLASS, NullSafeString(accountNumber), NullSafeString(CustomerName), NullSafeString(LPC_Duns), NullSafeString(utility_duns), NullSafeString(NameKey), NullSafeString(Meter), NullSafeString(BillingAccountNumber), NullSafeString(domainUser), NullSafeString(AppName));
            DateTime beginDate = DateTime.Now;
            try
            {
                _logger.Info(string.Format("{0} - {1} BEGIN", beginDate.ToString(), method));

                int iUseESGForUsageRequest = 0;
                int.TryParse(strUseESGForUsageRequest, out iUseESGForUsageRequest);
                switch (iUseESGForUsageRequest)
                {
                    case 0:
                        {
                            try
                            {
                                IstaEnrollmentService.PreEnrollmentHURequest HURequest = new IstaEnrollmentService.PreEnrollmentHURequest();
                                HURequest.CustomerName = CustomerName;
                                HURequest.ESIID = accountNumber;
                                HURequest.TDSPDuns = utility_duns;
                                HURequest.ESPDuns = LPC_Duns;
                                HURequest.BillingAccountNumber = BillingAccountNumber;
                                //HURequest.NameKey = NameKey;
                                //MTJ-68730- Code changes
                                if ((NameKey != null) && (NameKey.Trim() != ""))
                                    HURequest.NameKey = NameKey.ToUpper();
                                else
                                    HURequest.NameKey = NameKey;

                                HURequest.MeterNumber = Meter;

                                wsvcIsta.CreatePreEnrollmentHistoricalUsageRequest(HURequest);
                                int iRecords = AccountSql.UsageLogInsert(accountNumber, utility_duns, HURequest.NameKey, 0, AppName, domainUser);
                            }
                            catch (SoapException ex)
                            {
                                throw new Exception("Soap Exception: " + ex.Detail.InnerText);
                            }
                            catch (Exception ex)
                            {
                                throw ex;
                            }
                            break;
                        }
                    case 1:
                        {
                            _logger.Info(string.Format("{0} - {1} Calling request service for ESG :", DateTime.Now.ToString(), method));
                            int utilityId = 0;
                            DataSet dsUtility = UtilitySql.SelectUtilityDuns(utility_duns);
                            if (dsUtility.Tables.Count > 0 & dsUtility.Tables[0].Rows.Count > 0)
                                int.TryParse(Convert.ToString(dsUtility.Tables[0].Rows[0]["Id"]), out utilityId);
                            wsvcRequest = new Request();
                            UsageRequestDTO usageRequest = new UsageRequestDTO();
                            _logger.Info(string.Format("{0} - {1} Usage Request Object Created:", DateTime.Now.ToString(), method));
                            ResponseDTO[] usageResponseLst;
                            usageRequest.AccountNumber = accountNumber;
                            usageRequest.BillingAccount = BillingAccountNumber == null ? null : BillingAccountNumber.Trim();
                            usageRequest.NameKey = utilityBO.AdjustNameKey(utilityId, NameKey);
                            usageRequest.ApplicationName = AppName;
                            usageRequest.UtilityIdSpecified = true;
                            usageRequest.UtilityId = utilityId;

                            usageRequest.UsageType = UsageType.HU;
                            usageRequest.UsageTypeSpecified = true;

                            _logger.Info(string.Format("{0} - {1} CALLING usageResponseLst = wsvcRequest.GetUsage(usageRequest:{2});", DateTime.Now.ToString(), method, UsageRequestDTOToString(usageRequest)));
                            usageResponseLst = wsvcRequest.GetUsage(usageRequest);
                            _logger.Info(string.Format("{0} - {1} CALLED usageResponseLst = wsvcRequest.GetUsage(usageRequest:{2});", DateTime.Now.ToString(), method, UsageRequestDTOToString(usageRequest)));
                            _logger.Info(string.Format("{0} - {1} UsageResponse {2} Rows Received:", DateTime.Now.ToString(), method, Convert.ToString(usageResponseLst.Length)));
                            foreach (ResponseDTO UsageResponseOutPut in usageResponseLst)
                                _logger.Info(string.Format("{0} - {1} - {2};", DateTime.Now.ToString(), method, UsageResponseDTOToString(UsageResponseOutPut)));
                            HelperMethods.ValidateRequestServiceResponse(usageResponseLst);
                            _logger.Info(string.Format("{0} - {1} End  Calling request service for ESG :", DateTime.Now.ToString(), method));

                            break;
                        }
                }

                _logger.Info(string.Format("{0} - {1} END", beginDate.ToString(), method));

            }
            catch (Exception ex)
            {
                _logger.Error(string.Format("{0} - {1} ERROR; Exception:{3} Execute Time (ms):{2}", DateTime.Now.ToString(), method, DateTime.Now.Subtract(beginDate).TotalMilliseconds.ToString(), ex == null || ex.Message == null ? "NULL" : ex.Message));
                throw;
            }


        }

        private static void SubmitHistoricalUsageRequestPreEnrollment(IstaEnrollmentService.EnrollCustomer preEnrollmentCustomer, string utility, string meterType, string appName, string domainUser, string usageFlag, string accountNumber)
        {
            string method = string.Format("{0}.{1}.SubmitHistoricalUsageRequestPreEnrollment(IstaEnrollmentService.EnrollCustomer preEnrollmentCustomer:{2}, string utility:{3}, string meterType:{4}, string appName:{5}, string domainUser:{6}, string usageFlag:{7},string accountNumber : {8} )",
                NAMESPACE, CLASS, NullSafeString(preEnrollmentCustomer), NullSafeString(utility), NullSafeString(meterType), NullSafeString(appName), NullSafeString(domainUser), NullSafeString(usageFlag), NullSafeString(accountNumber));
            DateTime beginDate = DateTime.Now;

            try
            {
                _logger.Info(string.Format("{0} - {1} BEGIN", beginDate.ToString(), method));

                //string HURequestType = string.Empty;
                IstaEnrollmentService.EnrollCustomer istaCustomer = new IstaEnrollmentService.EnrollCustomer();
                int iUseESGForUsageRequest = 0;
                int.TryParse(strUseESGForUsageRequest, out iUseESGForUsageRequest);
                int custId = 0;
                int utilityId = 0;
                DataSet dsUtility = UtilitySql.GetUtility(utility);
                if (dsUtility.Tables.Count > 0 & dsUtility.Tables[0].Rows.Count > 0)
                    int.TryParse(Convert.ToString(dsUtility.Tables[0].Rows[0]["Id"]), out utilityId);
                bool isIDR = false;
                try
                {
                    isIDR = UtilitySql.IsUtilityIdrEdiCapable(utility);
                }
                catch { }

                istaCustomer = preEnrollmentCustomer;
                istaCustomer.SubmitHURequest = false;
                istaCustomer.HistoricalUsageType = usageFlag;

                if (!String.IsNullOrEmpty(usageFlag))
                {
                    usageFlag = usageFlag.ToUpper();
                }

                switch (usageFlag)
                {
                    case "HI":
                    case "HU":
                        istaCustomer.HistoricalUsageType = usageFlag.ToUpper();
                        break;
                    default:
                        if (meterType.ToUpper().Equals("IDR"))
                            istaCustomer.HistoricalUsageType = "HI";
                        else
                            istaCustomer.HistoricalUsageType = "HU";
                        break;
                }


                switch (iUseESGForUsageRequest)
                {
                    case 0:
                        {
                            try
                            {
                                _logger.Info(string.Format("{0} - {1}  Calling ISTA Web service:", DateTime.Now.ToString(), method));
                                if (utilityId == 0)
                                {
                                    _logger.Info(string.Format("{0} - {1} Ends Calling ISTA Web service:", DateTime.Now.ToString(), method));
                                    return;

                                }
                                //send request
                                _logger.Info(string.Format("{0} - {1} CALLING custId = wsvcIsta.CreateEnrollment(istaCustomer:{2});", DateTime.Now.ToString(), method, IstaCustomerToString(istaCustomer)));
                                custId = wsvcIsta.CreateEnrollment(istaCustomer);
                                _logger.Info(string.Format("{0} - {1} CALLED custId:{2} = wsvcIsta.CreateEnrollment(istaCustomer);", DateTime.Now.ToString(), method, custId));

                                //send request
                                _logger.Info(string.Format("{0} - {1} CALLING wsvcIsta.CreateHistoricalUsageRequest(custId:{2}, istaCustomer.HistoricalUsageType:{3},NameKey:{4});", DateTime.Now.ToString(), method, custId, NullSafeString(istaCustomer.HistoricalUsageType), NullSafeString(istaCustomer.EnrollPremise.NameKey)));
                                wsvcIsta.CreateHistoricalUsageRequest(custId, istaCustomer.HistoricalUsageType);
                                _logger.Info(string.Format("{0} - {1} CALLED wsvcIsta.CreateHistoricalUsageRequest(custId:{2}, istaCustomer.HistoricalUsageType:{3},NameKey:{4});", DateTime.Now.ToString(), method, custId, NullSafeString(istaCustomer.HistoricalUsageType), NullSafeString(istaCustomer.EnrollPremise.NameKey)));
                                _logger.Info(string.Format("{0} - {1} Ends Calling ISTA Web service:", DateTime.Now.ToString(), method));
                                break;
                            }
                            catch (SoapException ex)
                            {
                                #region
                                _logger.Error(string.Format("{0} - {1} ERROR; Soap Exception:Message={3} StackTrace={4} Execute Time (ms):{2}",
                                    DateTime.Now.ToString(),
                                    method,
                                    DateTime.Now.Subtract(beginDate).TotalMilliseconds.ToString(),
                                    ex == null || ex.Message == null ? "NULL" : ex.Message,
                                    ex == null || ex.StackTrace == null ? "NULL" : ex.StackTrace
                                    ));
                                throw new Exception("Soap Exception: " + ex.Detail + "<br/>" + ex.Message + "<br/>" + ex.StackTrace + "<br/> IDR= " + isIDR.ToString() + "<br/>Request type = " + istaCustomer.HistoricalUsageType + "<br/>" +
                                    "ApplyLateFees = " + istaCustomer.ApplyLateFees + "<br/>" +
                                    "ARTerms = " + istaCustomer.ARTerms + "<br/>" +
                                    "BillingAddress1 = " + istaCustomer.BillingAddress1 + "<br/>" +
                                    "BillingAddress2 = " + istaCustomer.BillingAddress2 + "<br/>" +
                                    "BillingCity = " + istaCustomer.BillingCity + "<br/>" +
                                    "BillingContact = " + istaCustomer.BillingContact + "<br/>" +
                                    "BillingCustomerID = " + istaCustomer.BillingCustomerID + "<br/>" +
                                    "BillingEmail = " + istaCustomer.BillingEmail + "<br/>" +
                                    "BillingPhone = " + istaCustomer.BillingPhone + "<br/>" +
                                    "BillingState = " + istaCustomer.BillingState + "<br/>" +
                                    "BillingType = " + istaCustomer.BillingType + "<br/>" +
                                    "BillingZip = " + istaCustomer.BillingZip + "<br/>" +
                                    "Comments = " + istaCustomer.Comments + "<br/>" +
                                    "CustomerAccountNumber = " + istaCustomer.CustomerAccountNumber + "<br/>" +
                                    "ContractEndDate = " + istaCustomer.ContractEndDate + "<br/>" +
                                    "ContractStartDate = " + istaCustomer.ContractStartDate + "<br/>" +
                                    "CustomerGroup = " + istaCustomer.CustomerGroup + "<br/>" +
                                    "CustomerName = " + istaCustomer.CustomerName + "<br/>" +
                                    "CustomerType = " + istaCustomer.CustomerType + "<br/>" +
                                    "DBA = " + istaCustomer.DBA + "<br/>" +
                                    "DigitalSignature = " + istaCustomer.DigitalSignature + "<br/>" +
                                    "DisableTransactions = " + istaCustomer.DisableTransactions + "<br/>" +
                                    "EnrollDefaultRate.PlanType = " + istaCustomer.EnrollDefaultRate.PlanType + "<br/>" +
                                    "EnrollDefaultRate.SwitchDate = " + istaCustomer.EnrollDefaultRate.SwitchDate + "<br/>" +
                                    "EnrollDefaultRate.LDCRateCode = " + istaCustomer.EnrollDefaultRate.LDCRateCode + "<br/>" +
                                    "EnrollDefaultRate.EnrollRateDetailList = " + istaCustomer.EnrollDefaultRate.EnrollRateDetailList + "<br/>" +
                                    "EnrollPremise Address1 = " + istaCustomer.EnrollPremise.Address1 + "<br/>" +
                                    "EnrollPremise Address2 = " + istaCustomer.EnrollPremise.Address2 + "<br/>" +
                                    "EnrollPremise BillingAccountNumber = " + istaCustomer.EnrollPremise.BillingAccountNumber + "<br/>" +
                                    "EnrollPremise City = " + istaCustomer.EnrollPremise.City + "<br/>" +
                                    "EnrollPremise EnrollmentType = " + istaCustomer.EnrollPremise.EnrollmentType + "<br/>" +
                                    "EnrollPremise EnrollPremiseTaxPercentageList = " + istaCustomer.EnrollPremise.EnrollPremiseTaxPercentageList.Length + " " + istaCustomer.EnrollPremise.EnrollPremiseTaxPercentageList.Rank + "<br/>" +
                                    "EnrollPremise EsiId = " + istaCustomer.EnrollPremise.EsiId + "<br/>" +
                                    "EnrollPremise LBMPID = " + istaCustomer.EnrollPremise.LBMPID + "<br/>" +
                                    "EnrollPremise MeterNumber = " + istaCustomer.EnrollPremise.MeterNumber + "<br/>" +
                                    //"EnrollPremise MeterServiceProvider = " + istaCustomer.EnrollPremise.MeterServiceProvider + "<br/>" + 
                                    "EnrollPremise NameKey = " + istaCustomer.EnrollPremise.NameKey + "<br/>" +
                                    "EnrollPremise SpecialReadDate = " + istaCustomer.EnrollPremise.SpecialReadDate + "<br/>" +
                                    "EnrollPremise State = " + istaCustomer.EnrollPremise.State + "<br/>" +
                                    "EnrollPremise TaxAssessmentList = " + istaCustomer.EnrollPremise.TaxAssessmentList.Length + "" + istaCustomer.EnrollPremise.TaxAssessmentList.Rank + "<br/>" +
                                    "EnrollPremise = Zip " + istaCustomer.EnrollPremise.Zip + "<br/>" +
                                    "EnrollRate.PlanType = " + istaCustomer.EnrollRate.PlanType + "<br/>" +
                                    "EnrollRate.LDCRateCode = " + istaCustomer.EnrollRate.LDCRateCode + "<br/>" +
                                    "EnrollRate.EnrollRateDetailList = " + istaCustomer.EnrollRate.EnrollRateDetailList + "<br/>" +
                                    "ESPDuns = " + istaCustomer.ESPDuns + "<br/>" +
                                    "FederalTaxId = " + istaCustomer.FederalTaxId + "<br/>" +
                                    "FirstName = " + istaCustomer.FirstName + "<br/>" +
                                    "HistoricalUsageType = " + istaCustomer.HistoricalUsageType + "<br/>" +
                                    "IsLifeSupport = " + istaCustomer.IsLifeSupport + "<br/>" +
                                    "IsSpanishBill = " + istaCustomer.IsSpanishBill + "<br/>" +
                                    "IsTaxable = " + istaCustomer.IsTaxable + "<br/>" +
                                    "LastName = " + istaCustomer.LastName + "<br/>" +
                                    "LateFeeGracePeriod = " + istaCustomer.LateFeeGracePeriod + "<br/>" +
                                    "LateFeeMaxAmount = " + istaCustomer.LateFeeMaxAmount + "<br/>" +
                                    "LateFeeRate = " + istaCustomer.LateFeeRate + "<br/>" +
                                    "MasterCustomerID = " + istaCustomer.MasterCustomerID + "<br/>" +
                                    "MiddleName = " + istaCustomer.MiddleName + "<br/>" +
                                    "NotificationWaiver = " + istaCustomer.NotificationWaiver + "<br/>" +
                                    "PrintLayout = " + istaCustomer.PrintLayout + "<br/>" +
                                    "Salutation = " + istaCustomer.Salutation + "<br/>" +
                                    "SubmitHURequest = " + istaCustomer.SubmitHURequest + "<br/>" +
                                    "TDSPDuns = " + istaCustomer.TDSPDuns + "<br/>");
                                #endregion
                            }
                            catch (Exception exc)
                            {
                                _logger.Error(string.Format("{0} - {1} ERROR {3}; Execute Time (ms):{2}", DateTime.Now.ToString(), method, DateTime.Now.Subtract(beginDate).TotalMilliseconds.ToString(), NullSafeString(exc.Message)));
                                throw;
                            }



                        }
                    case 1:
                        {
                            _logger.Info(string.Format("{0} - {1} Calling request service for ESG :", DateTime.Now.ToString(), method, IstaCustomerToString(istaCustomer)));
                            wsvcRequest = new Request();
                            UsageRequestDTO usageRequest = new UsageRequestDTO();
                            _logger.Info(string.Format("{0} - {1} Usage Request Object Created:", DateTime.Now.ToString(), method, IstaCustomerToString(istaCustomer)));
                            ResponseDTO[] usageResponseLst;
                            usageRequest.AccountNumber = accountNumber;
                            usageRequest.BillingAccount = istaCustomer.CustomerAccountNumber == null ? null : istaCustomer.CustomerAccountNumber.Trim();
                            usageRequest.ApplicationName = appName;
                            usageRequest.UtilityIdSpecified = true;
                            usageRequest.UtilityId = utilityId;
                            usageRequest.NameKey = utilityBO.AdjustNameKey(utilityId, istaCustomer.EnrollPremise.NameKey);

                            switch (istaCustomer.HistoricalUsageType.ToUpper())
                            {
                                case "HU":
                                    {
                                        usageRequest.UsageType = UsageType.HU;
                                        usageRequest.UsageTypeSpecified = true;
                                        break;
                                    }

                                case "HI":
                                    {
                                        usageRequest.UsageType = UsageType.HI;
                                        usageRequest.UsageTypeSpecified = true;
                                        break;
                                    }
                            }

                            _logger.Info(string.Format("{0} - {1} CALLING usageResponseLst = wsvcRequest.GetUsage(usageRequest:{2});", DateTime.Now.ToString(), method, UsageRequestDTOToString(usageRequest)));
                            usageResponseLst = wsvcRequest.GetUsage(usageRequest);
                            _logger.Info(string.Format("{0} - {1} CALLED usageResponseLst = wsvcRequest.GetUsage(usageRequest:{2});", DateTime.Now.ToString(), method, UsageRequestDTOToString(usageRequest)));
                            _logger.Info(string.Format("{0} - {1} UsageResponse {2} Rows Received:", DateTime.Now.ToString(), method, Convert.ToString(usageResponseLst.Length)));
                            foreach (ResponseDTO UsageResponseOutPut in usageResponseLst)
                                _logger.Info(string.Format("{0} - {1} - {2};", DateTime.Now.ToString(), method, UsageResponseDTOToString(UsageResponseOutPut)));
                            HelperMethods.ValidateRequestServiceResponse(usageResponseLst);
                            _logger.Info(string.Format("{0} - {1} End  Calling request service for ESG :", DateTime.Now.ToString(), method, IstaCustomerToString(istaCustomer)));

                            break;
                        }
                }
                _logger.Info(string.Format("{0} - {1} CALLING iRecords = AccountSql.UsageLogInsert(preEnrollmentCustomer.EnrollPremise.EsiId:{2}, preEnrollmentCustomer.TDSPDuns:{3}, custId:{4}, appName:{5}, domainUser:{6});",
                    DateTime.Now.ToString(), method, preEnrollmentCustomer != null ? preEnrollmentCustomer.EnrollPremise != null ? NullSafeString(preEnrollmentCustomer.EnrollPremise.EsiId) : "NULL VALUE" : "NULL VALUE", NullSafeString(preEnrollmentCustomer.TDSPDuns), custId, NullSafeString(appName), NullSafeString(domainUser)));
                int iRecords = AccountSql.UsageLogInsert(preEnrollmentCustomer.EnrollPremise.EsiId, preEnrollmentCustomer.TDSPDuns, istaCustomer.EnrollPremise.NameKey, custId, appName, domainUser);
                _logger.Info(string.Format("{0} - {1} CALLED iRecords:{7} = AccountSql.UsageLogInsert(preEnrollmentCustomer.EnrollPremise.EsiId:{2}, preEnrollmentCustomer.TDSPDuns:{3}, custId:{4}, appName:{5}, domainUser:{6});",
                    DateTime.Now.ToString(), method, preEnrollmentCustomer != null ? preEnrollmentCustomer.EnrollPremise != null ? NullSafeString(preEnrollmentCustomer.EnrollPremise.EsiId) : "NULL VALUE" : "NULL VALUE", NullSafeString(preEnrollmentCustomer.TDSPDuns), custId, NullSafeString(appName), NullSafeString(domainUser), iRecords));

                _logger.Info(string.Format("{0} - {1} CALLING iRecords = AccountSql.UsageLogInsert(preEnrollmentCustomer.EnrollPremise.EsiId:{2}, domainUser:{3});",
                    DateTime.Now.ToString(), method, preEnrollmentCustomer != null && preEnrollmentCustomer.EnrollPremise != null ? NullSafeString(preEnrollmentCustomer.EnrollPremise.EsiId) : "NULL VALUE", NullSafeString(domainUser)));
                iRecords = AccountSql.UsageStatusUpdate(preEnrollmentCustomer.EnrollPremise.EsiId, domainUser);
                _logger.Info(string.Format("{0} - {1} CALLED iRecords:{4} = AccountSql.UsageLogInsert(preEnrollmentCustomer.EnrollPremise.EsiId:{2}, domainUser:{3});",
                    DateTime.Now.ToString(), method, preEnrollmentCustomer != null && preEnrollmentCustomer.EnrollPremise != null ? NullSafeString(preEnrollmentCustomer.EnrollPremise.EsiId) : "NULL VALUE", NullSafeString(domainUser), iRecords));

                _logger.Info(string.Format("{0} - {1} END; Execute Time (ms):{2}", DateTime.Now.ToString(), method, DateTime.Now.Subtract(beginDate).TotalMilliseconds.ToString()));
            }
            catch (Exception exc)
            {
                _logger.Error(string.Format("{0} - {1} ERROR {3}; Execute Time (ms):{2}", DateTime.Now.ToString(), method, DateTime.Now.Subtract(beginDate).TotalMilliseconds.ToString(), NullSafeString(exc.Message)));
                throw;
            }
        }

        /// <summary>
        /// Submits usage request to ISTA for prospect accounts
        /// </summary>
        /// <param name="accountNumber"></param>
        /// <param name="billingAddress1"></param>
        /// <param name="billingAddress2"></param>
        /// <param name="billingCity"></param>
        /// <param name="billingState"></param>
        /// <param name="billingZip"></param>
        /// <param name="billingContact"></param>
        /// <param name="contactEmail"></param>
        /// <param name="contactPhone"></param>
        /// <param name="customerName"></param>
        /// <param name="firstName"></param>
        /// <param name="lastName"></param>
        /// <param name="LPC_Duns"></param>
        /// <param name="utilityDuns"></param>
        /// <param name="serviceStreet"></param>
        /// <param name="serviceSuite"></param>
        /// <param name="serviceCity"></param>
        /// <param name="serviceState"></param>
        /// <param name="serviceZip"></param>
        /// <param name="nameKey"></param>
        /// <param name="meter"></param>
        /// <param name="billingAccountnumber"></param>
        /// <param name="domainUser"></param>
        /// <param name="meterType"></param>
        /// <param name="utility"></param>
        /// <param name="appName"></param>
        /// <param name="UsageFlag"></param>
        public static void SubmitHistoricalUsageRequestPreEnrollment(string accountNumber, string billingAddress1, string billingAddress2, string billingCity, string billingState,
            string billingZip, string billingContact, string contactEmail, string contactPhone, string customerName, string firstName, string lastName, string LPC_Duns, string utilityDuns,
            string serviceStreet, string serviceSuite, string serviceCity, string serviceState, string serviceZip, string nameKey, string meter, string billingAccountnumber,
            string domainUser, string meterType, string utility, string appName, string UsageFlag = null)
        {
            DateTime beginDate = DateTime.Now;
            string method = string.Format("{0}.{1}.SubmitHistoricalUsageRequestPreEnrollment(string accountNumber:{2},string billingAddress1:{3},string billingAddress2:{4},string billingCity:{5},string billingState:{6},string billingZip:{7},string billingContact:{8},string contactEmail:{9},string contactPhone:{10},string customerName:{11},string firstName:{12},string lastName:{13},string LPC_Duns:{14},string utilityDuns:{15},string serviceStreet:{16},string serviceSuite:{17},string serviceCity:{18},string serviceState:{19},string serviceZip:{20},string nameKey:{21},string meter:{22},string billingAccountnumber:{23},string domainUser:{24},string meterType:{25},string utility:{26},string appName:{27},string UsageFlag = null:{28})", NAMESPACE, CLASS, NullSafeString(accountNumber), NullSafeString(billingAddress1), NullSafeString(billingAddress2), NullSafeString(billingCity), NullSafeString(billingState), NullSafeString(billingZip), NullSafeString(billingContact), NullSafeString(contactEmail), NullSafeString(contactPhone), NullSafeString(customerName), NullSafeString(firstName), NullSafeString(lastName), NullSafeString(LPC_Duns), NullSafeString(utilityDuns), NullSafeString(serviceStreet), NullSafeString(serviceSuite), NullSafeString(serviceCity), NullSafeString(serviceState), NullSafeString(serviceZip), NullSafeString(nameKey), NullSafeString(meter), NullSafeString(billingAccountnumber), NullSafeString(domainUser), NullSafeString(meterType), NullSafeString(utility), NullSafeString(appName), NullSafeString(UsageFlag));

            try
            {
                _logger.Info(string.Format("{0} - {1} BEGIN", beginDate.ToString(), method));

                _logger.Info(string.Format("{0} - {1} CALLING var preEnrollmentCustomer = ServiceHelper.BuildPreEnrollmentCustomer(accountNumber, billingAddress1, billingAddress2, billingCity, billingState, billingZip, billingContact, contactEmail, contactPhone, customerName, firstName, lastName, LPC_Duns, utilityDuns, serviceStreet, serviceSuite, serviceCity, serviceState, serviceZip, nameKey, meter, billingAccountnumber, domainUser, meterType, utility, appName);", DateTime.Now.ToString(), method));
                var preEnrollmentCustomer = ServiceHelper.BuildPreEnrollmentCustomer(accountNumber, billingAddress1, billingAddress2, billingCity, billingState, billingZip, billingContact, contactEmail, contactPhone, customerName, firstName, lastName, LPC_Duns, utilityDuns, serviceStreet, serviceSuite, serviceCity, serviceState, serviceZip, nameKey, meter, billingAccountnumber, domainUser, meterType, utility, appName);
                _logger.Info(string.Format("{0} - {1} CALLED var preEnrollmentCustomer = ServiceHelper.BuildPreEnrollmentCustomer(accountNumber, billingAddress1, billingAddress2, billingCity, billingState, billingZip, billingContact, contactEmail, contactPhone, customerName, firstName, lastName, LPC_Duns, utilityDuns, serviceStreet, serviceSuite, serviceCity, serviceState, serviceZip, nameKey, meter, billingAccountnumber, domainUser, meterType, utility, appName);", DateTime.Now.ToString(), method));

                _logger.Info(string.Format("{0} - {1} CALLING SubmitHistoricalUsageRequestPreEnrollment(preEnrollmentCustomer, utility, meterType, appName, domainUser, UsageFlag,AccountNumber);", DateTime.Now.ToString(), method));
                SubmitHistoricalUsageRequestPreEnrollment(preEnrollmentCustomer, utility, meterType, appName, domainUser, UsageFlag, accountNumber);
                _logger.Info(string.Format("{0} - {1} CALLED SubmitHistoricalUsageRequestPreEnrollment(preEnrollmentCustomer, utility, meterType, appName, domainUser, UsageFlag,AccountNumber);", DateTime.Now.ToString(), method));

                _logger.Info(string.Format("{0} - {1} END; Execute Time (ms):{2}", DateTime.Now.ToString(), method, DateTime.Now.Subtract(beginDate).TotalMilliseconds.ToString()));
            }
            catch (Exception exc)
            {
                _logger.Error(string.Format("{0} - {1} ERROR {3}; Execute Time (ms):{2}", DateTime.Now.ToString(), method, DateTime.Now.Subtract(beginDate).TotalMilliseconds.ToString(), NullSafeString(exc.Message)));
                throw;
            }
        }
    }
}

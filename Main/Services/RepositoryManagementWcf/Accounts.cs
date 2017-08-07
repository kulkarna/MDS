using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;
using System.ServiceModel.Activation;
using LibertyPower.RepositoryManagement.Contracts.AccountManagement.v1;
using LibertyPower.RepositoryManagement.Contracts.Common.v1;
using LibertyPower.RepositoryManagement.Web;
using UtilityLogging;
using Utilities;
using LibertyPower.RepositoryManagement.Dto;

namespace LibertyPower.RepositoryManagement.v1
{
    [ExceptionToFaultMapper]
    [ServiceCallTracerBehavior]
    [AspNetCompatibilityRequirements(RequirementsMode = AspNetCompatibilityRequirementsMode.Allowed)]
    public class Accounts : IAccounts
    {
        private readonly IAccountsController controller;
        private ILogger _logger;
        private const string NAMESPACE = "LibertyPower.RepositoryManagement.AccountManagement.v1";
        private const string CLASS = "Accounts";
        private const string ACCOUNTTYPE = "AccountType";
        private const string GRID = "Grid";
        private const string ICAP = "ICap";
        private const string LBMPZONE = "LbmpZone";
        private const string LOADPROFILE = "LoadProfile";
        private const string LOADSHAPEID = "LoadShapeId";
        private const string LOSSFACTOR = "LossFactor";
        private const string METERTYPE = "MeterType";
        private const string NOTSET = "NotSet";
        private const string RATECLASS = "RateClass";
        private const string SERVICEADDRESSZIPCODE = "ServiceAddressZipCode";
        private const string SERVICECLASS = "ServiceClass";
        private const string TARIFFCODE = "TariffCode";
        private const string TCAP = "TCap";
        private const string VOLTAGE = "Voltage";
        private const string ZONE = "Zone";

        public Accounts(IAccountsController controller)
        {
            string messageId = Guid.NewGuid().ToString();
            string method = "Accounts(controller)";
            _logger = new Logger();

            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                this.controller = controller;

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
            }
            catch (Exception exc)
            {
                string innerException = exc == null ? "NULL VALUE" : exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString();
                string exception = exc == null ? "NULL VALUE" : exc.Message == null ? "NULL VALUE" : exc.Message;
                string errorMessage = exception + innerException;
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, errorMessage));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public void Submit(ServiceAccountInfo value)
        {
            string method = string.Format("Submit(value:{0})", value);
            string messageId = Guid.NewGuid().ToString();
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                controller.ConvertValidateRetreiveCompareAndSave(value, messageId);

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
            }
            catch (Exception exc)
            {
                string innerException = exc == null ? "NULL VALUE" : exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString();
                string exception = exc == null ? "NULL VALUE" : exc.Message == null ? "NULL VALUE" : exc.Message;
                string errorMessage = exception + innerException;
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, errorMessage));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public void UpdateCrmIfAccountMeetsPropertiesRequirements(int? utilityId, string account)
        {
            string method = string.Format("UpdateCrmIfAccountMeetsPropertiesRequirements(utilityId:{0},account:{1})", Utilities.Common.NullSafeInteger(utilityId), Utilities.Common.NullSafeString(account));
            string messageId = Guid.NewGuid().ToString();
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                controller.UpdateCrmIfAccountMeetsPropertiesRequirements(utilityId, account, messageId);

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
            }
            catch (Exception exc)
            {
                string innerException = exc == null ? "NULL VALUE" : exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString();
                string exception = exc == null ? "NULL VALUE" : exc.Message == null ? "NULL VALUE" : exc.Message;
                string errorMessage = exception + innerException;
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, errorMessage));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public Dictionary<TrackedField, string> GetServiceAccountProperties(string messageId, string utilityCode, string accountNumber)
        {
            string method = string.Format("GetServiceAccountProperties(messageId,utilityCode:{0},accountNumber:{1})", Common.NullSafeString(utilityCode), Common.NullSafeString(accountNumber));
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                LibertyPower.RepositoryManagement.Core.AccountManagement.ServiceAccountProperties serviceAccountProperties = controller.GetServiceAccountProperties(messageId, utilityCode, accountNumber);

                Dictionary<TrackedField, string> returnValue = new Dictionary<TrackedField, string>();
                foreach (LibertyPower.RepositoryManagement.Core.AccountManagement.ServiceAccountProperty serviceAccountProperty in serviceAccountProperties.Properties)
                {
                    switch (serviceAccountProperty.Name)
                    {
                        case LibertyPower.RepositoryManagement.Dto.TrackedField.AccountType:
                            returnValue.Add(TrackedField.AccountType, Common.NullSafeString(serviceAccountProperty.Value));
                            break;
                        case LibertyPower.RepositoryManagement.Dto.TrackedField.BillingAccount:
                            returnValue.Add(TrackedField.BillingAccount, Common.NullSafeString(serviceAccountProperty.Value));
                            break;
                        case LibertyPower.RepositoryManagement.Dto.TrackedField.Grid:
                            returnValue.Add(TrackedField.Grid, Common.NullSafeString(serviceAccountProperty.Value));
                            break;
                        case LibertyPower.RepositoryManagement.Dto.TrackedField.ICap:
                            returnValue.Add(TrackedField.ICap, Common.NullSafeString(serviceAccountProperty.Value));
                            break;
                        case LibertyPower.RepositoryManagement.Dto.TrackedField.LBMPZone:
                            returnValue.Add(TrackedField.LBMPZone, Common.NullSafeString(serviceAccountProperty.Value));
                            break;
                        case LibertyPower.RepositoryManagement.Dto.TrackedField.LoadProfile:
                            returnValue.Add(TrackedField.LoadProfile, Common.NullSafeString(serviceAccountProperty.Value));
                            break;
                        case LibertyPower.RepositoryManagement.Dto.TrackedField.LoadShapeID:
                            returnValue.Add(TrackedField.LoadShapeID, Common.NullSafeString(serviceAccountProperty.Value));
                            break;
                        case LibertyPower.RepositoryManagement.Dto.TrackedField.LossFactor:
                            returnValue.Add(TrackedField.LossFactor, Common.NullSafeString(serviceAccountProperty.Value));
                            break;
                        case LibertyPower.RepositoryManagement.Dto.TrackedField.MeterNumber:
                            returnValue.Add(TrackedField.MeterNumber, Common.NullSafeString(serviceAccountProperty.Value));
                            break;
                        case LibertyPower.RepositoryManagement.Dto.TrackedField.MeterType:
                            returnValue.Add(TrackedField.MeterType, Common.NullSafeString(serviceAccountProperty.Value));
                            break;
                        case LibertyPower.RepositoryManagement.Dto.TrackedField.NameKey:
                            returnValue.Add(TrackedField.NameKey, Common.NullSafeString(serviceAccountProperty.Value));
                            break;
                        case LibertyPower.RepositoryManagement.Dto.TrackedField.RateClass:
                            returnValue.Add(TrackedField.RateClass, Common.NullSafeString(serviceAccountProperty.Value));
                            break;
                        case LibertyPower.RepositoryManagement.Dto.TrackedField.ServiceAddressZipCode:
                            returnValue.Add(TrackedField.ServiceAddressZipCode, Common.NullSafeString(serviceAccountProperty.Value));
                            break;
                        case LibertyPower.RepositoryManagement.Dto.TrackedField.ServiceClass:
                            returnValue.Add(TrackedField.ServiceClass, Common.NullSafeString(serviceAccountProperty.Value));
                            break;
                        case LibertyPower.RepositoryManagement.Dto.TrackedField.Strata:
                            returnValue.Add(TrackedField.Strata, Common.NullSafeString(serviceAccountProperty.Value));
                            break;
                        case LibertyPower.RepositoryManagement.Dto.TrackedField.TariffCode:
                            returnValue.Add(TrackedField.TariffCode, Common.NullSafeString(serviceAccountProperty.Value));
                            break;
                        case LibertyPower.RepositoryManagement.Dto.TrackedField.TCap:
                            returnValue.Add(TrackedField.TCap, Common.NullSafeString(serviceAccountProperty.Value));
                            break;
                        case LibertyPower.RepositoryManagement.Dto.TrackedField.Voltage:
                            returnValue.Add(TrackedField.Voltage, Common.NullSafeString(serviceAccountProperty.Value));
                            break;
                        case LibertyPower.RepositoryManagement.Dto.TrackedField.Zone:
                            returnValue.Add(TrackedField.Zone, Common.NullSafeString(serviceAccountProperty.Value));
                            break;
                    }
                }
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} {3} END", NAMESPACE, CLASS, method, NullSaveDictionaryTrackedFieldString(returnValue)));

                return returnValue;
            }
            catch (Exception exc)
            {
                string innerException = exc == null ? "NULL VALUE" : exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString();
                string exception = exc == null ? "NULL VALUE" : exc.Message == null ? "NULL VALUE" : exc.Message;
                string errorMessage = exception + innerException;
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, errorMessage));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public void UpdateServiceAccountProperties(string messageId, string utilityCode, string accountNumber, string updateSource, string updateUser, Dictionary<TrackedField, string> accountPropertiesNameValueList)
        {
            string method = string.Format("UpdateServiceAccountProperties(messageId,utilityCode:{0},accountNumber:{1},updateSource:{2},updateUser:{3},accountPropertiesNameValueList:{4})", Common.NullSafeString(utilityCode), Common.NullSafeString(accountNumber),
                Common.NullSafeString(updateSource), Common.NullSafeString(updateUser), NullSaveDictionaryTrackedFieldString(accountPropertiesNameValueList));
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                ServiceAccountInfo serviceAccountInfo = new ServiceAccountInfo()
                {
                    AccountNumber = Common.NullSafeString(accountNumber),
                    UpdateSource = Common.NullSafeString(updateSource),
                    UpdateUser = Common.NullSafeString(updateUser),
                    Utility = Common.NullSafeString(utilityCode)
                };

                foreach (TrackedField key in accountPropertiesNameValueList.Keys)
                {
                    switch (key)
                    {
                        case TrackedField.AccountType:
                            serviceAccountInfo.AccountType = Common.NullSafeString(accountPropertiesNameValueList[key]);
                            break;
                        case TrackedField.BillingAccount:
                            serviceAccountInfo.BillingAccount = Common.NullSafeString(accountPropertiesNameValueList[key]);
                            break;
                        case TrackedField.Grid:
                            serviceAccountInfo.Grid = Common.NullSafeString(accountPropertiesNameValueList[key]);
                            break;
                        case TrackedField.ICap:
                            serviceAccountInfo.ICap = Common.NullSafeInteger(accountPropertiesNameValueList[key]);
                            break;
                        case TrackedField.LBMPZone:
                            serviceAccountInfo.LbmpZone = Common.NullSafeString(accountPropertiesNameValueList[key]);
                            break;
                        case TrackedField.LoadProfile:
                            serviceAccountInfo.LoadProfile = Common.NullSafeString(accountPropertiesNameValueList[key]);
                            break;
                        case TrackedField.LoadShapeID:
                            serviceAccountInfo.LoadShapeId = Common.NullSafeString(accountPropertiesNameValueList[key]);
                            break;
                        case TrackedField.LossFactor:
                            serviceAccountInfo.LossFactor = Common.NullSafeInteger(accountPropertiesNameValueList[key]);
                            break;
                        case TrackedField.MeterType:
                            serviceAccountInfo.MeterType = Common.NullSafeString(accountPropertiesNameValueList[key]);
                            break;
                        case TrackedField.RateClass:
                            serviceAccountInfo.RateClass = Common.NullSafeString(accountPropertiesNameValueList[key]);
                            break;
                        case TrackedField.ServiceAddressZipCode:
                            serviceAccountInfo.ServiceAddressZipCode = Common.NullSafeString(accountPropertiesNameValueList[key]);
                            break;
                        case TrackedField.ServiceClass:
                            serviceAccountInfo.ServiceClass = Common.NullSafeString(accountPropertiesNameValueList[key]);
                            break;
                        case TrackedField.TariffCode:
                            serviceAccountInfo.TariffCode = Common.NullSafeString(accountPropertiesNameValueList[key]);
                            break;
                        case TrackedField.TCap:
                            decimal? tCap = null;
                            decimal tCapTemp = 0;
                            if (decimal.TryParse(accountPropertiesNameValueList[key].ToString(), out tCapTemp))
                                tCap = tCapTemp;
                            serviceAccountInfo.TCap = tCap;
                            break;
                        case TrackedField.Voltage:
                            serviceAccountInfo.Voltage = Common.NullSafeString(accountPropertiesNameValueList[key]);
                            break;
                        case TrackedField.Zone:
                            serviceAccountInfo.Zone = Common.NullSafeString(accountPropertiesNameValueList[key]);
                            break;
                        case TrackedField.MeterNumber:
                            serviceAccountInfo.MeterNumber = Common.NullSafeString(accountPropertiesNameValueList[key]);
                            break;
                        case TrackedField.NameKey:
                            serviceAccountInfo.NameKey = Common.NullSafeString(accountPropertiesNameValueList[key]);
                            break;
                        case TrackedField.Strata:
                            serviceAccountInfo.Strata = Common.NullSafeString(accountPropertiesNameValueList[key]);
                            break;
                    }
                }

                Submit(serviceAccountInfo);

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
            }
            catch (Exception exc)
            {
                string innerException = exc == null ? "NULL VALUE" : exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString();
                string exception = exc == null ? "NULL VALUE" : exc.Message == null ? "NULL VALUE" : exc.Message;
                string errorMessage = exception + innerException;
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, errorMessage));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }


        public static string NullSaveDictionaryTrackedFieldString(Dictionary<TrackedField, string> value)
        {
            if (value == null)
                return "NULL";

            StringBuilder stringBuilder = new StringBuilder();
            bool isFirstIteration = true;
            foreach (TrackedField key in value.Keys)
            {
                if (!isFirstIteration)
                    stringBuilder.Append(",");
                stringBuilder.Append(string.Format("{0}:{1}", Common.NullSafeString(key), Common.NullSafeString(value[key])));
                isFirstIteration = false;
            }
            return stringBuilder.ToString();
        }
    }
}
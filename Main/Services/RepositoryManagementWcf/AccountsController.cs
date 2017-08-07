using AutoMapper;
using LibertyPower.RepositoryManagement.Core.AccountValidation;
using LibertyPower.RepositoryManagement.Data;
using DataContract = LibertyPower.RepositoryManagement.Contracts.AccountManagement.v1;
using LibertyPower.RepositoryManagement.Services;
using System;
using System.Threading;
using UtilityLogging;

namespace LibertyPower.RepositoryManagement.Contracts.AccountManagement.v1
{
    public class AccountsController : IAccountsController
    {
        #region private variables
        private ILogger _logger;
        private const string NAMESPACE = "LibertyPower.RepositoryManagement.Contracts.AccountManagement.v1";
        private const string CLASS = "AccountsController";
        private readonly IAccountManagementService accountManagementService;
        private readonly IAccountRequirementsProvider accountRequerementsProvider;
        private readonly IAccountValidationDataRequestUpdater accountInformationConsumer;
        private readonly IAccountManagementRepository accountManagementRepository;
        #endregion

        #region public constructors
        static AccountsController()
        {
            Mapper.CreateMap<DataContract.ServiceAccountInfo, Core.AccountManagement.ServiceAccountInfo>();
            Mapper.CreateMap<Core.AccountManagement.ServiceAccountInfo, DataContract.ServiceAccountInfo>();
        }

        public AccountsController(IAccountManagementService accountManagementService, IAccountRequirementsProvider mustHavePropertiesProvider, IAccountValidationDataRequestUpdater accountInformationConsumer, IAccountManagementRepository accountManagementRepository)
        {
            string messageId = Guid.NewGuid().ToString();
            string method = "AccountsController(IAccountManagementService accountManagementService, IAccountRequirementsProvider mustHavePropertiesProvider, IAccountValidationDataRequestUpdater accountInformationConsumer)";
            _logger = new Logger();
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                this.accountManagementService = accountManagementService;
                this.accountRequerementsProvider = mustHavePropertiesProvider;
                this.accountInformationConsumer = accountInformationConsumer;
                this.accountManagementRepository = accountManagementRepository;

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
        #endregion


        #region public methods
        public void ConvertValidateRetreiveCompareAndSave(DataContract.ServiceAccountInfo serviceAccount, string messageId)
        {
            string method = string.Format("ConvertValidateRetreiveCompareAndSave(serviceAccount:{0})", serviceAccount);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));


                var v = new ServiceAccountInfoValidator().Validate(serviceAccount);

                if (!v.IsValid)
                {
                    _logger.LogInfo(messageId, "ServiceAccountInfoValidator is not valid, throwing validation exception.");
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                    Validation.ThrowValidationException(v);
                }

                Core.AccountManagement.ServiceAccountInfo a = Mapper.Map<DataContract.ServiceAccountInfo, Core.AccountManagement.ServiceAccountInfo>(serviceAccount);
                _logger.LogInfo(messageId, string.Format("Saving ServiceAccountInfo:{0}", a));
                accountManagementService.Save(a, messageId);
                _logger.LogInfo(messageId, string.Format("ServiceAccountInfo:{0} Saved", a));


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

        public void UpdateCrmIfAccountMeetsPropertiesRequirements(int utilityId, string account, string messageId)
        {
            string method = string.Format("UpdateCrmIfAccountMeetsPropertiesRequirements(utilityId:{0},account:{1})", utilityId, Utilities.Common.NullSafeString(account));
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));


                accountManagementService.UpdateAccountConsumerIfAccountMeetsPropertiesRequirements(utilityId, account, accountRequerementsProvider, accountInformationConsumer, messageId);


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

        public void UpdateCrmIfAccountMeetsPropertiesRequirements(int? utilityId, string account, string messageId)
        {
            string method = string.Format("UpdateCrmIfAccountMeetsPropertiesRequirements(utilityId:{0},account:{1})", Utilities.Common.NullSafeString(utilityId), Utilities.Common.NullSafeString(account));
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));


                if (!utilityId.HasValue)
                {
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} utilityId does not have a value, returning.", NAMESPACE, CLASS, method));
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                    return;
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} Calling accountManagementService.UpdateAccountConsumerIfAccountMeetsPropertiesRequirements", NAMESPACE, CLASS, method));
                accountManagementService.UpdateAccountConsumerIfAccountMeetsPropertiesRequirements(utilityId.Value, account, accountRequerementsProvider, accountInformationConsumer, messageId);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} accountManagementService.UpdateAccountConsumerIfAccountMeetsPropertiesRequirements Called", NAMESPACE, CLASS, method));


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

        public LibertyPower.RepositoryManagement.Core.AccountManagement.ServiceAccountProperties GetServiceAccountProperties(string messageId, string utilityCode, string accountNumber)
        {
            string method = string.Format("GetServiceAccountProperties(messageId,utilityCode:{0},accountNumber:{1})", Utilities.Common.NullSafeString(utilityCode), Utilities.Common.NullSafeString(accountNumber));
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));


                if (string.IsNullOrWhiteSpace(accountNumber))
                {
                    _logger.LogError(messageId, string.Format("{0}.{1}.{2} accountNumber does not have a value, returning.", NAMESPACE, CLASS, method));
                    _logger.LogError(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                    return new Core.AccountManagement.ServiceAccountProperties();
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} Calling accountManagementService.GetServiceAccountProperties", NAMESPACE, CLASS, method));
                LibertyPower.RepositoryManagement.Core.AccountManagement.ServiceAccountProperties serviceAccountProperties = accountManagementService.GetServiceAccountProperties(utilityCode, accountNumber, messageId);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} accountManagementService.GetServiceAccountProperties Called", NAMESPACE, CLASS, method));

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} serviceAccountProperties:{3} END", NAMESPACE, CLASS, method, serviceAccountProperties));

                return serviceAccountProperties;
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

        #endregion
    }
}
using Core.Extensions.Strings;
using Core.Extensions.Collections;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading;
using LibertyPower.RepositoryManagement.Core;
using LibertyPower.RepositoryManagement.Core.AccountManagement;
using LibertyPower.RepositoryManagement.Core.AccountValidation;
using LibertyPower.RepositoryManagement.Data;
using Name = LibertyPower.RepositoryManagement.Dto.TrackedField;
using UtilityLogging;
using LibertyPower.RepositoryManagement.Dto;

namespace LibertyPower.RepositoryManagement.Services
{
    public class AccountManagementService : IAccountManagementService
    {
        #region private variables
        private ILogger _logger;
        private const string NAMESPACE = "LibertyPower.RepositoryManagement.Services";
        private const string CLASS = "AccountManagementService";
        private readonly IAccountManagementRepository repository;
        #endregion

        public AccountManagementService(IAccountManagementRepository repository)
        {
            string messageId = Guid.NewGuid().ToString();
            string method = "AccountManagementService(IAccountManagementRepository repository)";
            _logger = new Logger();
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));


                this.repository = repository;


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

        public void UpdateAccountConsumerIfAccountMeetsPropertiesRequirements(int utilityId, string account, IAccountRequirementsProvider provider, IAccountValidationDataRequestUpdater dataRequestUpdater, string messageId)
        {
            string method = string.Format("UpdateAccountConsumerIfAccountMeetsPropertiesRequirements(utilityId:{0}, account:{1}, provider, dataRequestUpdater, messageId)", utilityId, Utilities.Common.NullSafeString(account));
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));
                _logger.LogDebug(messageId, string.Format("{0}.{1}.{2} Calling provider.GetUtilitiesAccountMustHaveProperties(messageId)", NAMESPACE, CLASS, method));
                AccountRequirements utility = null;
                AccountValidationResponse accountValidationResponse = new AccountValidationResponse() { AccountNumber = account, UtilityId = utilityId, Source = "Repo Man", Timestamp = DateTime.Now };

                List<AccountRequirements> mustHaveProperties = provider.GetUtilitiesAccountMustHaveProperties(messageId);
                _logger.LogDebug(messageId, string.Format("{0}.{1}.{2} provider.GetUtilitiesAccountMustHaveProperties(messageId) Called", NAMESPACE, CLASS, method));
                if (mustHaveProperties == null)
                {
                    _logger.LogDebug(messageId, string.Format("{0}.{1}.{2} mustHaveProperties is null", NAMESPACE, CLASS, method));
                    accountValidationResponse.IsUsageResponseAccepted = false;
                    accountValidationResponse.IsDataProcessCompleted = false;
                    accountValidationResponse.Message = "No Must Have Properties.";
                }
                else
                {
                    _logger.LogDebug(messageId, string.Format("{0}.{1}.{2} else", NAMESPACE, CLASS, method));
                    _logger.LogDebug(messageId, string.Format("{0}.{1}.{2} mustHaveProperties.Count:{3}", NAMESPACE, CLASS, method, mustHaveProperties.Count));
                    if (mustHaveProperties.Count == 0)
                    {
                        _logger.LogDebug(messageId, string.Format("{0}.{1}.{2} mustHaveProperties.Count == 0", NAMESPACE, CLASS, method));
                    }
                    foreach (AccountRequirements aR in mustHaveProperties)
                    {
                        _logger.LogDebug(messageId, string.Format("{0}.{1}.{2} foreach (AccountRequirements aR in mustHaveProperties)", NAMESPACE, CLASS, method));
                        if (aR == null)
                            _logger.LogDebug(messageId, string.Format("{0}.{1}.{2} AccountRequirements is null", NAMESPACE, CLASS, method));
                        else
                            _logger.LogDebug(messageId, string.Format("{0}.{1}.{2} accountRequirements:{3}", NAMESPACE, CLASS, method, aR.ToString()));
                    }
                    _logger.LogDebug(messageId, string.Format("{0}.{1}.{2} mustHaveProperties.FirstOrDefault(p => p.UtilityId == utilityId):utilityId:{3}", NAMESPACE, CLASS, method, Utilities.Common.NullSafeString(utilityId)));
                    utility = mustHaveProperties.FirstOrDefault(p => p.UtilityId == utilityId);


                    if (utility == null)
                    {
                        _logger.LogDebug(messageId, string.Format("{0}.{1}.{2} utility is null", NAMESPACE, CLASS, method));
                        accountValidationResponse.IsUsageResponseAccepted = false;
                        accountValidationResponse.IsDataProcessCompleted = false;
                        accountValidationResponse.Message = String.Format("Utility ID {0} is undefined in the Account Info in Utility Management", utilityId);
                        accountValidationResponse.Timestamp = DateTime.Now;

                        dataRequestUpdater.Update(accountValidationResponse);
                        _logger.LogDebug(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                        return;
                    }

                    _logger.LogDebug(messageId, string.Format("{0}.{1}.{2} utility is not null", NAMESPACE, CLASS, method));
                    _logger.LogDebug(messageId, string.Format("{0}.{1}.{2} mustHaveProperties.FirstOrDefault(p => p.UtilityId == utilityId):utility:{3}", NAMESPACE, CLASS, method, Utilities.Common.NullSafeString(utility)));
                    _logger.LogDebug(messageId, string.Format("{0}.{1}.{2} accountValidationResponse:{3}", NAMESPACE, CLASS, method, accountValidationResponse.ToString()));

                    var utilityCode = TranslateUtilityCode(utility);
                    _logger.LogDebug(messageId, string.Format("utilityCode:{0}", utilityCode.ToString()));
                    var properties = GetServiceAccountProperties(utilityCode, account, messageId);
                    _logger.LogDebug(messageId, string.Format("properties:{0}", properties.ToString()));
                    List<string> missingProperties;
                    var pass = AccountMeetsPropertyRequirements(properties, utility.MustHaveProperties, out missingProperties, messageId);
                    _logger.LogDebug(messageId, string.Format("pass:{0}", pass));

                    if (pass)
                    {
                        accountValidationResponse.IsUsageResponseAccepted = true;
                        accountValidationResponse.IsDataProcessCompleted = true;
                        accountValidationResponse.Message = string.Empty;
                    }
                    else
                    {
                        accountValidationResponse.IsUsageResponseAccepted = false;
                        accountValidationResponse.IsDataProcessCompleted = false;
                        accountValidationResponse.Message = String.Format("Incomplete data fields: {0}.", missingProperties.ToString(","));
                    }
                    _logger.LogInfo(messageId, string.Format("Calling dataRequestUpdater.Update(accountValidationResponse:{0})", accountValidationResponse));
                    dataRequestUpdater.Update(accountValidationResponse);
                    _logger.LogInfo(messageId, string.Format("dataRequestUpdater.Update(accountValidationResponse:{0}) Called", accountValidationResponse));
                }
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, "ERROR");
                string innerException = exc == null ? "NULL VALUE" : exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString();
                string exception = exc == null ? "NULL VALUE" : exc.Message == null ? "NULL VALUE" : exc.Message;
                string errorMessage = exception + innerException;
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR11:{3}", NAMESPACE, CLASS, method, errorMessage));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END11", NAMESPACE, CLASS, method));
                throw;
            }
        }

        private string TranslateUtilityCode(AccountRequirements utility)
        {
            return utility.UtilityCode;
        }

        public bool AccountMeetsPropertyRequirements(Core.AccountManagement.ServiceAccountProperties account, List<string> requiredProperties, out List<string> missingProperties, string messageId)
        {
            string method = string.Format("AccountMeetsPropertyRequerements(account:{0}, requiredProperties, missingProperties, dataRequestUpdater, messageId)", account.ToString());
            bool returnValue = false;
            missingProperties = new List<string>();
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (account == null || requiredProperties == null)
                {
                    _logger.LogDebug("account is null or requiredProperties is null");
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                }
                else
                {
                    _logger.LogDebug(messageId, "account is not null");

                    missingProperties = requiredProperties.Where(r => account.Properties.Count
                    (
                        p => p.Name != null && p.Name.ToString() == r
                        &&
                        !(string.IsNullOrEmpty(p.Value) || ((p.Name.ToString().Trim().ToLower() == "icap" || p.Name.ToString().Trim().ToLower() == "tcap") && p.Value.ToString().Trim() == "-1"))
                    ) == 0).ToList();
                    _logger.LogDebug(messageId, "missingProperties calculated, missing properties is null = " + (missingProperties == null).ToString());

                    returnValue = missingProperties.Count == 0;

                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, returnValue));
                }

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

        public Core.AccountManagement.ServiceAccountProperties GetServiceAccountProperties(string utility, string account, string messageId)
        {
            string method = string.Format("GetServiceAccountProperties(utilityId:{0}, account:{1}, messageId)", Utilities.Common.NullSafeString(utility), Utilities.Common.NullSafeString(account));
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));



                Core.AccountManagement.ServiceAccountProperties serviceAccountProperties = repository.GetServiceAccountProperties(utility, account);



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

        public void Save(Core.AccountManagement.ServiceAccountInfo accountInfo, string messageId)
        {
            string method = string.Format("Save(accountInfo:{0}, messageId)", accountInfo);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));



                var a = accountInfo;
                Core.AccountManagement.ServiceAccountProperties incoming;
                try
                {
                    incoming = new Core.AccountManagement.ServiceAccountProperties() { AccountNumber = a.AccountNumber, Utility = a.Utility };
                    var c = System.Globalization.CultureInfo.InvariantCulture;
                    if (a.AccountType.HasValue()) incoming.Properties.Add(Property(a, Name.AccountType, a.AccountType));
                    if (a.BillingAccount.HasValue()) incoming.Properties.Add(Property(a, Name.BillingAccount, a.BillingAccount));
                    if (a.Grid.HasValue()) incoming.Properties.Add(Property(a, Name.Grid, a.Grid));
                    if (a.ICap.HasValue) incoming.Properties.Add(Property(a, Name.ICap, a.ICap.Value.ToString(c)));
                    if (a.LbmpZone.HasValue()) incoming.Properties.Add(Property(a, Name.LBMPZone, a.LbmpZone));
                    if (a.LoadProfile.HasValue()) incoming.Properties.Add(Property(a, Name.LoadProfile, a.LoadProfile));
                    if (a.LoadShapeId.HasValue()) incoming.Properties.Add(Property(a, Name.LoadShapeID, a.LoadShapeId));
                    if (a.LossFactor.HasValue) incoming.Properties.Add(Property(a, Name.LossFactor, a.LossFactor.Value.ToString(c)));
                    if (a.MeterType.HasValue()) incoming.Properties.Add(Property(a, Name.MeterType, a.MeterType));
                    if (a.MeterNumber.HasValue()) incoming.Properties.Add(Property(a, Name.MeterNumber, a.MeterNumber));
                    if (a.NameKey.HasValue()) incoming.Properties.Add(Property(a, Name.NameKey, a.NameKey));
                    if (a.RateClass.HasValue()) incoming.Properties.Add(Property(a, Name.RateClass, a.RateClass));
                    if (a.ServiceAddressZipCode.HasValue()) incoming.Properties.Add(Property(a, Name.ServiceAddressZipCode, a.ServiceAddressZipCode));
                    if (a.ServiceClass.HasValue()) incoming.Properties.Add(Property(a, Name.ServiceClass, a.ServiceClass));
                    if (a.Strata.HasValue()) incoming.Properties.Add(Property(a, Name.Strata, a.Strata));
                    if (a.TariffCode.HasValue()) incoming.Properties.Add(Property(a, Name.TariffCode, a.TariffCode));
                    if (a.TCap.HasValue) incoming.Properties.Add(Property(a, Name.TCap, a.TCap.Value.ToString(c)));
                    if (a.Utility.HasValue()) incoming.Properties.Add(Property(a, Name.Utility, a.Utility));
                    if (a.Voltage.HasValue()) incoming.Properties.Add(Property(a, Name.Voltage, a.Voltage));
                    if (a.Zone.HasValue()) incoming.Properties.Add(Property(a, Name.Zone, a.Zone));

                    _logger.LogInfo(messageId, string.Format("incoming:{0}", incoming));
                }
                catch (Exception ex)
                {
                    string innerException = ex == null ? "NULL VALUE" : ex.InnerException == null ? "NULL VALUE" : ex.InnerException.ToString();
                    string exception = ex == null ? "NULL VALUE" : ex.Message == null ? "NULL VALUE" : ex.Message;
                    string errorMessage = exception + innerException;
                    _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, errorMessage));
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                    throw new BusinessProcessException("Could not convert service account to internal representation", ex);
                }

                try
                {
                    var existing = repository.GetServiceAccountProperties(incoming.Utility, incoming.AccountNumber);
                    List<Core.AccountManagement.ServiceAccountProperty> propertiesToRemove = new List<Core.AccountManagement.ServiceAccountProperty>();
                    if (existing != null)
                    {
                        foreach (var n in incoming.Properties)
                        {
                            var e = existing.Properties.FirstOrDefault(x => x.Name == n.Name);
                            if (e != null && e.Value == n.Value)
                                //incoming.Properties.Remove(n);
                                propertiesToRemove.Add(n);
                        }

                        foreach (Core.AccountManagement.ServiceAccountProperty propertyToRemove in propertiesToRemove)
                        {
                            incoming.Properties.Remove(propertyToRemove);
                        }
                    }

                    _logger.LogInfo(messageId, string.Format("existing:{0}", existing));
                }
                catch (Exception ex)
                {
                    string innerException = ex == null ? "NULL VALUE" : ex.InnerException == null ? "NULL VALUE" : ex.InnerException.ToString();
                    string exception = ex == null ? "NULL VALUE" : ex.Message == null ? "NULL VALUE" : ex.Message;
                    string errorMessage = exception + innerException;
                    _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, errorMessage));
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                    throw new DataStoreException("Could not retreive existing service account properties for comparison", ex);
                }

                try
                {
                    _logger.LogInfo(messageId, string.Format("Saving incoming:{0} to repository", incoming));
                    repository.Save(incoming);
                    _logger.LogInfo(messageId, string.Format("incoming:{0} Saved to repository", incoming));
                }
                catch (Exception ex)
                {
                    string innerException = ex == null ? "NULL VALUE" : ex.InnerException == null ? "NULL VALUE" : ex.InnerException.ToString();
                    string exception = ex == null ? "NULL VALUE" : ex.Message == null ? "NULL VALUE" : ex.Message;
                    string errorMessage = exception + innerException;
                    _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, errorMessage));
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                    throw new DataStoreException("Could not save service account properties", ex);
                }



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

        private Core.AccountManagement.ServiceAccountProperty Property(ServiceAccountInfo account, TrackedField name, string value)
        {
            return new Core.AccountManagement.ServiceAccountProperty() { LockStatus = ServiceAccountLockStatus.Unknown, EffectiveDate = this.EffectiveDate, UpdateSource = account.UpdateSource, UpdateUser = account.UpdateUser, Name = name, Value = value };
        }

        private readonly DateTime effectiveDate = DateTime.Today;
        private DateTime EffectiveDate
        {
            get { return effectiveDate; }
        }
    }
}
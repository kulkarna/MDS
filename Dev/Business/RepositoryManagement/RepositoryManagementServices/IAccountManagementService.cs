using System.Collections.Generic;
using LibertyPower.RepositoryManagement.Core.AccountManagement;
using LibertyPower.RepositoryManagement.Core.AccountValidation;

namespace LibertyPower.RepositoryManagement.Services
{
    public interface IAccountManagementService
    {
        void Save(ServiceAccountInfo accountInfo, string messageId);
        ServiceAccountProperties GetServiceAccountProperties(string utility, string account, string messageId);
        void UpdateAccountConsumerIfAccountMeetsPropertiesRequirements(int utilityId, string account, IAccountRequirementsProvider accountRequerementsProvider, IAccountValidationDataRequestUpdater accountInformationConsumer, string messageId);
    }
}
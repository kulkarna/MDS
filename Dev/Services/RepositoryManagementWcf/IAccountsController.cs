using LibertyPower.RepositoryManagement.Core.AccountManagement;

namespace LibertyPower.RepositoryManagement.Contracts.AccountManagement.v1
{
    public interface IAccountsController
    {
        void ConvertValidateRetreiveCompareAndSave(v1.ServiceAccountInfo serviceAccount, string messageId);
        void UpdateCrmIfAccountMeetsPropertiesRequirements(int? utilityId, string account, string messageId);
        void UpdateCrmIfAccountMeetsPropertiesRequirements(int utilityId, string account, string messageId);
        LibertyPower.RepositoryManagement.Core.AccountManagement.ServiceAccountProperties GetServiceAccountProperties(string messageId, string utilityCode, string accountNumber);
        //string RetrieveZipCodeByAccountNumber(string messageId, string accountNumber);
    }
}
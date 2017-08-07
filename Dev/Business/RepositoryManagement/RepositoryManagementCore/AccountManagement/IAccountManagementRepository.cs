using LibertyPower.RepositoryManagement.Core.AccountManagement;

namespace LibertyPower.RepositoryManagement.Data
{
    public interface IAccountManagementRepository
    {
        void Save(ServiceAccountProperties value);
        ServiceAccountProperties GetServiceAccountProperties(string utility, string accountNumber);
        string GetZipCodeByAccountNumber(string messageId, string accountNumber);
    }
}
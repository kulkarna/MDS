using System;
using LibertyPower.RepositoryManagement.Core.AccountManagement;
using LibertyPower.RepositoryManagement.Data;

namespace LibertyPower.RepositoryManagement.Web.NullImplementations
{
    public class NullAccountManagementRepository : IAccountManagementRepository
    {
        public NullAccountManagementRepository(string connectionString)
        {
        }
        public void Save(ServiceAccountProperties value)
        {
            //throw new NotImplementedException();
        }
        public ServiceAccountProperties GetServiceAccountProperties(string utility, string accountNumber)
        {
            throw new NotImplementedException();
        }


        public string GetZipCodeByAccountNumber(string messageId, string accountNumber)
        {
            throw new NotImplementedException();
        }
    }
}
using LibertyPower.RepositoryManagement.Core.AccountManagement;

namespace LibertyPower.RepositoryManagement.Core.AccountValidation
{
    public interface IAccountValidationDataRequestUpdater
    {
        void Update(AccountValidationResponse validationData);
    }
}
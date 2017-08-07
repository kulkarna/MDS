using LibertyPower.RepositoryManagement.Core.AccountValidation;

namespace LibertyPower.RepositoryManagement.Web.NullImplementations
{
    public class NullAccountValidationDataRequestUpdater : IAccountValidationDataRequestUpdater
    {
        public void Update(AccountValidationResponse validationData)
        {
            return;
        }
    }
}
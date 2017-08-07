using System.Collections.Generic;

namespace LibertyPower.RepositoryManagement.Core.AccountValidation
{
    public interface IAccountRequirementsProvider
    {
        List<AccountRequirements> GetUtilitiesAccountMustHaveProperties(string messageId);
    }
}
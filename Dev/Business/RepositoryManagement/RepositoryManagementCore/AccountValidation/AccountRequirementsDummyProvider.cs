using System;
using System.Collections.Generic;
using System.Linq;
using LibertyPower.RepositoryManagement.Core.AccountManagement;
using LibertyPower.RepositoryManagement.Dto;

namespace LibertyPower.RepositoryManagement.Core.AccountValidation
{
    public class AccountRequirementsDummyProvider : IAccountRequirementsProvider
    {
        public List<AccountRequirements> GetUtilitiesAccountMustHaveProperties(string messageId)
        {
            var result = new List<AccountRequirements>();
            var mustHave = Enum.GetNames(typeof(TrackedField)).ToList();
            var utilities = new[] { "", "ACE", "AEPCE", "AEPNO", "ALLEGMD", "AMEREN", "BANGOR", "BGE", "CEI", "CENHUD", "CL&P", "CMP", "COMED", "CONED", "CSP", "CTPEN", "DAYTON", "DELDE", "DELMD", "DUKE", "DUQ", "JCP&L", "JCPL", "MECO", "METED", "NANT", "NECO", "NIMO", "NSTAR-BOS", "NSTAR-", "NSTAR-COMM", "NYSEG", "O&R", "OHED", "OHP", "ONCOR", "ONCOR-SESCO", "ORNJ", "PECO", "PENELEC", "PENNPR", "PEPCO-DC", "PEPCO-MD", "PGE", "PPL", "PSEG", "RGE", "ROCKLAND", "SCE", "SDGE", "SHARYLAND", "TOLED", "TXNMP", "TXU", "TXU-SESCO", "UGI", "UI", "UNITIL", "WMECO", "WPP" };

            for (int i = 1; i < utilities.Length; i++)
                result.Add(new AccountRequirements() { MustHaveProperties = mustHave, UtilityCode = utilities[i], UtilityId = i });

            return result;
        }
    }
}
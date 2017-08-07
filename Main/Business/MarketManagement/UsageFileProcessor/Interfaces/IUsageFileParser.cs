using System.Collections.Generic;
using LibertyPower.Business.MarketManagement.UtilityManagement;
using UsageFileProcessor.Entities;

namespace UsageFileProcessor.Interfaces
{
    public interface IUsageFileParser
    {
        string Error { get; }

        bool IsParser(UsageFile file);

        bool IsValidFileTemplate(UsageFile file);

        IEnumerable<ParserAccount> Parse(UsageFile file);

    }
}
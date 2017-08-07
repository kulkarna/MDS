using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
    [Serializable]
    public enum MappingRuleType
    {
        Unknown,
        ReplaceValueAlways,
        ReplaceIfValueExists,
        FillIfNoHistory,
        Alias
    }
}

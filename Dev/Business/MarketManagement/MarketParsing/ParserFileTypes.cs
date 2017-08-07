namespace LibertyPower.Business.MarketManagement.MarketParsing
{
    using System;
    using System.Collections.Generic;
    using System.Text;

    #region Enumerations

    public enum ParserFileType
    {
        Unknown,
        ErcotUtilityAccounts,
        UsageAep,
        UsageCtpen,
        UsageTxnmp,
        UsageTxu,
        UsageTxuSesco,
        UsageSharyland,
        UsageSce,
        UsageSdge,
        UsagePge,
        UsageOncor,
        CustomOfferAccounts,
        CustomOfferGenericUsage
    }

    #endregion Enumerations
}
namespace LibertyPower.Business.MarketManagement.MarketParsing
{
    using System;

    using LibertyPower.Business.MarketManagement.UtilityManagement;

    public static class UsageCandidateFactory
    {
        #region Methods

        public static UsageCandidate GetUsageCandidate(int excelRowNumber)
        {
            UsageCandidate usageCandidate = new UsageCandidate(excelRowNumber);
            return usageCandidate;
        }

        public static UsageCandidate GetUsageCandidate(int excelRowNumber, string sheetName)
        {
            UsageCandidate usageCandidate = new UsageCandidate(excelRowNumber, sheetName);
            return usageCandidate;
        }

        #endregion Methods
    }
}
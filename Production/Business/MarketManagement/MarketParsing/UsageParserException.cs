namespace LibertyPower.Business.MarketManagement.MarketParsing
{
    using System;
    using System.Collections.Generic;
    using System.Text;

    using LibertyPower.Business;

    /// <summary>
    /// Exception type thrown by the SceUsageParserException classes
    /// </summary>
    [Serializable]
    public class UsageParserException : BusinessException
    {
        #region Constructors

        public UsageParserException()
        {
        }

        public UsageParserException(string message)
            : base(message)
        {
        }

        public UsageParserException(string message, Exception innerException)
            : base(message, innerException)
        {
        }

        #endregion Constructors
    }
}
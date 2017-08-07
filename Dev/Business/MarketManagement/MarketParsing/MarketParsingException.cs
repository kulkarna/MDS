namespace LibertyPower.Business.MarketManagement.MarketParsing
{
    using System;

    using LibertyPower.Business.CommonBusiness.CommonExceptions;

    class MarketParsingException : BusinessException
    {
        #region Constructors

        public MarketParsingException()
            : base()
        {
        }

        public MarketParsingException( string message )
            : base(message)
        {
        }

        public MarketParsingException( string message, Exception innerException )
            : base(message, innerException)
        {
        }

        #endregion Constructors
    }
}
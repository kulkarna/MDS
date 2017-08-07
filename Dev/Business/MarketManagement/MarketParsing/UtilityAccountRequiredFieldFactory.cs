namespace LibertyPower.Business.MarketManagement.MarketParsing
{
    using System;
    using System.Collections.Generic;
    using System.Text;

    public static class ParserColumnFactory
    {
        #region Methods

        internal static ParserColumn GetParserColumn( string name, bool required, string context, int createdBy, DateTime dateCreated, int lastModifiedBy, DateTime dateLastModified)
        {
            return new ParserColumn( name, required,  context, createdBy, dateCreated,  lastModifiedBy,  dateLastModified);
        }

        #endregion Methods
    }
}
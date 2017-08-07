namespace LibertyPower.Business.MarketManagement.MarketParsing
{
    using System;
    using System.Collections.Generic;
    using System.Text;

    using LibertyPower.Business.CommonBusiness.CommonEntity;
    using LibertyPower.Business.CommonBusiness.CommonRules;
    using LibertyPower.Business.CommonBusiness.FileManager;
    using LibertyPower.Business.MarketManagement.UtilityManagement;
    using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;

    internal class ListOfAccountsParser : Parser
    {
        #region Constructors

        internal ListOfAccountsParser( FileContext context )
            : base(context)
        {
            // Validate excel schema and create unvalidated list of accounts
            try
            {
                this.utilityAccounts = UsageFileParserFactory.GetUtilityAccountsFromUtilityAccountFile(this.fileContext);
                this.parserFileType = ParserFileType.UtilityAccounts;
            }
            catch( BrokenRuleException e )
            {
                this.brokenRuleException = e;
            }
        }

        #endregion Constructors
    }
}
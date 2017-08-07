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

    internal class CtpenUsageParser : Parser
    {
        #region Constructors

        internal CtpenUsageParser( FileContext context )
            : base(context)
        {
            // Validate excel schema and create unvalidated list of accounts
            try
            {
                this.utilityAccounts = OfferEngineUploadsParserFactory.GetUtilityAccountsWithUsagesFromCtpen(this.fileContext);
                this.parserFileType = ParserFileType.UsageCtpen;
            }
            catch( BrokenRuleException e )
            {
                this.brokenRuleException = e;
            }
        }

        #endregion Constructors
    }
}
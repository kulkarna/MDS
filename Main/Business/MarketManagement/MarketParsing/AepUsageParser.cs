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

    internal class AepUsageParser : Parser
    {
        #region Constructors

        internal AepUsageParser( FileContext context )
            : base(context)
        {
            // Validate excel schema and create unvalidated list of accounts
            try
            {
                this.utilityAccounts = OfferEngineUploadsParserFactory.GetUtilityAccountsWithUsagesFromAep(this.fileContext);
                this.parserFileType = ParserFileType.UsageAep;
            }
            catch( BrokenRuleException e )
            {
                this.brokenRuleException = e;
            }
        }

        #endregion Constructors
    }

    internal class OncorUsageParser : Parser
    {
        #region Constructors

        internal OncorUsageParser(FileContext context)
            : base(context)
        {
            // Validate excel schema and create unvalidated list of accounts
            try
            {
                this.utilityAccounts = OfferEngineUploadsParserFactory.GetUtilityAccountsWithUsagesFromOncor(this.fileContext);
                this.parserFileType = ParserFileType.UsageOncor;
            }
            catch (BrokenRuleException e)
            {
                this.brokenRuleException = e;
            }
        }

        #endregion Constructors
    }
}
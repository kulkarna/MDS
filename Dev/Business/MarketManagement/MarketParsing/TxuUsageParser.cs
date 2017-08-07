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

    public class TxuUsageParser : Parser
    {
        #region Constructors

        public TxuUsageParser( FileContext context )
            : base(context)
        {
            // Validate excel schema and create unvalidated list of accounts with usages
            try
            {
                utilityAccounts = OfferEngineUploadsParserFactory.GetUtilityAccountsWithUsagesFromTxu(fileContext);
                this.parserFileType = ParserFileType.UsageTxu;
            }
            catch( BrokenRuleException e )
            {
                brokenRuleException = e;
                return;
            }
        }

        #endregion Constructors
    }
}
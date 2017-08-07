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

    //done
    internal class TxuSescoUsageParser : Parser
    {
        #region Constructors

        internal TxuSescoUsageParser(FileContext context)
            : base(context)
        {
            // Validate excel schema and create unvalidated list of accounts with usages
                try
                {
                    this.utilityAccounts = OfferEngineUploadsParserFactory.GetUtilityAccountsWithUsagesFromTxuSesco(fileContext);
                    this.parserFileType = ParserFileType.UsageTxuSesco;
                }
                catch (BrokenRuleException e)
                {
                    this.brokenRuleException = e;
                }
        }

        #endregion Constructors
    }
}
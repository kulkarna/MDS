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

    internal class TxuSescoParser : Parser
    {
        #region Constructors

        internal TxuSescoParser(FileContext context)
            : base(context)
        {
            // Validate excel schema and create unvalidated list of accounts with usages
                try
                {
                    this.utilityAccounts = OfferEngineUploadsParserFactory.GetUtilityAccountsWithUsagesFromTxnmp(fileContext);
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
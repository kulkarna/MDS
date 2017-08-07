namespace LibertyPower.Business.MarketManagement.MarketParsing
{

    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;
    using LibertyPower.Business.CommonBusiness.CommonEntity;
    using LibertyPower.Business.CommonBusiness.CommonRules;
    using LibertyPower.Business.CommonBusiness.FileManager;
    using LibertyPower.Business.MarketManagement.UtilityManagement;
    using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;

    internal class CustomOfferListOfAccountsParser : Parser
    {
        #region Constructors


        internal CustomOfferListOfAccountsParser(FileContext context)
            : base(context)
        {
            // Validate excel schema and create unvalidated list of accounts
            try
            {
                this.parserFileType = ParserFileType.CustomOfferAccounts; 
                this.utilityAccounts = OfferEngineUploadsParserFactory.GetUtilityAccountsFromCustomOfferLOAFile(this.fileContext);
              
            }
            catch( BrokenRuleException e )
            {
                this.brokenRuleException = e;
            }
        }

        #endregion Constructors
    }
}

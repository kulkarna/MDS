//namespace LibertyPower.Business.MarketManagement.MarketParsing
//{
//    using System;
//    using System.Collections.Generic;
//    using System.Text;

//    using LibertyPower.Business.CommonBusiness.CommonEntity;
//    using LibertyPower.Business.CommonBusiness.CommonRules;
//    using LibertyPower.Business.CommonBusiness.FileManager;
//    using LibertyPower.Business.MarketManagement.UtilityManagement;
//    using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;

//    /// <summary>
//    /// This class is used to parse address updates to any Prospect accounts that already exist
//    /// </summary>
//    public class ListOfAccountsAddressUpdate : Parser
//    {
//        #region Constructors

//        internal ListOfAccountsAddressUpdate( FileContext context )
//            : base(context)
//        {
//            // Validate excel schema and create unvalidated list of accounts
//            try
//            {
//                this.utilityAccounts = UsageFileParserFactory.GetUtilityAccountsFromUtilityAccountFile(this.fileContext);
//                this.parserFileType = ParserFileType.UtilityAccounts;
//            }
//            catch( BrokenRuleException e )
//            {
//                this.brokenRuleException = e;
//            }
//        }

//        #endregion Constructors
//    }
//}
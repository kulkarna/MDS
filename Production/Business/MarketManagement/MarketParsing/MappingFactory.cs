namespace LibertyPower.Business.MarketManagement.MarketParsing
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;
    using System.Data;
	using LibertyPower.Business.CommonBusiness.CommonEntity;
	using LibertyPower.Business.CommonBusiness.FileManager;
    using LibertyPower.Business.MarketManagement.EdiParser.FileParser;
    using LibertyPower.Business.CommonBusiness.CommonHelper;
    using LibertyPower.Business.MarketManagement.UtilityManagement;
    using LibertyPower.DataAccess.WorkbookAccess;


    public static class MappingFactory
    {
        /// <summary>
        /// Get data from a managed file
        /// </summary>
        /// <param name="accountNumber"></param>
        /// <param name="utilityCode"></param>
        /// <returns></returns>
        /// 
        public static DataView GetManagedFileAccountData( string accountNumber, string utilityCode )
        {
            DataView dv = null;

            AccountManagedFile amf = FileFactory.GetAccountManagedFile( accountNumber, utilityCode, AccountManagedFileType.AccountData );
            if( amf != null )
            {
                Guid fileGuid = amf.FileGuid;
                FileContext context = FileManagerFactory.GetFileContextByGuid( fileGuid );
                string filePath = context.FullFilePath;

                DataSet ds = ExcelAccess.GetWorkbook( filePath );
                if( DataSetHelper.HasRow( ds ) )
                {
                    dv = ds.Tables[0].DefaultView;
                    dv.RowFilter = "([0] = '" + accountNumber + "' AND [2] = '" + utilityCode + "') OR ([0] = 'Account Number')";
                    return dv;
                }
            }
            return dv;
        }

        public static FileAccountList GetFileAccountList( string accountNumber, string utilityCode )
        {
            FileAccountList accounts = new FileAccountList();
            Guid fileGuid;
            FileContext context;
            AccountManagedFile amf;

            var market = UtilityFactory.GetUtilityByCode( utilityCode ).RetailMarketCode;

            // for TX and CA markets, use market parsing
            if( market == "TX" || market == "CA" )
            {

                amf = FileFactory.GetAccountManagedFile( accountNumber, utilityCode, AccountManagedFileType.AccountData );
                if (amf != null)
                {
                    fileGuid = amf.FileGuid;
                    context = FileManagerFactory.GetFileContextByGuid(fileGuid);

                    accounts = GetFileAccountList(accountNumber, utilityCode, context);
                }

                if (amf == null || accounts.Count == 0)
                {
                    amf = FileFactory.GetAccountManagedFile(accountNumber, utilityCode, AccountManagedFileType.UsageData);
                    if (amf != null)
                    {
                        fileGuid = amf.FileGuid;
                        context = FileManagerFactory.GetFileContextByGuid(fileGuid);

                        accounts = GetFileAccountList(accountNumber, utilityCode, context);
                    }
                }

            }
            else // use file factory to get data
            {
                // file factory will get accounts and their associated usage
                accounts = GetFileAccountList( FileFactory.GetWebAccountList( accountNumber, utilityCode ) );

                // if no accounts found, get any usages and create account list with associated usages
                if( accounts.Count == 0 )
                {
                    WebUsageList usageList = FileFactory.GetWebUsageList( accountNumber, utilityCode );
                    FileAccount account = new FileAccount();
                    account.AccountNumber = accountNumber;
                    account.UtilityCode = utilityCode;
                    account.WebUsageList = usageList;
                    accounts.Add( account );
                }
            }
            return accounts;
        }

        private static FileAccountList GetFileAccountList( string accountNumber, string utilityCode, FileContext context )
        {
            FileAccountList accounts = new FileAccountList();
            ParserResult parserResult = null;
            ParserFileType parserFileType;

            parserFileType = OfferEngineUploadsParserFactory.DetermineParserFileType( context );

            if( parserFileType != ParserFileType.Unknown )
            {
                parserResult = OfferEngineUploadsParserFactory.GetParserResult( context );

                if( parserResult.UtilityAccounts != null )
                {
                    var list = (from p in parserResult.UtilityAccounts
                                where p.AccountNumber.ToLower().Trim() == accountNumber.ToLower().Trim()
                                && (p.UtilityCode == null || p.UtilityCode.ToLower().Trim() == utilityCode.ToLower().Trim())
                                select p).ToList<UtilityAccount>();
                    accounts = FileFactory.GetFileAccountList( list );
                }

                for(var i=0;i<accounts.Count;i++)
                {
                    if (accounts.Count > 0 && accounts[0].UtilityCode == null)
                        accounts[0].UtilityCode = utilityCode;
                }
            }
            return accounts;
        }

        #region obsolete
        //public static UtilityAccount GetUtilityMappingDriver( UtilityAccount utilityAccount )
        //{
        //    string errorDescriptions = "";
        //    return GetUtilityMappingDriver( utilityAccount, out errorDescriptions );
        //}

        //public static UtilityAccount GetUtilityMappingDriver( UtilityAccount utilityAccount, out string errorDescriptions )
        //{
        //    errorDescriptions = "";
        //    string accountNumber = utilityAccount.AccountNumber;
        //    string utilityCode = utilityAccount.UtilityCode;
        //    UtilityAccount utilityMappedAccount = UtilityMappingFactory.CopyAccountProperties( utilityAccount );

        //    UtilityMappingDriverExistsRule rule = new UtilityMappingDriverExistsRule( utilityAccount );
        //    if( !rule.Validate() )
        //    {
        //        // no drivers found for utility
        //        if( rule.Exception.DependentExceptions == null )
        //        {
        //            errorDescriptions = rule.Exception.Message;
        //            UtilityMappingLogger.LogMessage( accountNumber, utilityCode, errorDescriptions, rule.Exception.Severity, LpcApplication.OfferEngine, DateTime.Now );

        //            return utilityMappedAccount;
        //        }
        //        else // remove all dependent exceptions, prepare to build final dependent exception list
        //        {
        //            rule.Exception.DependentExceptions.Clear();
        //        }

        //        WebAccountList ediAccounts = EdiFactory.GetWebAccountList( EdiFactory.GetEdiAccount( accountNumber, utilityCode ) );
        //        //FileAccountList fileAccounts = GetFileAccountList( accountNumber, utilityCode ); //not looking at file data; this will come exclusively from PDAPI
        //        WebAccountList scraperAccounts = ScraperFactory.GetAccount( accountNumber, utilityCode );

        //        UtilityClassMappingDeterminantList determinants = UtilityMappingFactory.GetUtilityClassMappingDeterminants( utilityCode );

        //        foreach( UtilityClassMappingDeterminant d in determinants )
        //        {
        //            string driver = d.Driver;
        //            GetDriverData( ediAccounts, null, scraperAccounts, utilityMappedAccount, driver, rule );
        //        }

        //        // if there are dependent exceptions after attempting to get driver data, then one or more drivers were not found.
        //        if( rule.Exception != null )
        //        {
        //            BrokenRuleExceptionList errors = rule.Exception.UnnestedExceptions();

        //            foreach( BrokenRuleException error in errors )
        //            {
        //                if( errorDescriptions.Length > 0 )
        //                {
        //                    errorDescriptions += Environment.NewLine;
        //                }
        //                errorDescriptions += error.Message;

        //                UtilityMappingLogger.LogMessage( accountNumber, utilityCode, error.Message, rule.Exception.Severity, LpcApplication.OfferEngine, DateTime.Now );
        //            }
        //        }
        //    }
        //    return utilityMappedAccount;
        //}

        //private static void GetDriverData( WebAccountList ediAccounts, FileAccountList fileAccounts, WebAccountList scraperAccounts,
        //    UtilityAccount utilityAccount, string driver, UtilityMappingDriverExistsRule rule )
        //{
        //    string accountNumber = utilityAccount.AccountNumber;
        //    string utilityCode = utilityAccount.UtilityCode;

        //    switch( driver )
        //    {
        //        case "Grid":
        //            {
        //                if( FileAccountDataExists( fileAccounts ) )
        //                {
        //                    if (string.IsNullOrEmpty(utilityAccount.Grid)) //only map if value is missing
        //                    {
        //                        utilityAccount.Grid = ((FileAccount) fileAccounts[0]).Grid;
        //                        if (!string.IsNullOrEmpty(utilityAccount.Grid))
        //                            rule.Exception.DependentExceptions.Add(new BrokenRuleException(new UtilityMappingDriverExistsRule(utilityAccount),string.Format("Determinant [Grid] has been mapped from raw file data: {0}",utilityAccount.Grid)));
        //                    }
        //                    else
        //                    {
        //                        rule.Exception.DependentExceptions.Add(
        //                                        new BrokenRuleException(new UtilityMappingDriverExistsRule(utilityAccount),
        //                                                                string.Format(
        //                                                                    "Determinant [Grid] has been mapped from existing data: {0}",
        //                                                                    utilityAccount.Grid)));
        //                    }
        //                }

        //                if(string.IsNullOrEmpty(utilityAccount.Grid) && WebAccountDataExists( scraperAccounts ) )
        //                {
        //                    if (string.IsNullOrEmpty(utilityAccount.Grid)) //only map if value is missing
        //                    {
        //                        if (utilityAccount.UtilityCode.ToUpper().Contains("NYSEG"))
        //                        {
        //                            utilityAccount.Grid = ((Nyseg) scraperAccounts[0]).Grid;
        //                            if (!string.IsNullOrEmpty(utilityAccount.Grid))
        //                                rule.Exception.DependentExceptions.Add(
        //                                    new BrokenRuleException(new UtilityMappingDriverExistsRule(utilityAccount),
        //                                                            string.Format(
        //                                                                "Determinant [Grid] has been mapped from raw scraper data: {0}",
        //                                                                utilityAccount.Grid)));
        //                        }
        //                        else if (utilityAccount.UtilityCode.ToUpper().Contains("RGE"))
        //                        {
        //                            utilityAccount.Grid = ((Rge) scraperAccounts[0]).Grid;
        //                            if (!string.IsNullOrEmpty(utilityAccount.Grid))
        //                                rule.Exception.DependentExceptions.Add(
        //                                    new BrokenRuleException(new UtilityMappingDriverExistsRule(utilityAccount),
        //                                                            string.Format(
        //                                                                "Determinant [Grid] has been mapped from raw scraper data: {0}",
        //                                                                utilityAccount.Grid)));
        //                        }
        //                    }
        //                    else
        //                    {
        //                        rule.Exception.DependentExceptions.Add(
        //                                        new BrokenRuleException(new UtilityMappingDriverExistsRule(utilityAccount),
        //                                                                string.Format(
        //                                                                    "Determinant [Grid] has been mapped from existing data: {0}",
        //                                                                    utilityAccount.Grid)));
        //                    }

        //                }

        //                if( string.IsNullOrEmpty(utilityAccount.Grid) )
        //                {
        //                    rule.Exception.DependentExceptions.Add( new BrokenRuleException( new UtilityMappingDriverExistsRule( utilityAccount ), String.Format( "Utility mapping driver [Grid] is missing for account number: {0} utility: {1}, and is not in raw data", accountNumber, utilityCode ), BrokenRuleSeverity.Error ) );
        //                }
        //                break;
        //            }
        //        case "LBMPZone":
        //            {
        //                if (string.IsNullOrEmpty(utilityAccount.LBMPZone))
        //                {
        //                    if (FileAccountDataExists(fileAccounts))
        //                    {
        //                        utilityAccount.LBMPZone = ((FileAccount) fileAccounts[0]).LbmpZone;
        //                        if (!string.IsNullOrEmpty(utilityAccount.LBMPZone))
        //                            rule.Exception.DependentExceptions.Add(
        //                                new BrokenRuleException(new UtilityMappingDriverExistsRule(utilityAccount),
        //                                                        string.Format(
        //                                                            "Determinant [LBMPZone] has been mapped from raw file data: {0}",
        //                                                            utilityAccount.LBMPZone)));
        //                    }
        //                    if (string.IsNullOrEmpty(utilityAccount.LBMPZone) && WebAccountDataExists(scraperAccounts))
        //                    {
        //                        if (utilityAccount.UtilityCode.ToUpper().Contains("CONED"))
        //                        {
        //                            utilityAccount.LBMPZone = ((Coned) scraperAccounts[0]).ZoneCode;
        //                            if (!string.IsNullOrEmpty(utilityAccount.LBMPZone))
        //                                rule.Exception.DependentExceptions.Add(
        //                                    new BrokenRuleException(new UtilityMappingDriverExistsRule(utilityAccount),
        //                                                            string.Format(
        //                                                                "Determinant [LBMPZone] has been mapped from raw scraper data: {0}",
        //                                                                utilityAccount.LBMPZone)));
        //                        }
        //                    }
        //                }
        //                else
        //                {
        //                    rule.Exception.DependentExceptions.Add(
        //                                    new BrokenRuleException(new UtilityMappingDriverExistsRule(utilityAccount),
        //                                                            string.Format(
        //                                                                "Determinant [LBMPZone] has data: {0}",
        //                                                                utilityAccount.LBMPZone)));
        //                }


        //                if( string.IsNullOrEmpty(utilityAccount.LBMPZone) )
        //                {
        //                    rule.Exception.DependentExceptions.Add(new BrokenRuleException(new UtilityMappingDriverExistsRule(utilityAccount), String.Format("Utility mapping driver [LBMP Zone] is missing for account number: {0} utility: {1}, and is not in raw data", accountNumber, utilityCode), BrokenRuleSeverity.Error));
        //                }
        //                break;
        //            }
        //        case "LoadProfileID":
        //            {
        //                if (string.IsNullOrEmpty(utilityAccount.LoadProfile))
        //                {
        //                    if (WebAccountDataExists(ediAccounts))
        //                    {
        //                        utilityAccount.LoadProfile = ediAccounts[0].LoadProfile;
        //                        if (!string.IsNullOrEmpty(utilityAccount.LoadProfile))
        //                            rule.Exception.DependentExceptions.Add(
        //                                new BrokenRuleException(new UtilityMappingDriverExistsRule(utilityAccount),
        //                                                        string.Format(
        //                                                            "Determinant [Profile] has been mapped from raw edi data: {0}",
        //                                                            utilityAccount.LoadProfile)));
        //                    }

        //                    if (string.IsNullOrEmpty(utilityAccount.LoadProfile) && FileAccountDataExists(fileAccounts))
        //                    {
        //                        utilityAccount.LoadProfile = fileAccounts[0].LoadProfile;
        //                        if (!string.IsNullOrEmpty(utilityAccount.LoadProfile))
        //                            rule.Exception.DependentExceptions.Add(
        //                                new BrokenRuleException(new UtilityMappingDriverExistsRule(utilityAccount),
        //                                                        string.Format(
        //                                                            "Determinant [Profile] has been mapped from raw file data: {0}",
        //                                                            utilityAccount.LoadProfile)));
        //                    }
        //                    if (string.IsNullOrEmpty(utilityAccount.LoadProfile) && WebAccountDataExists(scraperAccounts))
        //                    {
        //                        utilityAccount.LoadProfile = scraperAccounts[0].LoadProfile;
        //                        if (!string.IsNullOrEmpty(utilityAccount.LoadProfile))
        //                            rule.Exception.DependentExceptions.Add(
        //                                new BrokenRuleException(new UtilityMappingDriverExistsRule(utilityAccount),
        //                                                        string.Format(
        //                                                            "Determinant [Profile] has been mapped from raw scraper data: {0}",
        //                                                            utilityAccount.LoadProfile)));
        //                    }
        //                }
        //                else
        //                {
        //                    rule.Exception.DependentExceptions.Add(
        //                                    new BrokenRuleException(new UtilityMappingDriverExistsRule(utilityAccount),
        //                                                            string.Format(
        //                                                                "Determinant [Profile] has data: {0}",
        //                                                                utilityAccount.LoadProfile)));
        //                }

        //                if( string.IsNullOrEmpty(utilityAccount.LoadProfile) )
        //                {
        //                    rule.Exception.DependentExceptions.Add(new BrokenRuleException(new UtilityMappingDriverExistsRule(utilityAccount), String.Format("Utility mapping driver [Load Profile ID] is missing for account number: {0} utility: {1}, and is not in raw data", accountNumber, utilityCode), BrokenRuleSeverity.Error));
        //                }
        //                break;
        //            }
        //        case "LoadShapeID":
        //            {
        //                if (string.IsNullOrEmpty(utilityAccount.LoadShapeId))
        //                {
        //                    if (WebAccountDataExists(ediAccounts))
        //                    {
        //                        utilityAccount.LoadShapeId = ediAccounts[0].LoadShapeId;
        //                        if (!string.IsNullOrEmpty(utilityAccount.LoadShapeId))
        //                            rule.Exception.DependentExceptions.Add(
        //                                new BrokenRuleException(new UtilityMappingDriverExistsRule(utilityAccount),
        //                                                        string.Format(
        //                                                            "Determinant [LoadShapeID] has been mapped from raw edi data: {0}",
        //                                                            utilityAccount.LoadShapeId)));
        //                    }
        //                    if (string.IsNullOrEmpty(utilityAccount.LoadShapeId) && FileAccountDataExists(fileAccounts))
        //                    {
        //                        utilityAccount.LoadShapeId = fileAccounts[0].LoadShapeId;
        //                        if (!string.IsNullOrEmpty(utilityAccount.LoadShapeId))
        //                            rule.Exception.DependentExceptions.Add(
        //                                new BrokenRuleException(new UtilityMappingDriverExistsRule(utilityAccount),
        //                                                        string.Format(
        //                                                            "Determinant [LoadShapeID] has been mapped from raw file data: {0}",
        //                                                            utilityAccount.LoadShapeId)));
        //                    }
        //                    if (string.IsNullOrEmpty(utilityAccount.LoadShapeId) && WebAccountDataExists(scraperAccounts))
        //                    {
        //                        utilityAccount.LoadShapeId = scraperAccounts[0].LoadShapeId;
        //                        if (!string.IsNullOrEmpty(utilityAccount.LoadShapeId))
        //                            rule.Exception.DependentExceptions.Add(
        //                                new BrokenRuleException(new UtilityMappingDriverExistsRule(utilityAccount),
        //                                                        string.Format(
        //                                                            "Determinant [LoadShapeID] has been mapped from raw scraper data")));
        //                    }
        //                }
        //                else
        //                {
        //                    rule.Exception.DependentExceptions.Add(
        //                                    new BrokenRuleException(new UtilityMappingDriverExistsRule(utilityAccount),
        //                                                            string.Format(
        //                                                                "Determinant [LoadShapeId] has data: {0}",
        //                                                                utilityAccount.LoadShapeId)));
        //                }

        //                if( string.IsNullOrEmpty(utilityAccount.LoadShapeId) )
        //                {
        //                    rule.Exception.DependentExceptions.Add(new BrokenRuleException(new UtilityMappingDriverExistsRule(utilityAccount), String.Format("Utility mapping driver [Load Shape ID] is missing for account number: {0} utility: {1}, and is not in raw data", accountNumber, utilityCode), BrokenRuleSeverity.Error));
        //                }
        //                break;
        //            }
        //        case "RateClassID":
        //            {
        //                if (string.IsNullOrEmpty(utilityAccount.RateClass))
        //                {
        //                    if (WebAccountDataExists(ediAccounts))
        //                    {
        //                        utilityAccount.RateClass = ediAccounts[0].RateClass;
        //                        if (!string.IsNullOrEmpty(utilityAccount.RateClass))
        //                            rule.Exception.DependentExceptions.Add(
        //                                new BrokenRuleException(new UtilityMappingDriverExistsRule(utilityAccount),
        //                                                        string.Format(
        //                                                            "Determinant [RateClass] has been mapped from raw edi data: {0}",
        //                                                            utilityAccount.RateClass)));
        //                    }
        //                    if (string.IsNullOrEmpty(utilityAccount.RateClass) && FileAccountDataExists(fileAccounts))
        //                    {
        //                        utilityAccount.RateClass = fileAccounts[0].RateClass;
        //                        if (!string.IsNullOrEmpty(utilityAccount.RateClass))
        //                            rule.Exception.DependentExceptions.Add(
        //                                new BrokenRuleException(new UtilityMappingDriverExistsRule(utilityAccount),
        //                                                        string.Format(
        //                                                            "Determinant [RateClass] has been mapped from raw file data: {0}",
        //                                                            utilityAccount.RateClass)));
        //                    }
                            
        //                    if (string.IsNullOrEmpty(utilityAccount.RateClass) && WebAccountDataExists(scraperAccounts))
        //                    {
        //                        utilityAccount.RateClass = scraperAccounts[0].RateClass;
        //                        if (!string.IsNullOrEmpty(utilityAccount.RateClass))
        //                            rule.Exception.DependentExceptions.Add(
        //                                new BrokenRuleException(new UtilityMappingDriverExistsRule(utilityAccount),
        //                                                        string.Format(
        //                                                            "Determinant [RateClass] has been mapped from raw scraper data: {0}",
        //                                                            utilityAccount.RateClass)));
        //                    }
        //                }
        //                else
        //                {
        //                    rule.Exception.DependentExceptions.Add(
        //                                    new BrokenRuleException(new UtilityMappingDriverExistsRule(utilityAccount),
        //                                                            string.Format(
        //                                                                "Determinant [RateClass] has data: {0}",
        //                                                                utilityAccount.RateClass)));
        //                }

        //                if( string.IsNullOrEmpty(utilityAccount.RateClass) )
        //                {
        //                    rule.Exception.DependentExceptions.Add(new BrokenRuleException(new UtilityMappingDriverExistsRule(utilityAccount), String.Format("Utility mapping driver [Rate Class ID] is missing for account number: {0} utility: {1}, and is not in raw data", accountNumber, utilityCode), BrokenRuleSeverity.Error));
        //                }
        //                break;
        //            }
        //        case "ServiceClassID":
        //            {
        //                if (string.IsNullOrEmpty(utilityAccount.ServiceClass))
        //                {
        //                    if (WebAccountDataExists(scraperAccounts))
        //                    {
        //                        if (utilityAccount.UtilityCode.ToUpper().Contains("CONED"))
        //                        {
        //                            // rate class is the service class for CONED
        //                            utilityAccount.ServiceClass = ((Coned) scraperAccounts[0]).RateClass;
        //                            if (!string.IsNullOrEmpty(utilityAccount.ServiceClass))
        //                                rule.Exception.DependentExceptions.Add(
        //                                    new BrokenRuleException(new UtilityMappingDriverExistsRule(utilityAccount),
        //                                                            string.Format(
        //                                                                "Determinant [Service Class] has been mapped from raw scraper data: {0}",
        //                                                                utilityAccount.ServiceClass)));
        //                        }
        //                    }
        //                }
        //                else
        //                {
        //                    rule.Exception.DependentExceptions.Add(
        //                                    new BrokenRuleException(new UtilityMappingDriverExistsRule(utilityAccount),
        //                                                            string.Format(
        //                                                                "Determinant [Service Class] has data: {0}",
        //                                                                utilityAccount.ServiceClass)));
        //                }

        //                if( string.IsNullOrEmpty(utilityAccount.ServiceClass) )
        //                {
        //                    rule.Exception.DependentExceptions.Add(new BrokenRuleException(new UtilityMappingDriverExistsRule(utilityAccount), String.Format("Utility mapping driver [Service Class] is missing for account number: {0} utility: {1}, and is not in raw data", accountNumber, utilityCode), BrokenRuleSeverity.Error));
        //                }
        //                break;
        //            }
        //        case "TariffCodeID":
        //            {
        //                if (String.IsNullOrEmpty(utilityAccount.TariffCode))
        //                {
        //                    if (FileAccountDataExists(fileAccounts))
        //                    {
        //                        utilityAccount.TariffCode = ((FileAccount) fileAccounts[0]).TariffCode;
        //                        if (!string.IsNullOrEmpty(utilityAccount.TariffCode))
        //                            rule.Exception.DependentExceptions.Add(
        //                                new BrokenRuleException(new UtilityMappingDriverExistsRule(utilityAccount),
        //                                                        string.Format(
        //                                                            "Determinant [TariffCode] has been mapped from raw file data: {0}",
        //                                                            utilityAccount.TariffCode)));
        //                    }
        //                    if (string.IsNullOrEmpty(utilityAccount.TariffCode) && WebAccountDataExists(scraperAccounts))
        //                    {
        //                        if (utilityAccount.UtilityCode.ToUpper().Contains("BGE"))
        //                        {
        //                            utilityAccount.TariffCode = ((Bge) scraperAccounts[0]).TariffCode.ToString();
        //                            rule.Exception.DependentExceptions.Add(
        //                                new BrokenRuleException(new UtilityMappingDriverExistsRule(utilityAccount),
        //                                                        string.Format(
        //                                                            "Determinant [TariffCode] has been mapped from raw scraper data: {0}",
        //                                                            utilityAccount.TariffCode)));
        //                        }
        //                    }
        //                }
        //                else
        //                {
        //                    rule.Exception.DependentExceptions.Add(
        //                                    new BrokenRuleException(new UtilityMappingDriverExistsRule(utilityAccount),
        //                                                            string.Format(
        //                                                                "Determinant [TariffCode] has data: {0}",
        //                                                                utilityAccount.TariffCode)));
        //                }

        //                if( string.IsNullOrEmpty(utilityAccount.TariffCode) )
        //                {
        //                    rule.Exception.DependentExceptions.Add(new BrokenRuleException(new UtilityMappingDriverExistsRule(utilityAccount), String.Format("Utility mapping driver [Tariff Code ID] is missing for account number: {0} utility: {1}, and is not in raw data", accountNumber, utilityCode), BrokenRuleSeverity.Error));
        //                }

        //                break;
        //            }
        //    }
        //}
        #endregion

        public static FileAccountList GetFileAccountList( WebAccountList webAccounts )
        {
            FileAccountList fileAccounts = new FileAccountList();

            foreach( WebAccount webAccount in webAccounts )
            {
                if( webAccount.GetType().IsSubclassOf( typeof( FileAccount ) ) )
                {
                    fileAccounts.Add( (FileAccount) webAccount );
                }
            }
            return fileAccounts;
        }

        #region obsolete
        //private static bool WebAccountDataExists( WebAccountList webAccounts )
        //{
        //    return webAccounts != null && webAccounts.Count > 0;
        //}

        //private static bool FileAccountDataExists( FileAccountList fileAccounts )
        //{
        //    return fileAccounts != null && fileAccounts.Count > 0;
        //}
        #endregion
    }
}

namespace FrameworkTest
{
    using System;
    using System.IO;
    using System.Text;
    using System.Data;
    using System.Data.SqlClient;
    using System.Collections;
    using System.Linq;
    using System.Collections.Generic;
    using LibertyPower.Business.MarketManagement.UsageManagement;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using LibertyPower.Business.MarketManagement.UtilityManagement;
    using LibertyPower.Business.CommonBusiness.FileManager;
    using LibertyPower.Business.MarketManagement.MarketParsing;
    using LibertyPower.Business.CommonBusiness.TimeSeries;
    using LibertyPower.Business.CommonBusiness.CommonShared;
    using LibertyPower.Business.CustomerAcquisition.RateManagement;
    using System.Diagnostics;
    
    [TestClass()]
    public class ErcotParserTests
    {
        private string sampleRoot = @"D:\TFS\Portfolio\Framework\LPDev\Test\Sample Files\";
        private string[] sampleFiles =
            {
                @"TX\AEPUsage.XLS",
                @"TX\HU CTPEN.xls",
                @"TX\HU ONCOR 4-10 2.xls",
                @"TX\HU Verizon Wireless TNMP Historical Usage.xls",
                @"TX\TXNMP Verizon.xls",
                @"CA\Auto Auction - electric_07252011.XLS",
                @"CA\Auto Auction 2 - electric_07272011.XLS",
                @"CA\Darden Restaurants - electric_10122011.XLS",
                @"CA\SDGE.xls"
            };

        [TestMethod]
        public void FileTypeIdTest()
        {
            var count = sampleFiles.Length;
            var succeeded = 0;
            foreach (var filename in sampleFiles)
            {
                string path = sampleRoot + filename;
                
                var fileManager = FileManagerFactory.GetFileManager("Test", "Integration Test Support", @"C:\Test\", 0);
                var fileContext = fileManager.AddFile(path, false, 0);
                var parserFileType = UsageFileParserFactory.DetermineParserFileType(fileContext);
                if(parserFileType == ParserFileType.Unknown)
                {
                    Assert.Fail();
                }
                succeeded++;

            }
        }
        
        [TestMethod]
        public void ParseAccountsAndUsageTest()
        {
            var count = sampleFiles.Length;
            var succeeded = 0;
            var success = false;
            foreach (var filename in sampleFiles)
            {
                success = true;
                var path = sampleRoot + filename;

                var fileManager = FileManagerFactory.GetFileManager("Test", "Integration Test Support", @"C:\Test\", 0);
                var fileContext = fileManager.AddFile(path, false, 0);
                var parserFileType = UsageFileParserFactory.DetermineParserFileType(fileContext);

                if (parserFileType != ParserFileType.Unknown)
                {
                    var parserResult = UsageFileParserFactory.GetParserResult(fileContext);
                    if(parserResult!=null || parserResult.UtilityAccounts == null || parserResult.UtilityAccounts.Count < 1)
                    {
                        foreach(UtilityAccount acct in parserResult.UtilityAccounts)
                        {
                            if (acct.Usages == null || acct.Usages.Count < 1)
                                success = false;
                        }
                    }
                    else
                    {
                        success = false;
                    }
                }
                if(success)
                    succeeded++;

            }
        }
        [TestMethod]
        public void TestUtilityClassMapping()
        {
            var count = sampleFiles.Length;
            var succeeded = 0;
            var success = false;
            foreach (var filename in sampleFiles)
            {
                success = true;
                var path = sampleRoot + filename;

                var fileManager = FileManagerFactory.GetFileManager("Test", "Integration Test Support", @"C:\Test\", 0);
                var fileContext = fileManager.AddFile(path, false, 0);
                var parserFileType = UsageFileParserFactory.DetermineParserFileType(fileContext);

                if (parserFileType != ParserFileType.Unknown)
                {
                    var parserResult = UsageFileParserFactory.GetParserResult(fileContext);
                    if (parserResult != null || parserResult.UtilityAccounts == null || parserResult.UtilityAccounts.Count < 1)
                    {
                        foreach (UtilityAccount acct in parserResult.UtilityAccounts)
                        {
                            //UtilityAccount acctDemoted = new UtilityAccount(acct.AccountNumber);
                            //acctDemoted = LibertyPower.Business.CommonBusiness.CommonShared.ObjectDemotion<ProspectAccountCandidate, UtilityAccount>.Demote((ProspectAccountCandidate)acct, acctDemoted);
                            //UtilityMapping map = UtilityMappingFactory.GetUtilityMapping(acctDemoted.UtilityCode);
                            //acctDemoted.UtilityMapping = map;
                            //UtilityAccount acctMapped = UtilityMappingFactory.MapUtilityClassData(acctDemoted);
                            //if (acctMapped == null)
                            //    success = false;
                        }
                    }
                    else
                    {
                        success = false;
                    }
                }
                if (success)
                    succeeded++;

            }
        }

    }
}

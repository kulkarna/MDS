using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using LibertyPower.Business.MarketManagement.IdrUsageManagement;
using LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers;
using LibertyPower.Business.MarketManagement.IdrUsageManagement.Readers;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace IdrUsageTests.Parsers
{
	[TestClass]
	public class PSegMultipleParserTestFixture
	{
        [TestMethod]
        public void CanParse()
        {
            //Arrange
            var zipStream = Assembly.GetExecutingAssembly().GetManifestResourceStream("IdrUsageTests.Resources.Parsers.PSegMultiple.PSEG.zip");
            var unzipedStreams = ZipFileManager.Unzip(zipStream);
            var parser = new PSegMultipleParser();
            var accounts = new Dictionary<string, string> { { "PE036209598455565656", "PE036209598455565656" } };

            foreach (var stream in unzipedStreams)
            {
                var reader = RawParserService.GetReaderForFile(stream.Key, stream.Value);
                var result = parser.Process(reader, accounts).First();

                //Assert
                Assert.IsTrue(15 == result.Interval || 30 == result.Interval);
                Assert.AreEqual("PE036209598455565656", result.Account);
                Assert.AreEqual("PSEG", result.UtilityCode);
                Assert.IsTrue(result.Data.Count > 0);
                var entries = new List<IdrDataEntry>(result.Data);
                Assert.IsTrue(entries.TrueForAll(e => e.Values.Count == 48 || e.Values.Count == 96));
            }
        }
    }
}

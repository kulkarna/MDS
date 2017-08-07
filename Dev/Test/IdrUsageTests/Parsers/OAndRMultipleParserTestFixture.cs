using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers;
using LibertyPower.Business.MarketManagement.IdrUsageManagement.Readers;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace IdrUsageTests.Parsers
{
	[TestClass]
	public class OAndRMultipleParserTestFixture
	{
        [TestMethod]
        public void CanParse()
        {
            //Arrange
            var zipStream = Assembly.GetExecutingAssembly().GetManifestResourceStream("IdrUsageTests.Resources.Parsers.OAndR.O_and_R_IDR.zip");
            var unzipedStreams = ZipFileManager.Unzip(zipStream);
            var parser = new NyOAndRMultipleParser();

            foreach (var stream in unzipedStreams)
            {
                var reader = RawParserService.GetReaderForFile(stream.Key, stream.Value);
                var accountNumbers = new Dictionary<string, string>();
                var result = parser.Process(reader, accountNumbers).First();
                //Assert
                Assert.IsNotNull(result);
                Assert.AreEqual("2355079008", result.Account);
                Assert.AreEqual("O&R", result.UtilityCode);
                Assert.AreEqual(60, result.Interval);

                Assert.IsTrue(result.Data.Count > 0);
            }
        }

        [TestMethod]
        public void CanParseOrnj()
        {
            //Arrange
            var zipStream = Assembly.GetExecutingAssembly().GetManifestResourceStream("IdrUsageTests.Resources.Parsers.OAndR.ORNJ_All_IDR.zip");
            var unzipedStreams = ZipFileManager.Unzip(zipStream);
            var parser = new OrnjMultipleParser();

            foreach (var stream in unzipedStreams)
            {
                var reader = RawParserService.GetReaderForFile(stream.Key, stream.Value);
                var accountNumbers = new Dictionary<string, string>();
                var result = parser.Process(reader, accountNumbers).First();
                //Assert
                Assert.IsNotNull(result);
                Assert.AreEqual("5043959025", result.Account);
                Assert.AreEqual("ORNJ", result.UtilityCode);
                Assert.AreEqual(60, result.Interval);
                Assert.IsTrue(result.Data.Count > 0);
            }
        }
    }
}

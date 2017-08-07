using System;
using System.Reflection;
using System.Collections.Generic;
using System.Linq;
using LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace IdrUsageTests.Parsers
{
	[TestClass]
	public class NyRgeSingleParserTestFixture
	{
        [TestMethod]
        public void ParseSingleFile()
        {
            //Arrange
            var data = Assembly.GetExecutingAssembly().GetManifestResourceStream("IdrUsageTests.Resources.Parsers.NyRgeSingle.RGE_HomeDepot_R01000057502346_2.xls");

            //Parser cannot read account from file.
            var parser = new NyRgeSingleParser();
            var accounts = new Dictionary<string, string> { { "R01000057502346", "R01000057502346" } };

            //Act
            var reader = RawParserService.GetReaderForFile("RGE_HomeDepot_R01000057502346_2.xls", data);
            var result = parser.Process(reader, accounts).FirstOrDefault();

            //Assert
            Assert.IsNotNull(result);
            Assert.AreEqual("R01000057502346", result.Account);
            Assert.AreEqual("RGE", result.UtilityCode);
            Assert.AreEqual(60, result.Interval);
            Assert.AreEqual(732, result.Data.Count);

            Assert.IsTrue(result.Data.All(d => d.Values != null && d.Values.Count == 24));
            Assert.IsTrue(result.Data.All(d => d.Unit == "KW"));

            Assert.AreEqual(new DateTime(2008, 1, 11), result.Data[0].Date);
            Assert.AreEqual(new DateTime(2010, 1, 11), result.Data[731].Date);

            Assert.AreEqual(157M, result.Data[692].Values[5]);
            Assert.AreEqual(135M, result.Data[217].Values[23]);
            Assert.AreEqual(147M, result.Data[26].Values[0]);
            Assert.AreEqual(268M, result.Data[15].Values[15]);
            Assert.AreEqual(148M, result.Data[0].Values[2]);
        }
    }
}

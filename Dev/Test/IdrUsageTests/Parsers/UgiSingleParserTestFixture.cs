using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Reflection;
using LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers;

namespace IdrUsageTests.Parsers
{
    [TestClass]
    public class UgiSingleParserTestFixture
    {
        [TestMethod]
        public void ParseSingleFile()
        {
            //Arrange
            var data = Assembly.GetExecutingAssembly().GetManifestResourceStream("IdrUsageTests.Resources.Parsers.UgiSingle.UGI_HolyTrinity_604975117005.csv");

            var parser = new UgiSingleParser();

            //Act
            var reader = RawParserService.GetReaderForFile("UGI_HolyTrinity_604975117005.csv", data);
            var accountNumbers = new Dictionary<string, string>();
            var result = parser.Process(reader, accountNumbers).FirstOrDefault();

            //Assert
            Assert.IsNotNull(result);
            Assert.AreEqual("604975117005", result.Account);
            Assert.AreEqual("UGI", result.UtilityCode);
            Assert.AreEqual(60, result.Interval);

            Assert.IsTrue(result.Data.All(d => d.Values != null && d.Values.Count == 24));
            Assert.IsTrue(result.Data.All(d => d.Unit == "kWh"));
            Assert.AreEqual(539, result.Data.Count);

            Assert.AreEqual(new DateTime(2008, 5, 7), result.Data[0].Date);

            Assert.AreEqual(0.01M, result.Data.Single(d => d.Date == new DateTime(2008, 5, 20)).Values[5]);
            Assert.AreEqual(0M, result.Data.Single(d => d.Date == new DateTime(2009, 10, 27)).Values[23]);
        }
    }
}

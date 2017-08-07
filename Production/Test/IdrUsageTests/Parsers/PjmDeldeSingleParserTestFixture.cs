using System;
using System.Reflection;
using System.Collections.Generic;
using System.Linq;
using LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace IdrUsageTests.Parsers
{
	[TestClass]
    public class PjmDeldeSingleParserTestFixture
	{
        [TestMethod]
        public void ParseSingle60File()
        {
            //Arrange
            var data = Assembly.GetExecutingAssembly().GetManifestResourceStream("IdrUsageTests.Resources.Parsers.PjmDeldeSingle.DPL_223899299984_IDR_raw.csv");

	        var parser = new PjmDeldeSingle60Parser();

            //Act
            var reader = RawParserService.GetReaderForFile("DPL_223899299984_IDR_raw.csv", data);
            var accountNumbers = new Dictionary<string, string>();
            var result = parser.Process(reader, accountNumbers).FirstOrDefault();

            //Assert
            Assert.IsNotNull(result);
            Assert.AreEqual("223899299984", result.Account);
            Assert.AreEqual("DELDE", result.UtilityCode);
            Assert.AreEqual(60, result.Interval);

            Assert.IsTrue(result.Data.All(d => d.Values != null && d.Values.Count == 24));
            Assert.IsTrue(result.Data.All(d => d.Unit == "kWh" || d.Unit == "kVARh"));
            Assert.AreEqual(2280, result.Data.Count);
			
            Assert.AreEqual(new DateTime(2008, 10, 1), result.Data[0].Date);

            Assert.AreEqual(62.34M, result.Data.Single(d => d.Meter == "016736172 1" && d.Date == new DateTime(2008, 10, 1) && d.Unit == "kWh").Values[2]);
            Assert.AreEqual(67.86M, result.Data.Single(d => d.Meter == "016736172 1" && d.Date == new DateTime(2008, 11, 10) && d.Unit == "kWh").Values[23]);
            Assert.AreEqual(95.04M, result.Data.Single(d => d.Meter == "94219184 2" && d.Date == new DateTime(2009, 6, 26) && d.Unit == "kVARh").Values[10]);
            Assert.AreEqual(45.81M, result.Data.Single(d => d.Meter == "94219184 1" && d.Date == new DateTime(2009, 10, 15) && d.Unit == "kWh").Values[0]);
        }
    }
}

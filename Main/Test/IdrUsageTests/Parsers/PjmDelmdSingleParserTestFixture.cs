using System;
using System.Reflection;
using System.Collections.Generic;
using System.Linq;
using LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace IdrUsageTests.Parsers
{
	[TestClass]
    public class PjmDelmdSingleParserTestFixture
	{
        [TestMethod]
        public void ParseSingle60File()
        {
            //Arrange
            var data = Assembly.GetExecutingAssembly().GetManifestResourceStream("IdrUsageTests.Resources.Parsers.PjmDelmdSingle.conectiv_13913d58_1397e960_hourlycsv.csv");

	        var parser = new PjmDelmdSingle60Parser();

            //Act
            var reader = RawParserService.GetReaderForFile("conectiv_13913d58_1397e960_hourlycsv.csv", data);
            var accountNumbers = new Dictionary<string, string>();
            var result = parser.Process(reader, accountNumbers).FirstOrDefault();

            //Assert
            Assert.IsNotNull(result);
            Assert.AreEqual("210629299996", result.Account);
            Assert.AreEqual("DELMD", result.UtilityCode);
            Assert.AreEqual(60, result.Interval);

            Assert.IsTrue(result.Data.All(d => d.Values != null && d.Values.Count == 24));
            Assert.IsTrue(result.Data.All(d => d.Unit == "kWh" || d.Unit == "kVARh"));
            Assert.AreEqual(1574, result.Data.Count);
			
            Assert.AreEqual(new DateTime(2010, 8, 1), result.Data[0].Date);

            Assert.AreEqual(358.92M, result.Data.Single(d => d.Meter == "82924069 1" && d.Date == new DateTime(2010, 8, 1) && d.Unit == "kWh").Values[2]);
            Assert.IsNull(result.Data.Single(d => d.Meter == "82924069 1" && d.Date == new DateTime(2011, 8, 23) && d.Unit == "kWh").Values[23]);
            Assert.AreEqual(134.40M, result.Data.Single(d => d.Meter == "82924069 2" && d.Date == new DateTime(2012, 2, 12) && d.Unit == "kVARh").Values[10]);
            Assert.AreEqual(111.60M, result.Data.Single(d => d.Meter == "82924069 2" && d.Date == new DateTime(2012, 9, 25) && d.Unit == "kVARh").Values[0]);
        }
    }
}

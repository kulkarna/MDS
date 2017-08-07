using System;
using System.Collections.Generic;
using System.Reflection;
using System.Linq;
using LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace IdrUsageTests.Parsers
{
	[TestClass]
	public class PjmAceSingleParserTestFixture
	{
        [TestMethod]
        public void ParseSingle60File()
        {
            //Arrange
            var data = Assembly.GetExecutingAssembly().GetManifestResourceStream("IdrUsageTests.Resources.Parsers.PjmAceSingle.ACE_IDR_hourly.csv");

	        var parser = new PjmAceSingle60Parser();

            //Act
            var reader = RawParserService.GetReaderForFile("ACE_IDR_hourly.csv", data);
            var accountNumbers = new Dictionary<string, string>();
            var result = parser.Process(reader, accountNumbers).FirstOrDefault();

            //Assert
            Assert.IsNotNull(result);
            Assert.AreEqual("352321099991", result.Account);
            Assert.AreEqual("ACE", result.UtilityCode);
            Assert.AreEqual(60, result.Interval);

            Assert.IsTrue(result.Data.All(d => d.Values != null && d.Values.Count == 24));
            Assert.IsTrue(result.Data.All(d => d.Unit == "kWh" || d.Unit == "kVARh"));
            Assert.AreEqual(1460, result.Data.Count);
			
            Assert.AreEqual(new DateTime(2009, 7, 1), result.Data[0].Date);

            Assert.AreEqual(726.12M, result.Data.Single(d => d.Meter == "86422464A 1" && d.Date == new DateTime(2009, 7, 1) && d.Unit == "kWh").Values[2]);
            Assert.AreEqual(179.82M, result.Data.Single(d => d.Meter == "86422464A 1" && d.Date == new DateTime(2009, 10, 1) && d.Unit == "kWh").Values[23]);
            Assert.AreEqual(457.02M, result.Data.Single(d => d.Meter == "86422464A 1" && d.Date == new DateTime(2010, 2, 4) && d.Unit == "kWh").Values[10]);
            Assert.AreEqual(625.68M, result.Data.Single(d => d.Meter == "86422464A 2" && d.Date == new DateTime(2010, 6, 30) && d.Unit == "kVARh").Values[0]);
        }

        [TestMethod]
        public void ParseSingle15File()
        {
            //Arrange
            var data = Assembly.GetExecutingAssembly().GetManifestResourceStream("IdrUsageTests.Resources.Parsers.PjmAceSingle.ACE_108489799990.csv");

            var parser = new PjmAceSingle15Parser();

            //Act
            var reader = RawParserService.GetReaderForFile("ACE_108489799990.csv", data);
            var accountNumbers = new Dictionary<string, string>();
            var result = parser.Process(reader, accountNumbers).FirstOrDefault();

            //Assert
            Assert.IsNotNull(result);
            Assert.AreEqual("108489799990", result.Account);
            Assert.AreEqual("ACE", result.UtilityCode);
            Assert.AreEqual(15, result.Interval);

            Assert.IsTrue(result.Data.All(d => d.Values != null && d.Values.Count == 96));
            Assert.IsTrue(result.Data.All(d => d.Unit == "kWh" || d.Unit == "kVARh"));
            Assert.AreEqual(7872, result.Data.Count);

            Assert.AreEqual(new DateTime(2009, 1, 1), result.Data[0].Date);

            Assert.AreEqual(6.345M, result.Data.Single(d => d.Meter == "96412943A 1" && d.Date == new DateTime(2009, 1, 1) && d.Unit == "kWh").Values[2]);
            Assert.AreEqual(9.9M, result.Data.Single(d => d.Meter == "96412947A 4" && d.Date == new DateTime(2009, 1, 1) && d.Unit == "kVARh").Values[95]);
            Assert.AreEqual(6.3M, result.Data.Single(d => d.Meter == "73890849A 3" && d.Date == new DateTime(2009, 11, 12) && d.Unit == "kWh").Values[10]);
            Assert.AreEqual(7.38M, result.Data.Single(d => d.Meter == "73890849A 4" && d.Date == new DateTime(2009, 11, 11) && d.Unit == "kVARh").Values[5]);
        }
    }
}

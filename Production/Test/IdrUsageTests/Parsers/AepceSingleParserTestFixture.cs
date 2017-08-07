using System;
using System.Collections.Generic;
using System.Reflection;
using System.Linq;
using LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace IdrUsageTests.Parsers
{
	[TestClass]
	public class AepceSingleParserTestFixture
	{
        [TestMethod]
        public void ParseSingleFile()
        {
            //Arrange
            var data = Assembly.GetExecutingAssembly().GetManifestResourceStream("IdrUsageTests.Resources.Parsers.AepceSingle.AEPCE.xls");

			var parser = new AepceSingleParser();
            var accountNumber = new Dictionary<string, string>();
            //Act
            var reader = RawParserService.GetReaderForFile("AEPCE.xls", data);
            var result = parser.Process(reader, accountNumber).FirstOrDefault();

            //Assert
            Assert.IsNotNull(result);
            Assert.AreEqual("10032789448305680", result.Account);
            Assert.AreEqual("AEPCE", result.UtilityCode);
            Assert.AreEqual(15, result.Interval);

            Assert.IsTrue(result.Data.All(d => d.Values != null && d.Values.Count == 96));
			Assert.IsTrue( result.Data.All( d => d.Unit == "kWh" ) );
            Assert.AreEqual(new DateTime(2008, 10, 6), result.Data[0].Date);
            Assert.AreEqual(87.17M, result.Data[0].Values[5]);
        }
	}
}

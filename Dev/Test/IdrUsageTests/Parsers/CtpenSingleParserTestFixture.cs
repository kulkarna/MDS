using System;
using System.Collections.Generic;
using System.Reflection;
using System.Linq;
using LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace IdrUsageTests.Parsers
{
	[TestClass]
	public class CtpenSingleParserTestFixture
	{
        [TestMethod]
        public void ParseSingleFile()
        {
            //Arrange
            var data = Assembly.GetExecutingAssembly().GetManifestResourceStream("IdrUsageTests.Resources.Parsers.CtpenSingle.CTPEN.xls");

			var parser = new CtpenSingleParser();
            var accountNumbers = new Dictionary<string, string>();

            //Act
            var reader = RawParserService.GetReaderForFile("CTPEN.xls", data);
            var result = parser.Process(reader, accountNumbers);

            var idrData = result.First();

            //Assert
            Assert.IsNotNull(result);
            Assert.AreEqual("1008901000141890012100", idrData.Account);
            Assert.AreEqual("CTPEN", idrData.UtilityCode);
            Assert.AreEqual(15, idrData.Interval);

            Assert.IsTrue(idrData.Data.All(d => d.Values != null && d.Values.Count == 96));
            Assert.IsTrue(idrData.Data.All(d => d.Unit == "kW"));
            Assert.AreEqual(new DateTime(2007, 11, 30), idrData.Data[0].Date);
            Assert.AreEqual(421M, idrData.Data[0].Values[5]);
        }
	}
}

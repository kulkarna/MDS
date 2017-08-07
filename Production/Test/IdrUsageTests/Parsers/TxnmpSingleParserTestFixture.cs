using System;
using System.Collections.Generic;
using System.Reflection;
using System.Linq;
using LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace IdrUsageTests.Parsers
{
	[TestClass]
	public class TxnmpSingleParserTestFixture
	{
        [TestMethod]
        public void ParseSingleFile()
        {
            //Arrange
            var data = Assembly.GetExecutingAssembly().GetManifestResourceStream("IdrUsageTests.Resources.Parsers.TxnmpSingle.TXNMP.xls");

			var parser = new TxnmpSingleParser();

            //Act
            var reader = RawParserService.GetReaderForFile("TXNMP.xls", data);
            var accountNumbers = new Dictionary<string, string>();
            var result = parser.Process(reader, accountNumbers);

            var idrData = result.First();

            //Assert
            Assert.IsNotNull(result);
            Assert.AreEqual("10400511936620001", idrData.Account);
            Assert.AreEqual("TXNMP", idrData.UtilityCode);
            Assert.AreEqual(15, idrData.Interval);

            Assert.IsTrue(idrData.Data.All(d => d.Values != null && d.Values.Count == 96));
            Assert.IsTrue(idrData.Data.All(d => d.Unit == "kWh"));
            Assert.AreEqual(new DateTime(2009, 6, 29), idrData.Data[0].Date);
            Assert.AreEqual(8248.8M, idrData.Data[0].Values[60]);
            Assert.AreEqual(8260M, idrData.Data[0].Values[95]);
        }
	}
}

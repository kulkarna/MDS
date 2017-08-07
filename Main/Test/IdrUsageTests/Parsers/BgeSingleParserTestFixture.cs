using System;
using System.Collections.Generic;
using System.Reflection;
using System.Linq;
using LibertyPower.Business.MarketManagement.IdrUsageManagement;
using LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace IdrUsageTests.Parsers
{
	[TestClass]
	public class BgeSingleParserTestFixture
	{
        [TestMethod]
        public void ParseSingleFile()
        {
            //Arrange
            var data = Assembly.GetExecutingAssembly().GetManifestResourceStream("IdrUsageTests.Resources.Parsers.BgeSingle.BGE_6214512013_IDR.csv");
            const string account = "6214512013";
			var parser = new BgeSingleParser();
            var accountNumber = new Dictionary<string, string>();

            //Act
            var reader = RawParserService.GetReaderForFile("BGE_6214512013_IDR.csv", data);
            var result = parser.Process(reader, accountNumber);

            //Assert
            Assert.IsNotNull(result);
            var idrRawDatas = result as IList<IdrRawData> ?? result.ToList();
            Assert.AreEqual(idrRawDatas.Count(), 1);
            Assert.AreEqual(new DateTime(2008, 1, 6), idrRawDatas.ToList()[0].Data[5].Date);
            Assert.AreEqual(308.4M, idrRawDatas[0].Data[0].Values[5]);

            foreach (var idrRawData in idrRawDatas)
            {
                Assert.AreEqual(15, idrRawData.Interval);
                Assert.AreEqual("BGE", idrRawData.UtilityCode);
                Assert.AreEqual(account, idrRawData.Account);
                Assert.IsTrue(idrRawData.Data.All(d => d.Values != null && d.Values.Count == 96));
                Assert.IsTrue(idrRawData.Data.All(d => d.Unit == "kWh"));
            }
        }
	}
}

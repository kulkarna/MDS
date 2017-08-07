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
	public class SdgeSingleParserTestFixture
	{
        [TestMethod]
        public void ParseSingleFile()
        {
            //Arrange
            var data = Assembly.GetExecutingAssembly().GetManifestResourceStream("IdrUsageTests.Resources.Parsers.SdgeSingle.SDGE.xls");
            var accounts = new List<string> {"3047853791", "6523408304", "6757721221", "948726029"};
            accounts.Sort();
			var parser = new SdgeSingleParser();

            //Act
            var reader = RawParserService.GetReaderForFile("SDGE.xls", data);
            var accountNumbers = new Dictionary<string, string>();
            var result = parser.Process(reader, accountNumbers);

            //Assert
            Assert.IsNotNull(result);
            var idrRawDatas = result as IEnumerable<IdrRawData> ?? result.ToList();
            var rawDatas = idrRawDatas as IdrRawData[] ?? idrRawDatas.ToArray();
            Assert.AreEqual(rawDatas.Count(), 4);
            Assert.AreEqual(new DateTime(2010, 5, 6), rawDatas[0].Data[5].Date);
            Assert.AreEqual(2.88M, rawDatas[0].Data[5].Values[10]);
            var i = 0;
            foreach (var idrRawData in rawDatas)
            {
                Assert.AreEqual(15, idrRawData.Interval);
                Assert.AreEqual("SDGE", idrRawData.UtilityCode);
                Assert.AreEqual(accounts[i], idrRawData.Account);
                Assert.IsTrue(idrRawData.Data.All(d => d.Values != null && d.Values.Count == 96));
                Assert.IsTrue(idrRawData.Data.All(d => d.Unit == "kWh"));
                i++;
            }
        }
	}
}

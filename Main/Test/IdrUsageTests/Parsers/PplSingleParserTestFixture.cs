using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Reflection;
using LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers;

namespace IdrUsageTests.Parsers
{
    [TestClass]
    public class PplSingleParserTestFixture
    {
        [TestMethod]
        public void ParseSingle60File()
        {
            //Arrange
            var data = Assembly.GetExecutingAssembly().GetManifestResourceStream("IdrUsageTests.Resources.Parsers.PplSingle.PPL_GP_LIBERTYCE_4GROUP_2010_06_03_H_HIU_data.csv");

            var parser = new PplSingleParser();

            var accounts = new List<string> { "2903720009", "5988070001", "6230128011", "8129070004" };

            //Act
            var reader = RawParserService.GetReaderForFile("PPL_GP_LIBERTYCE_4GROUP_2010_06_03_H_HIU_data.csv", data);
            var accountNumbers = new Dictionary<string, string>();
            var results = parser.Process(reader, accountNumbers);

            //Assert
            Assert.AreEqual(accounts.Count, results.Count());

            var i = 0;
            foreach (var result in results)
            {
                Assert.IsNotNull(result);
                Assert.AreEqual(accounts[i++], result.Account);
                Assert.AreEqual("PPL", result.UtilityCode);
                Assert.AreEqual(60, result.Interval);
                Assert.IsTrue(result.Data.All(d => d.Values != null && d.Values.Count == 24));
                Assert.IsTrue(result.Data.All(d => d.Unit == "kWh"));
                Assert.AreEqual(366, result.Data.Count);
            }

            Assert.AreEqual(316.215M, results.Single(r => r.Account == "2903720009").Data.Single(d => d.Date == new DateTime(2009, 7, 10)).Values[1]);
            Assert.AreEqual(225.9M, results.Single(r => r.Account == "2903720009").Data.Single(d => d.Date == new DateTime(2009, 11, 1)).Values[1]);
            Assert.AreEqual(236.61M, results.Single(r => r.Account == "2903720009").Data.Single(d => d.Date == new DateTime(2009, 11, 1)).Values[23]);
        }
    }
}

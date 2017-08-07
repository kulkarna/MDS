using System;
using System.Collections.Generic;
using System.Reflection;
using System.Linq;
using LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace IdrUsageTests.Parsers
{
	[TestClass]
	public class NySegSingleParserTestFixture
	{
        [TestMethod]
        public void ParseSingleFile()
        {
            //Arrange
            var data = Assembly.GetExecutingAssembly().GetManifestResourceStream("IdrUsageTests.Resources.Parsers.NySegSingle.NYSEG_berry_n01000020729638_073109_073111.xls");

			//Parser cannot read account from file.
			var parser = new NySegSingleParser();

            //Act
            var reader = RawParserService.GetReaderForFile("NYSEG_berry_n01000020729638_073109_073111.xls", data);
            var accountNumbers = new Dictionary<string, string>();
            var result = parser.Process(reader, accountNumbers).FirstOrDefault();

            //Assert
            Assert.IsNotNull(result);
            Assert.AreEqual("N01000020729638", result.Account);
            Assert.AreEqual("NYSEG", result.UtilityCode);
            Assert.AreEqual(60, result.Interval);
            Assert.AreEqual(731, result.Data.Count);

            Assert.IsTrue(result.Data.All(d => d.Values != null && d.Values.Count == 24));

            Assert.AreEqual(new DateTime(2009, 7, 31), result.Data[0].Date);
        }
    }
}

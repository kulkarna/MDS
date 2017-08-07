using System;
using System.Collections.Generic;
using System.Reflection;
using System.Linq;
using LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace IdrUsageTests.Parsers
{
	[TestClass]
	public class SceSingleParserTestFixture
	{
        [TestMethod]
        public void ParseSingleFile()
        {
            //Arrange
            var data = Assembly.GetExecutingAssembly().GetManifestResourceStream("IdrUsageTests.Resources.Parsers.SceSingle.SCE.xls");

			var parser = new SceSingleParser();

            //Act
            var reader = RawParserService.GetReaderForFile("SCE.xls", data);
            var accountNumbers = new Dictionary<string, string>();
            var result = parser.Process(reader, accountNumbers).FirstOrDefault();

            //Assert
            Assert.IsNotNull(result);
            Assert.AreEqual("3000633525", result.Account);
            Assert.AreEqual("SCE", result.UtilityCode);
            Assert.IsTrue(result.Data.All(d => d.Values != null && d.Values.Count == 96));
            Assert.AreEqual(15, result.Interval);

			Assert.IsTrue( result.Data.All( d => d.Unit == "KW" ) );
            Assert.AreEqual(new DateTime(2009, 6, 1), result.Data[0].Date);
            Assert.AreEqual(194M, result.Data[40].Values[10]);
            Assert.AreEqual(new DateTime(2010, 6, 26), result.Data[390].Date);
            Assert.AreEqual(180M, result.Data[375].Values[20]);
        }
	}
}

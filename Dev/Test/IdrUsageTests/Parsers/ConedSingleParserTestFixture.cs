using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace IdrUsageTests.Parsers
{
    [TestClass]
    public class ConedSingleParserTestFixture
    {
        [TestMethod]
        public void CanParse()
        {
            //Arrange
            var stream = Assembly.GetExecutingAssembly().GetManifestResourceStream("IdrUsageTests.Resources.Parsers.ConedSingle.CONED.xls");
            var parser = new ConedSingleParser();
            var accountNumbers = new Dictionary<string, string>();

            //Act
            var reader = RawParserService.GetReaderForFile("CONED.xls", stream);
            var result = parser.Process(reader, accountNumbers).First();

            //Assert
            Assert.IsNotNull(result);
            Assert.AreEqual("494121207500015", result.Account);
            Assert.AreEqual("CONED", result.UtilityCode);
            Assert.AreEqual(60, result.Interval);
            Assert.IsTrue(result.Data.Count > 0);
            Assert.IsTrue(result.Data.All(d => d.Values != null && d.Values.Count == 24));
            Assert.AreEqual(new DateTime(2009, 01, 20), result.Data[0].Date);
            Assert.IsNull(result.Data[0].Values[11]);
            Assert.AreEqual(result.Data[30].Values[0], 3370M);
        }

        [TestMethod]
        public void CanParseWithDataStartingInDifferentPosition()
        {
            //Arrange
            var stream = Assembly.GetExecutingAssembly().GetManifestResourceStream("IdrUsageTests.Resources.Parsers.ConedSingle.494121108600005_IDR_Utility.xlsx");
            var parser = new ConedSingleParser();
            var accountNumbers = new Dictionary<string, string>();

            //Act
            var reader = RawParserService.GetReaderForFile("494121108600005_IDR_Utility.xlsx", stream);
            var result = parser.Process(reader, accountNumbers).First();

            //Assert
            Assert.IsNotNull(result);
            Assert.AreEqual("494121108600005", result.Account);
            Assert.AreEqual("CONED", result.UtilityCode);
            Assert.AreEqual(60, result.Interval);
            Assert.IsTrue(result.Data.Count == 365);
            Assert.IsTrue(result.Data.All(d => d.Values != null && d.Values.Count == 24));
            Assert.AreEqual(new DateTime(2012, 01, 19), result.Data[0].Date);
            Assert.IsNull(result.Data[0].Values[11]);
            Assert.AreEqual(result.Data[10].Values[10], 1731.60M);
        }
    }
}

using System;
using System.Collections.Generic;
using System.Reflection;
using System.Linq;
using LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace IdrUsageTests.Parsers
{
	[TestClass]
	public class NyCenhudSingleParserTestFixture
	{
        [TestMethod]
        public void ParseSingleFile()
        {
            //Arrange
            var data = Assembly.GetExecutingAssembly().GetManifestResourceStream("IdrUsageTests.Resources.Parsers.NyCenhudSingle.Cenhud_Test_File.xlsx");

            var parser = new NyCenhudSingleParser();

            //Act
            var reader = RawParserService.GetReaderForFile("Cenhud_Test_File.xlsx", data);
            var accountNumbers = new Dictionary<string, string>();
            var result = parser.Process(reader, accountNumbers).FirstOrDefault();

            //Assert
            Assert.IsNotNull(result);
            Assert.AreEqual("5119854000", result.Account);
            Assert.AreEqual("CENHUD", result.UtilityCode);
            Assert.AreEqual(60, result.Interval);

            Assert.IsTrue(result.Data.All(d => d.Values != null && d.Values.Count == 24));

            Assert.AreEqual(1795.92M, result.Data.First(d => d.Unit == "kWh" && d.Date == new DateTime(2011, 11, 23)).Values[10]);
            Assert.AreEqual(1799.28M, result.Data.First(d => d.Unit == "kW" && d.Date == new DateTime(2011, 11, 23)).Values[10]);

            Assert.AreEqual(1487.22M, result.Data.First(d => d.Unit == "kWh" && d.Date == new DateTime(2012, 11, 15)).Values[23]);
            Assert.AreEqual(1498.56M, result.Data.First(d => d.Unit == "kW" && d.Date == new DateTime(2012, 11, 15)).Values[23]);
        }

        [TestMethod]
        public void ParseSingleFileColumnsReordered()
        {
            //Arrange
            var data = Assembly.GetExecutingAssembly().GetManifestResourceStream("IdrUsageTests.Resources.Parsers.NyCenhudSingle.Cenhud_Test_File_1.xlsx");

            var parser = new NyCenhudSingleParser();

            //Act
            var reader = RawParserService.GetReaderForFile("Cenhud_Test_File_1.xlsx", data);
            var accountNumbers = new Dictionary<string, string>();
            var result = parser.Process(reader, accountNumbers).FirstOrDefault();

            //Assert
            Assert.IsNotNull(result);
            Assert.AreEqual("5119854000", result.Account);
            Assert.AreEqual("CENHUD", result.UtilityCode);
            Assert.AreEqual(60, result.Interval);

            Assert.IsTrue(result.Data.All(d => d.Values != null && d.Values.Count == 24));

            Assert.AreEqual(1795.92M, result.Data.First(d => d.Unit == "kWh" && d.Date == new DateTime(2011, 11, 23)).Values[10]);
            Assert.AreEqual(1799.28M, result.Data.First(d => d.Unit == "kW" && d.Date == new DateTime(2011, 11, 23)).Values[10]);

            Assert.AreEqual(1487.22M, result.Data.First(d => d.Unit == "kWh" && d.Date == new DateTime(2012, 11, 15)).Values[23]);
            Assert.AreEqual(1498.56M, result.Data.First(d => d.Unit == "kW" && d.Date == new DateTime(2012, 11, 15)).Values[23]);
        }

        [TestMethod]
        public void ParseSingleFilekWhOnly()
        {
            //Arrange
            var data = Assembly.GetExecutingAssembly().GetManifestResourceStream("IdrUsageTests.Resources.Parsers.NyCenhudSingle.Cenhud_Test_File_2.xlsx");

            var parser = new NyCenhudSingleParser();

            //Act
            var reader = RawParserService.GetReaderForFile("Cenhud_Test_File_2.xlsx", data);
            var accountNumbers = new Dictionary<string, string>();
            var result = parser.Process(reader, accountNumbers).FirstOrDefault();

            //Assert
            Assert.IsNotNull(result);
            Assert.AreEqual("5119854000", result.Account);
            Assert.AreEqual("CENHUD", result.UtilityCode);
            Assert.AreEqual(60, result.Interval);

            Assert.IsTrue(result.Data.All(d => d.Values != null && d.Values.Count == 24));

            Assert.AreEqual(1795.92M, result.Data.First(d => d.Unit == "kWh" && d.Date == new DateTime(2011, 11, 23)).Values[10]);

            Assert.AreEqual(1487.22M, result.Data.First(d => d.Unit == "kWh" && d.Date == new DateTime(2012, 11, 15)).Values[23]);
        }

        [TestMethod]
        public void ParseSingleFilekWOnly()
        {
            //Arrange
            var data = Assembly.GetExecutingAssembly().GetManifestResourceStream("IdrUsageTests.Resources.Parsers.NyCenhudSingle.Cenhud_Test_File_3.xlsx");

            var parser = new NyCenhudSingleParser();

            //Act
            var reader = RawParserService.GetReaderForFile("Cenhud_Test_File_3.xlsx", data);
            var accountNumbers = new Dictionary<string, string>();
            var result = parser.Process(reader, accountNumbers).FirstOrDefault();

            //Assert
            Assert.IsNotNull(result);
            Assert.AreEqual("5119854000", result.Account);
            Assert.AreEqual("CENHUD", result.UtilityCode);
            Assert.AreEqual(60, result.Interval);

            Assert.IsTrue(result.Data.All(d => d.Values != null && d.Values.Count == 24));

            Assert.AreEqual(1799.28M, result.Data.First(d => d.Unit == "kW" && d.Date == new DateTime(2011, 11, 23)).Values[10]);

            Assert.AreEqual(1498.56M, result.Data.First(d => d.Unit == "kW" && d.Date == new DateTime(2012, 11, 15)).Values[23]);
        }
    }
}

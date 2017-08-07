using System;
using System.Collections.Generic;
using System.Reflection;
using System.Linq;
using LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace IdrUsageTests.Parsers
{
	[TestClass]
	public class CaisoPgeSingleParserTestFixture
	{
        [TestMethod]
        public void ParseSingleFile()
        {
            //Arrange
            var data = Assembly.GetExecutingAssembly().GetManifestResourceStream("IdrUsageTests.Resources.Parsers.CaisoPgeSingle.PGE_rld210637.csv");

            var parser = new CaisoPgeSingleParser();
            var accountNumbers = new Dictionary<string, string>();

            //Act
            var reader = RawParserService.GetReaderForFile("PGE_rld210637.csv", data);
            var result = parser.Process(reader, accountNumbers).FirstOrDefault();

            //Assert
            Assert.IsNotNull(result);
            Assert.AreEqual("3134318168", result.Account);
            Assert.AreEqual("PGE", result.UtilityCode);
            Assert.AreEqual(30, result.Interval);

            Assert.IsTrue(result.Data.All(d => d.Values != null && d.Values.Count == 48));
            Assert.IsTrue(result.Data.All(d => d.Unit == "KW" || d.Unit == "KVAR"));

            Assert.AreEqual(new DateTime(2009, 05, 20), result.Data[0].Date);
            Assert.AreEqual(10.9800M, result.Data[0].Values[5]);
        }

        [TestMethod]
        public void ParseSingleFileWithMddyyDateFormat()
        {
            //Arrange
            var data = Assembly.GetExecutingAssembly().GetManifestResourceStream("IdrUsageTests.Resources.Parsers.CaisoPgeSingle.PGE_rld210637_A_INPUT.csv");

            var parser = new CaisoPgeSingleParser();

            //Act
            var reader = RawParserService.GetReaderForFile("PGE_rld210637_A_INPUT.csv", data);
            var accountNumbers = new Dictionary<string, string>();
            var result = parser.Process(reader, accountNumbers);

            //Assert
            Assert.AreEqual(3, result.Count());

            Assert.IsNotNull(result.First());
            Assert.AreEqual("3134318168", result.First().Account);
            Assert.AreEqual("PGE", result.First().UtilityCode);
            Assert.AreEqual(30, result.First().Interval);

            Assert.IsTrue(result.First().Data.All(d => d.Values != null && d.Values.Count == 48));
            Assert.IsTrue(result.First().Data.All(d => d.Unit == "KW" || d.Unit == "KVAR"));

            Assert.AreEqual(new DateTime(2009, 05, 20), result.First().Data[0].Date);
            Assert.AreEqual(10.9800M, result.First().Data[0].Values[5]);

            Assert.IsNotNull(result.Skip(1).First());
            Assert.AreEqual("3590572495", result.Skip(1).First().Account);
            Assert.AreEqual("PGE", result.Skip(1).First().UtilityCode);
            Assert.AreEqual(30, result.Skip(1).First().Interval);

            Assert.IsTrue(result.Skip(1).First().Data.All(d => d.Values != null && d.Values.Count == 48));
            Assert.IsTrue(result.Skip(1).First().Data.All(d => d.Unit == "KW" || d.Unit == "KVAR"));

            Assert.IsNotNull(result.Skip(2).First());
            Assert.AreEqual("3760928493", result.Skip(2).First().Account);
            Assert.AreEqual("PGE", result.Skip(2).First().UtilityCode);
            Assert.AreEqual(30, result.Skip(2).First().Interval);

            Assert.IsTrue(result.Skip(2).First().Data.All(d => d.Values != null && d.Values.Count == 48));
            Assert.IsTrue(result.Skip(2).First().Data.All(d => d.Unit == "KW" || d.Unit == "KVAR"));
        }

        [TestMethod]
        public void ParseSingleFileInSecondFormat()
        {
            //Arrange
            var data = Assembly.GetExecutingAssembly().GetManifestResourceStream("IdrUsageTests.Resources.Parsers.CaisoPgeSingle.DATAACQ_A2RH_20121106_114342_RPT.csv");

            var accountNumbers = new Dictionary<string, string>();
            var parser = new CaisoPgeSingleParser1();

            //Act
            var reader = RawParserService.GetReaderForFile("DATAACQ_A2RH_20121106_114342_RPT.csv", data);

            var result = parser.Process(reader, accountNumbers).FirstOrDefault();

            //Assert
            Assert.IsNotNull(result);
            Assert.AreEqual("3920563325", result.Account);
            Assert.AreEqual("PGE", result.UtilityCode);
            Assert.AreEqual(30, result.Interval);

            Assert.IsTrue(result.Data.All(d => d.Values != null && d.Values.Count == 48));
            Assert.IsTrue(result.Data.All(d => d.Unit == "KW" || d.Unit == "KVAR"));

            Assert.AreEqual(new DateTime(2011, 1, 1), result.Data[0].Date);
            Assert.AreEqual(6594M, result.Data[0].Values[5]);
        }
    }
}

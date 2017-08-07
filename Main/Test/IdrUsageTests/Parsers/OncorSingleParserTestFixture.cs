using System;
using System.Collections.Generic;
using System.Reflection;
using System.Linq;
using LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace IdrUsageTests.Parsers
{
	[TestClass]
	public class OncorSingleParserTestFixture
	{
        [TestMethod]
        public void ParseSingleFile()
        {
            //Arrange
            var data = Assembly.GetExecutingAssembly().GetManifestResourceStream("IdrUsageTests.Resources.Parsers.OncorSingle.ONCOR_I6158871.txt");

			var parser = new OncorSingleParser();

            //Act
            var reader = RawParserService.GetReaderForFile("ONCOR_I6158871.txt", data);
            var accountNumbers = new Dictionary<string, string>();
            var result = parser.Process(reader, accountNumbers).FirstOrDefault();

            //Assert
            Assert.IsNotNull(result);
            Assert.AreEqual("10443720006158871", result.Account);
            Assert.AreEqual("ONCOR", result.UtilityCode);
            Assert.AreEqual(15, result.Interval);
            Assert.IsTrue(result.Data.All(d => d.Values != null && d.Values.Count == 96));
			Assert.IsTrue( result.Data.All( d => d.Unit == "kWh" ) );
            Assert.AreEqual(new DateTime(2003, 5, 5), result.Data[0].Date);
            Assert.AreEqual(161.28M, result.Data[0].Values[5]);
        }

        [TestMethod]
        public void ParseSingleFileTwoAccounts()
        {
            //Arrange
            var data = Assembly.GetExecutingAssembly().GetManifestResourceStream("IdrUsageTests.Resources.Parsers.OncorSingle.ONCOR_I6158871_2.txt");

            var parser = new OncorSingleParser();

            //Act
            var reader = RawParserService.GetReaderForFile("ONCOR_I6158871_2.txt", data);
            var accountNumbers = new Dictionary<string, string>();
            var result = parser.Process(reader, accountNumbers);

            //Assert
            Assert.IsNotNull(result);
            Assert.AreEqual(2, result.Count());

            Assert.AreEqual("10443720006158871", result.First().Account);
            Assert.AreEqual("ONCOR", result.First().UtilityCode);
            Assert.AreEqual(15, result.First().Interval);
            Assert.IsTrue(result.First().Data.All(d => d.Values != null && d.Values.Count == 96));
            Assert.IsTrue(result.First().Data.All(d => d.Unit == "kWh"));
            Assert.AreEqual(new DateTime(2003, 5, 5), result.First().Data[0].Date);
            Assert.AreEqual(161.28M, result.First().Data[0].Values[5]);

            Assert.AreEqual("10443720006158871", result.Skip(1).First().Account);
            Assert.AreEqual("ONCOR", result.Skip(1).First().UtilityCode);
            Assert.AreEqual(15, result.Skip(1).First().Interval);
            Assert.IsTrue(result.Skip(1).First().Data.All(d => d.Values != null && d.Values.Count == 96));
            Assert.IsTrue(result.Skip(1).First().Data.All(d => d.Unit == "kWh"));
            Assert.AreEqual(new DateTime(2003, 5, 5), result.Skip(1).First().Data[0].Date);
            Assert.AreEqual(161.28M, result.Skip(1).First().Data[0].Values[5]);

        }
	}
}

using System;
using System.Collections.Generic;
using System.Reflection;
using System.Linq;
using LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace IdrUsageTests.Parsers
{
	[TestClass]
	public class AmerenSingleParserTestFixture
	{
        [TestMethod]
        public void ParseSingleFile()
        {
            //Arrange
            var data = Assembly.GetExecutingAssembly().GetManifestResourceStream("IdrUsageTests.Resources.Parsers.AmerenSingle.AMEREN.csv");

			var parser = new AmerenSingleParser();
            var accountNumber = new Dictionary<string, string>();

            //Act
            var reader = RawParserService.GetReaderForFile("AMEREN.csv", data);
            var results = parser.Process(reader, accountNumber);
            var result = results.FirstOrDefault();

            //Assert
            Assert.IsNotNull(result);
            Assert.AreEqual("9015002613", result.Account);
            Assert.AreEqual("AMEREN", result.UtilityCode);
            Assert.AreEqual(60, result.Interval);

            Assert.IsTrue(result.Data.All(d => d.Values != null && d.Values.Count == 24));
			Assert.IsTrue( result.Data.All( d => d.Unit == "kW" ) );
            
            Assert.AreEqual(new DateTime(2011, 3, 9), result.Data[0].Date);
            Assert.AreEqual(107.73M, result.Data[0].Values[10]);
            Assert.AreEqual("90013813", result.Data[0].Meter);
			Assert.AreEqual( "11267945", result.Data[0].Recorder );

            Assert.AreEqual(new DateTime(2011, 3, 19), result.Data[20].Date);
            Assert.AreEqual(118.37M, result.Data[20].Values[10]);
			Assert.AreEqual( "90013813", result.Data[20].Meter );
			Assert.AreEqual( "11267945", result.Data[20].Recorder );
		}
	}
}

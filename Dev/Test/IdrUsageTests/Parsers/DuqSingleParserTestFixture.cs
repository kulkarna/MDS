using System;
using System.Collections.Generic;
using System.Reflection;
using System.Linq;
using LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace IdrUsageTests.Parsers
{
	[TestClass]
	public class DuqSingleParserTestFixture
	{
        [TestMethod]
        public void ParseSingleFile()
        {
            //Arrange
			var data = Assembly.GetExecutingAssembly().GetManifestResourceStream( "IdrUsageTests.Resources.Parsers.DuqSingle.DUQ_DESC_IDR_5000004601001.PRN" );

			var parser = new DuqSingleParser();
            var accounts = new Dictionary<string, string> {{"123456", "123456"}};

            //Act
            var reader = RawParserService.GetReaderForFile("DUQ_DESC_IDR_5000004601001.PRN", data);
            var result = parser.Process(reader, accounts).FirstOrDefault();

            //Assert
            Assert.IsNotNull(result);
			Assert.AreEqual( "123456", result.Account );
            Assert.AreEqual("DUQ", result.UtilityCode);
			Assert.AreEqual(60, result.Interval);

			Assert.IsTrue(result.Data.All(d => d.Values != null && d.Values.Count == 24));
			Assert.IsTrue( result.Data.All( d => d.Unit == "kW" ) );
			Assert.AreEqual(new DateTime(2009, 05, 30), result.Data[0].Date);
			Assert.AreEqual( 10714M, result.Data[0].Values[5] );
        }
	}
}

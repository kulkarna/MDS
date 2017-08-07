using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace IdrUsageTests.Parsers
{
	[TestClass]
	public class NepoolUnitilSingleParserTestFixture
	{
		[TestMethod]
		public void ParseNepoolUnitilSingleFile()
		{
			//Arrange
            var data = Assembly.GetExecutingAssembly().GetManifestResourceStream("IdrUsageTests.Resources.Parsers.NepoolUnitilSingle.UNITIL_Liberty_example.csv");

			var parser = new NepoolUnitilSingleParser();

			//Act
            var reader = RawParserService.GetReaderForFile("UNITIL_Liberty_example.csv", data);
            var accountNumbers = new Dictionary<string, string> {{"3YYYYYY", "3YYYYYY"}};
		    var result = parser.Process(reader, accountNumbers).FirstOrDefault();

			//Assert
			Assert.IsNotNull( result );
			Assert.AreEqual( "3YYYYYY", result.Account );
			Assert.AreEqual( "UNITIL", result.UtilityCode );
			Assert.AreEqual( 60, result.Interval );

            Assert.IsTrue(result.Data.All(d => d.Values != null && d.Values.Count == 24));
            Assert.IsTrue(result.Data.All(d => d.Unit == "kW" || d.Unit == "kVA"));
            Assert.AreEqual(new DateTime(2010, 7, 1), result.Data[0].Date);
            Assert.IsNull(result.Data[0].Meter);
            Assert.AreEqual(1980.7M, result.Data[0].Values[0]);
        }
	}
}

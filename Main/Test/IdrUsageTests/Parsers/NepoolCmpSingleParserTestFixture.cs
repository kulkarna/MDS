using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace IdrUsageTests.Parsers
{
	[TestClass]
	public class NepoolCmpSingleParserTestFixture
	{
		[TestMethod]
		public void ParseSingleFile()
		{
			//Arrange
            var data = Assembly.GetExecutingAssembly().GetManifestResourceStream("IdrUsageTests.Resources.Parsers.NepoolCmpSingle.CMP_05511029547012.xls");

			var parser = new NepoolCmpSingleParser();
            var accountNumbers = new Dictionary<string, string>();

			//Act
            var reader = RawParserService.GetReaderForFile("CMP_05511029547012.xls", data);
            var result = parser.Process(reader, accountNumbers).FirstOrDefault();

			//Assert
			Assert.IsNotNull( result );
            Assert.AreEqual("5511029547012", result.Account);
			Assert.AreEqual( "CMP", result.UtilityCode );
			Assert.AreEqual( 60, result.Interval );

            Assert.IsTrue(result.Data.All(d => d.Values != null && d.Values.Count == 24));
            Assert.IsTrue(result.Data.All(d => d.Unit == "KWH"));
            Assert.AreEqual(new DateTime(2008, 12, 1), result.Data[0].Date);
            Assert.AreEqual("I066300L", result.Data[0].Meter);
            Assert.AreEqual(1945M, result.Data[0].Values[23]);
		}
	}
}

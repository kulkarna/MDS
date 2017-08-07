using System;
using System.Reflection;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers;
using LibertyPower.Business.MarketManagement.IdrUsageManagement.Readers;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace IdrUsageTests.Parsers
{
	[TestClass]
	public class NyNimoSingleParserTestFixture
	{
        [TestMethod]
        public void ParseSingleFile()
        {
            //Arrange
			var data = Assembly.GetExecutingAssembly().GetManifestResourceStream( "IdrUsageTests.Resources.Parsers.NyNimoSingle.NIMO_00153idh154124_NIMO_8059953149_IDR.xlsx" );

			var parser = new NyNimoSingleParser ();

            //Act
            var reader = RawParserService.GetReaderForFile("NIMO_00153idh154124_NIMO_8059953149_IDR.xlsx", data);
            var accountNumbers = new Dictionary<string, string>();
            var result = parser.Process(reader, accountNumbers).FirstOrDefault();

            //Assert
            Assert.IsNotNull(result);
			Assert.AreEqual( "8059953149", result.Account );
            Assert.AreEqual("NIMO", result.UtilityCode);
            Assert.AreEqual(60, result.Interval);

            Assert.IsTrue(result.Data.All(d => d.Values != null && d.Values.Count == 24));
			Assert.IsTrue( result.Data.All( d => d.Unit == "kWh" ) );
			
            Assert.AreEqual(new DateTime(2008, 4, 4), result.Data[0].Date);
            Assert.AreEqual(new DateTime(2010, 3, 31), result.Data[726].Date);

			Assert.AreEqual( 446.14M, result.Data[692].Values[5] );
            Assert.AreEqual( 428.5M, result.Data[217].Values[23] );
            Assert.AreEqual( 457.48M, result.Data[26].Values[0] );
            Assert.AreEqual( 462.84M, result.Data[15].Values[15] );
			Assert.AreEqual( 467.98M, result.Data[0].Values[2] );
        }

/*
        [TestMethod]
        public void ParseFile0009171000()
        {
            //Arrange
            var data = Assembly.GetExecutingAssembly().GetManifestResourceStream("IdrUsageTests.Resources.Parsers.NyNimoSingle.NIMO_0009171000.xls");

            var parser = new NyNimoSingleParser();

            //Act
            var reader = RawParserService.GetReaderForFile("NIMO_0009171000.xls", data);
            var result = parser.Process(reader, null).FirstOrDefault();

            //Assert
            Assert.IsNotNull(result);
            Assert.AreEqual("0009171000", result.Account);
            Assert.AreEqual("NIMO", result.UtilityCode);

            Assert.IsTrue(result.Data.All(d => d.Values != null && d.Values.Count == 24));
            Assert.IsTrue(result.Data.All(d => d.Unit == "kWh"));
        }
*/
	}
}

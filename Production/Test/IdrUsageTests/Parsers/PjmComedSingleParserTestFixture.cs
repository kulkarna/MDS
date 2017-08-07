using System;
using System.Reflection;
using System.Collections.Generic;
using System.Linq;
using LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace IdrUsageTests.Parsers
{
	[TestClass]
	public class PjmComedSingleParserTestFixture
	{
        [TestMethod]
        public void ParseSingleFile()
        {
            //Arrange
			var data = Assembly.GetExecutingAssembly().GetManifestResourceStream( "IdrUsageTests.Resources.Parsers.PjmComedSingle.COMED_4563045138.csv" );

	        var parser = new PjmComedSingleParser();

            //Act
            var reader = RawParserService.GetReaderForFile("COMED_4563045138.csv", data);
            var accountNumbers = new Dictionary<string, string>();
            var result = parser.Process(reader, accountNumbers).FirstOrDefault();

            //Assert
            Assert.IsNotNull(result);
			Assert.AreEqual( "4563045138", result.Account );
            Assert.AreEqual("COMED", result.UtilityCode);
            Assert.AreEqual(30, result.Interval);

            //Assert.IsTrue(result.Data.All(d => d.Values != null && d.Values.Count == 48));
			//Assert.IsTrue( result.Data.All( d => d.Unit == "kW" ) );
			
            Assert.AreEqual(new DateTime(2007, 10, 8), result.Data[0].Date);
            Assert.AreEqual(new DateTime(2009, 9, 8), result.Data[30281].Date);

			Assert.AreEqual( 1.68M, result.Data.Single( d => d.Meter == "082701463" && d.Date == new DateTime( 2007, 11, 12 ) ).Values[5] );
			Assert.AreEqual( 41.04M, result.Data.Single( d => d.Meter == "082761717" && d.Date == new DateTime( 2007, 12, 22 ) ).Values[0] );
			Assert.AreEqual( 41.868M, result.Data.Single( d => d.Meter == "083057714" && d.Date == new DateTime( 2008, 1, 30 ) ).Values[47] );
			Assert.AreEqual( 47.448M, result.Data.Single( d => d.Meter == "083057714" && d.Date == new DateTime( 2008, 1, 31 ) ).Values[15] );
			Assert.AreEqual( 9.576M, result.Data.Single( d => d.Meter == "083110457" && d.Date == new DateTime( 2009, 9, 8 ) ).Values[0] );
        }
    }
}

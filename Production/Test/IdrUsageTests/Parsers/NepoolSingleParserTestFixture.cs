using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace IdrUsageTests.Parsers
{
	[TestClass]
	public class NepoolSingleParserTestFixture
	{
		[TestMethod]
		public void ParseBangorSingleFile()
		{
			//Arrange
			var data = Assembly.GetExecutingAssembly().GetManifestResourceStream( "IdrUsageTests.Resources.Parsers.NepoolSingle.BANGOR_nees_35f53227_4f28ecd0_hourly.csv" );

			var parser = new NepoolBangorSingleParser {IsAccountNumberInFile = true};
            var accountNumbers = new Dictionary<string, string>();

		    //Act
            var reader = RawParserService.GetReaderForFile("BANGOR_nees_35f53227_4f28ecd0_hourly.csv", data);
            var result = parser.Process(reader, accountNumbers).FirstOrDefault();

			//Assert
			Assert.IsNotNull( result );
			Assert.AreEqual( "9090449003", result.Account );
			Assert.AreEqual( "BANGOR", result.UtilityCode );
			Assert.AreEqual( 60, result.Interval );

			Assert.IsTrue( result.Data.All( d => d.Values != null && d.Values.Count == 24 ) );
			Assert.IsTrue( result.Data.All( d => d.Unit == "kWh" || d.Unit == "kVAh" || d.Unit == "Power Factor" ) );
			Assert.AreEqual( new DateTime( 2009, 2, 1 ), result.Data[0].Date );
            Assert.AreEqual("1 kWh", result.Data[0].Meter);
			Assert.AreEqual( 296.16M, result.Data[0].Values[5] );
		}

		[TestMethod]
		public void ParseMecoSingleFile()
		{
			//Arrange
			var data = Assembly.GetExecutingAssembly().GetManifestResourceStream( "IdrUsageTests.Resources.Parsers.NepoolSingle.MECO_nees_30a21e23_37d555f9_hourly.csv" );

			var parser = new NepoolMecoSingleParser {IsAccountNumberInFile = true};

		    //Act
            var reader = RawParserService.GetReaderForFile("MECO_nees_30a21e23_37d555f9_hourly.csv", data);
            var accountNumbers = new Dictionary<string, string>();
            var result = parser.Process(reader, accountNumbers).FirstOrDefault();

			//Assert
			Assert.IsNotNull( result );
			Assert.AreEqual( "2744086022", result.Account );
			Assert.AreEqual( "MECO", result.UtilityCode );
			Assert.AreEqual( 60, result.Interval );

			Assert.IsTrue( result.Data.All( d => d.Values != null && d.Values.Count == 24 ) );
			Assert.IsTrue( result.Data.All( d => d.Unit == "kWh" || d.Unit == "kVAh" || d.Unit == "Power Factor" ) );
			Assert.AreEqual( new DateTime( 2008, 1, 1 ), result.Data[0].Date );
            Assert.AreEqual("1 kWh", result.Data[0].Meter);
			Assert.AreEqual( 118.56M, result.Data[0].Values[5] );
		}
		
		[TestMethod]
		public void ParseNecoSingleFile()
		{
			//Arrange
			var data = Assembly.GetExecutingAssembly().GetManifestResourceStream( "IdrUsageTests.Resources.Parsers.NepoolSingle.NECO_nees_51741251_0136f425_hourly.csv" );

			var parser = new NepoolNecoSingleParser {IsAccountNumberInFile = true};

		    //Act
            var reader = RawParserService.GetReaderForFile("NECO_nees_51741251_0136f425_hourly.csv", data);
            var accountNumbers = new Dictionary<string, string>();
            var result = parser.Process(reader, accountNumbers).FirstOrDefault();

			//Assert
			Assert.IsNotNull( result );
			Assert.AreEqual( "7918626004", result.Account );
			Assert.AreEqual( "NECO", result.UtilityCode );
			Assert.AreEqual( 60, result.Interval );

			Assert.IsTrue( result.Data.All( d => d.Values != null && d.Values.Count == 24 ) );
			Assert.IsTrue( result.Data.All( d => d.Unit == "kWh" || d.Unit == "kVAh" || d.Unit == "Power Factor" ) );
			Assert.AreEqual( new DateTime( 2009, 5, 1 ), result.Data[0].Date );
            Assert.AreEqual("1 kWh", result.Data[0].Meter);
			Assert.AreEqual( null, result.Data[0].Values[5] );
		}
		
		[TestMethod]
		public void ParseClAndPSingleFile()
		{
			//Arrange
			var data = Assembly.GetExecutingAssembly().GetManifestResourceStream( "IdrUsageTests.Resources.Parsers.NepoolSingle.CLP_nu_28510f70_bb311370_hourlycsv.csv" );

			var parser = new NepoolClAndPSingleParser();
            var accounts = new Dictionary<string, string> { { "123456", "123456" } };

			//Act
            var reader = RawParserService.GetReaderForFile("CLP_nu_28510f70_bb311370_hourlycsv.csv", data);
            var result = parser.Process(reader, accounts).FirstOrDefault();

			//Assert
			Assert.IsNotNull( result );
			Assert.AreEqual( "123456", result.Account );
			Assert.AreEqual( "CL&P", result.UtilityCode );
			Assert.AreEqual( 60, result.Interval );

			Assert.IsTrue( result.Data.All( d => d.Values != null && d.Values.Count == 24 ) );
			Assert.IsTrue( result.Data.All( d => d.Unit == "kWh" || d.Unit == "kVARh" || d.Unit == "Power Factor" ) );
			Assert.AreEqual( new DateTime( 2010, 8, 16 ), result.Data[0].Date );
			Assert.AreEqual( "0039709231 1 kWh", result.Data[0].Meter );
			Assert.AreEqual( 676.62M, result.Data[0].Values[5] );
		}

		[TestMethod]
		public void ParseWmecoSingleFile()
		{
			//Arrange
			var data = Assembly.GetExecutingAssembly().GetManifestResourceStream( "IdrUsageTests.Resources.Parsers.NepoolSingle.WMECO_nu_4e763413_9557b702_hourly_136541008.csv" );

			var parser = new NepoolWmecoSingleParser();
            var accounts = new Dictionary<string, string> { { "123456", "123456" } };

			//Act
            var reader = RawParserService.GetReaderForFile("WMECO_nu_4e763413_9557b702_hourly_136541008.csv", data);
            var result = parser.Process(reader, accounts).FirstOrDefault();

			//Assert
			Assert.IsNotNull( result );
			Assert.AreEqual( "123456", result.Account );
			Assert.AreEqual( "WMECO", result.UtilityCode );
			Assert.AreEqual( 60, result.Interval );

			Assert.IsTrue( result.Data.All( d => d.Values != null && d.Values.Count == 24 ) );
			Assert.IsTrue( result.Data.All( d => d.Unit == "kWh" || d.Unit == "kVARh" || d.Unit == "Power Factor" ) );
			Assert.AreEqual( new DateTime( 2009, 6, 1 ), result.Data[0].Date );
			Assert.AreEqual( "890450012 1 kWh", result.Data[0].Meter );
			Assert.AreEqual( 420.66M, result.Data[0].Values[5] );
		}

		[TestMethod]
		public void ParseUiSingleFile()
		{
			//Arrange
			var data = Assembly.GetExecutingAssembly().GetManifestResourceStream( "IdrUsageTests.Resources.Parsers.NepoolSingle.UI_United_healthcare_MOST_RECENT_IDR.xls" );

			var parser = new NepoolUiSingleParser();

			//Act
            var reader = RawParserService.GetReaderForFile("UI_United_healthcare_MOST_RECENT_IDR.xls", data);
            var accountNumbers = new Dictionary<string, string>();
            var result = parser.Process(reader, accountNumbers);

			//Assert
			Assert.IsNotNull( result );
			Assert.AreEqual( 3, result.Count() );

			Assert.IsNotNull( result.Single( x => x.Account == "2421007712001" ) );
			Assert.IsNotNull( result.Single( x => x.Account == "2420026649021" ) );
			Assert.IsNotNull( result.Single( x => x.Account == "2420026653021" ) );

		    foreach (var t in result)
			{
				Assert.AreEqual("UI", t.UtilityCode);
				Assert.AreEqual(15, t.Interval);

				Assert.IsTrue( t.Data.All( d => d.Values != null && d.Values.Count == 96 ) );
				Assert.IsTrue( t.Data.All( d => d.Unit == "KW" ) );
			}

			Assert.AreEqual( new DateTime( 2009, 4, 22 ), result.Single(x => x.Account == "2421007712001").Data[0].Date );
			Assert.AreEqual( 651.6M, result.Single(x => x.Account == "2421007712001").Data[0].Values[5] );

			Assert.AreEqual( new DateTime( 2009, 4, 22 ), result.Single( x => x.Account == "2420026649021" ).Data[0].Date );
			Assert.AreEqual( 100.8M, result.Single( x => x.Account == "2420026649021" ).Data[0].Values[5] );

			Assert.AreEqual( new DateTime( 2009, 4, 22 ), result.Single( x => x.Account == "2420026653021" ).Data[0].Date );
			Assert.AreEqual( 118.08M, result.Single( x => x.Account == "2420026653021" ).Data[0].Values[5] );
		}
	}
}

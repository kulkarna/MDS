using System;
using System.Collections.Generic;
using System.Reflection;
using System.Linq;
using LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace IdrUsageTests.Parsers
{
	[TestClass]
    public class PjmHorizontalSingleParserTestFixture
	{
        [TestMethod]
		public void ParseJcplSingleFile08006416100000710851()
        {
            //Arrange
            var data = Assembly.GetExecutingAssembly().GetManifestResourceStream("IdrUsageTests.Resources.Parsers.PjmHorizontalSingle.JCPL_IDR_08006416100000710851.xls");

			var parser = new JcplHorizontalSingleParser();

            //Act
            var reader = RawParserService.GetReaderForFile("JCPL_IDR_08006416100000710851.xls", data);
            var accountNumbers = new Dictionary<string, string>();
            var result = parser.Process(reader, accountNumbers).FirstOrDefault();

            //Assert
            Assert.IsNotNull(result);
			Assert.AreEqual("08006416100000710851", result.Account);
			Assert.AreEqual("JCP&L", result.UtilityCode);
            Assert.AreEqual(60, result.Interval);

			Assert.IsTrue(result.Data.All(d => d.Values != null && d.Values.Count == 24));
			Assert.IsTrue( result.Data.All( d => d.Unit == "kWh" ) );
			Assert.AreEqual(new DateTime(2010, 6, 1), result.Data[0].Date);
			Assert.AreEqual(573.1M, result.Data[0].Values[5]);
        }

        [TestMethod]
		public void ParseJcplSingleFile08002266060003150805()
		{
			//Arrange
			var data = Assembly.GetExecutingAssembly().GetManifestResourceStream( "IdrUsageTests.Resources.Parsers.PjmHorizontalSingle.JCPL_Raw_IDR_08002266060003150805.xlsx" );

			var parser = new JcplHorizontalSingleParser();

			//Act
            var reader = RawParserService.GetReaderForFile("JCPL_Raw_IDR_08002266060003150805.xlsx", data);
            var accountNumbers = new Dictionary<string, string>();
            var result = parser.Process(reader, accountNumbers).FirstOrDefault();

			//Assert
			Assert.IsNotNull(data);
			Assert.IsNotNull(result);
			Assert.AreEqual( "08002266060003150805", result.Account );
			Assert.AreEqual( "JCP&L", result.UtilityCode );
            Assert.AreEqual(60, result.Interval);
            Assert.IsTrue(result.Data.All(d => d.Values != null && d.Values.Count == 24));
			Assert.IsTrue( result.Data.All( d => d.Unit == "kWh" ) );
			Assert.AreEqual(new DateTime(2011, 09, 1), result.Data[0].Date);
			Assert.AreEqual( 837.4M, result.Data[0].Values[5] );
		}

		[TestMethod]
		public void ParsePenelecSingleFile()
		{
			//Arrange
			var data = Assembly.GetExecutingAssembly().GetManifestResourceStream( "IdrUsageTests.Resources.Parsers.PjmHorizontalSingle.Penelec_IDR.xls" );

			var parser = new PenelecHorizontalSingleParser();

			//Act
            var reader = RawParserService.GetReaderForFile("Penelec_IDR.xls", data);
            var accountNumbers = new Dictionary<string, string>();
            var result = parser.Process(reader, accountNumbers).FirstOrDefault();

			//Assert
			Assert.IsNotNull(result);
			Assert.AreEqual("08000620870001060064", result.Account);
			Assert.AreEqual("PENELEC", result.UtilityCode);
            Assert.AreEqual(60, result.Interval);
            Assert.IsTrue(result.Data.All(d => d.Values != null && d.Values.Count == 24));
			Assert.IsTrue( result.Data.All( d => d.Unit == "kWh" ) );
			Assert.AreEqual(new DateTime(2009, 11, 1), result.Data[0].Date);
			Assert.AreEqual(70.5M, result.Data[0].Values[5]);
		}

		[TestMethod]
		public void ParsePennprSingleFile()
		{
			//Arrange
			var data = Assembly.GetExecutingAssembly().GetManifestResourceStream( "IdrUsageTests.Resources.Parsers.PjmHorizontalSingle.PENNPR_IDR_60406.xlsx" );

			var parser = new PennprHorizontalSingleParser();

			//Act
            var reader = RawParserService.GetReaderForFile("PENNPR_IDR_60406.xlsx", data);
            var accountNumbers = new Dictionary<string, string>();
            var result = parser.Process(reader, accountNumbers).FirstOrDefault();

			//Assert
			Assert.IsNotNull(result);
			Assert.AreEqual( "08031502000000060406", result.Account );
			Assert.AreEqual( "PENNPR", result.UtilityCode );
            Assert.AreEqual(60, result.Interval);
            Assert.IsTrue(result.Data.All(d => d.Values != null && d.Values.Count == 24));
			Assert.IsTrue( result.Data.All( d => d.Unit == "kWh" ) );
			Assert.AreEqual(new DateTime(2010, 5, 1), result.Data[0].Date);
			Assert.AreEqual(82.8M, result.Data[0].Values[5]);
		}

		[TestMethod]
		public void ParseAllegmdSingleFileLifeTechnologies()
		{
			//Arrange
			var data = Assembly.GetExecutingAssembly().GetManifestResourceStream( "IdrUsageTests.Resources.Parsers.PjmHorizontalSingle.ALLEGMD_LIFE_TECHNOLOGIES_CORP_MD_IDR_Files.xlsx" );

			var parser = new AllegmdHorizontalSingleParser();

			//Act
            var reader = RawParserService.GetReaderForFile("ALLEGMD_LIFE_TECHNOLOGIES_CORP_MD_IDR_Files.xlsx", data);
            var accountNumbers = new Dictionary<string, string>();
            var result = parser.Process(reader, accountNumbers);

			//Assert
			Assert.IsNotNull(result);
			Assert.AreEqual(4, result.Count());

			Assert.IsNotNull( result.Single( d => d.Account == "08044050855001048157" ) );
			Assert.IsNotNull( result.Single( d => d.Account == "08043125395000995546" ) );
			Assert.IsNotNull( result.Single( d => d.Account == "08043124915001047980" ) );
			Assert.IsNotNull( result.Single( d => d.Account == "08043187535000577793" ) );

			foreach( var entry in result )
			{
				Assert.AreEqual("ALLEGMD", entry.UtilityCode);
                Assert.AreEqual(60, entry.Interval);
                Assert.IsTrue(entry.Data.All(d => d.Values != null && d.Values.Count == 24));
				Assert.IsTrue( entry.Data.All( d => d.Unit == "kWh" ) );
			}

			Assert.AreEqual( new DateTime( 2012, 7, 6 ), result.Single( d => d.Account == "08044050855001048157" ).Data[0].Date );
			Assert.AreEqual( 301.8M, result.Single( d => d.Account == "08044050855001048157" ).Data[0].Values[5] );

			Assert.AreEqual( new DateTime( 2012, 7, 6 ), result.Single( d => d.Account == "08043125395000995546" ).Data[0].Date );
			Assert.AreEqual( 626.4M, result.Single( d => d.Account == "08043125395000995546" ).Data[0].Values[5] );

			Assert.AreEqual( new DateTime( 2012, 7, 6 ), result.Single( d => d.Account == "08043124915001047980" ).Data[0].Date );
			Assert.AreEqual( 259.8M, result.Single( d => d.Account == "08043124915001047980" ).Data[0].Values[5] );

			Assert.AreEqual( new DateTime( 2011, 9, 1 ), result.Single( d => d.Account == "08043187535000577793" ).Data[0].Date );
			Assert.AreEqual( 718M, result.Single( d => d.Account == "08043187535000577793" ).Data[0].Values[5] );
		}

		[TestMethod]
		public void ParseAllegmdSingleFileAlleg08043680125000522941()
		{
			//Arrange
			var data = Assembly.GetExecutingAssembly().GetManifestResourceStream( "IdrUsageTests.Resources.Parsers.PjmHorizontalSingle.Alleg_MD_IDR_08043680125000522941.xlsm" );

			var parser = new AllegmdHorizontalSingleParser();

			//Act
            var reader = RawParserService.GetReaderForFile("Alleg_MD_IDR_08043680125000522941.xlsm", data);
            var accountNumbers = new Dictionary<string, string>();
            var result = parser.Process(reader, accountNumbers).FirstOrDefault();

			//Assert
			Assert.IsNotNull( data );
			Assert.IsNotNull( result );
			Assert.AreEqual( "08043680125000522941", result.Account );
			Assert.AreEqual( "ALLEGMD", result.UtilityCode );
            Assert.AreEqual(60, result.Interval);
			Assert.IsTrue( result.Data.All( d => d.Values != null && d.Values.Count == 24 ) );
			Assert.IsTrue( result.Data.All( d => d.Unit == "kWh" ) );
			Assert.AreEqual( new DateTime( 2011, 9, 1 ), result.Data[0].Date );
			Assert.AreEqual( 741.4M, result.Data[0].Values[5] );
		}

		[TestMethod]
		public void ParseWppSingleFile()
		{
			//Arrange
			var data = Assembly.GetExecutingAssembly().GetManifestResourceStream( "IdrUsageTests.Resources.Parsers.PjmHorizontalSingle.WPP_08056180450006654075_IDR.xlsx" );

			var parser = new WppHorizontalSingleParser();

			//Act
            var reader = RawParserService.GetReaderForFile("WPP_08056180450006654075_IDR.xlsx", data);
            var accountNumbers = new Dictionary<string, string>();
            var result = parser.Process(reader, accountNumbers).FirstOrDefault();

			//Assert
			Assert.IsNotNull(result);
			Assert.AreEqual("08056180450006654075", result.Account);
			Assert.AreEqual("WPP", result.UtilityCode);
            Assert.AreEqual(60, result.Interval);
			Assert.IsTrue(result.Data.All(d => d.Values != null && d.Values.Count == 24));
			Assert.IsTrue( result.Data.All( d => d.Unit == "kWh" ) );
			Assert.AreEqual(new DateTime(2011, 09, 1), result.Data[0].Date);
			Assert.AreEqual(3973.3M, result.Data[0].Values[5]);
		}

		[TestMethod]
		public void ParseOhedSingleFile()
		{
			//Arrange
			var data = Assembly.GetExecutingAssembly().GetManifestResourceStream( "IdrUsageTests.Resources.Parsers.PjmHorizontalSingle.IDR_08022700250000592815.xlsx" );

			var parser = new OhedHorizontalSingleParser();

			//Act
            var reader = RawParserService.GetReaderForFile("IDR_08022700250000592815.xlsx", data);
            var accountNumbers = new Dictionary<string, string>();
            var result = parser.Process(reader, accountNumbers).FirstOrDefault();

			//Assert
			Assert.IsNotNull(result);
			Assert.AreEqual( "08022700250000592815", result.Account );
			Assert.AreEqual( "OHED", result.UtilityCode );
            Assert.AreEqual(60, result.Interval);
			Assert.IsTrue(result.Data.All(d => d.Values != null && d.Values.Count == 24));
			Assert.IsTrue( result.Data.All( d => d.Unit == "kWh" ) );
			Assert.AreEqual(new DateTime(2011, 9, 1), result.Data[0].Date);
			Assert.AreEqual(554M, result.Data[0].Values[5]);
		}

        [TestMethod]
        public void ParseMetedSingleFile()
        {
            //Arrange
            var data = Assembly.GetExecutingAssembly().GetManifestResourceStream("IdrUsageTests.Resources.Parsers.PjmHorizontalSingle.METED_Allenberry_Resort_Inn_IDR_Data.xls");

            var parser = new MetedHorizontalSingleParser();

            //Act
            var reader = RawParserService.GetReaderForFile("METED_Allenberry_Resort_Inn_IDR_Data.xls", data);
            var accountNumbers = new Dictionary<string, string>();
            var result = parser.Process(reader, accountNumbers).FirstOrDefault();

            //Assert
            Assert.IsNotNull(result);
            Assert.AreEqual("08014360740002178045", result.Account);
            Assert.AreEqual("METED", result.UtilityCode);
            Assert.AreEqual(60, result.Interval);
            Assert.IsTrue(result.Data.All(d => d.Values != null && d.Values.Count == 24));
            Assert.IsTrue(result.Data.All(d => d.Unit == "kWh"));
            Assert.AreEqual(new DateTime(2009, 7, 1), result.Data[0].Date);
            Assert.AreEqual(91.9M, result.Data[0].Values[5]);
        }

        [TestMethod]
        public void ParseCeiSingleFile()
        {
            //Arrange
            var data = Assembly.GetExecutingAssembly().GetManifestResourceStream("IdrUsageTests.Resources.Parsers.CeiHorizontalSingle.CEI_08005953021510000508_IDR.xlsx");

            var parser = new CeiHorizontalSingleParser();

            //Act
            var reader = RawParserService.GetReaderForFile("CEI_08005953021510000508_IDR.xlsx", data);
            var accountNumbers = new Dictionary<string, string>();
            var result = parser.Process(reader, accountNumbers).FirstOrDefault();

            //Assert
            Assert.IsNotNull(result);
            Assert.AreEqual("08005953021510000508", result.Account);
            Assert.AreEqual("CEI", result.UtilityCode);
            Assert.AreEqual(60, result.Interval);
            Assert.IsTrue(result.Data.All(d => d.Values != null && d.Values.Count == 24));
            Assert.IsTrue(result.Data.All(d => d.Unit == "kWh"));
            Assert.AreEqual(new DateTime(2011, 9, 1), result.Data[0].Date);
            Assert.AreEqual(310.9M, result.Data[0].Values[5]);
        }

        [TestMethod]
        public void ParseToledSingleFile()
        {
            //Arrange
            var data = Assembly.GetExecutingAssembly().GetManifestResourceStream("IdrUsageTests.Resources.Parsers.ToledHorizontalSingle.Toledo_IDR_DA19203.xlsx");

            var parser = new ToledHorizontalSingleParser();

            //Act
            var reader = RawParserService.GetReaderForFile("Toledo_IDR_DA19203.xlsx", data);
            var accountNumbers = new Dictionary<string, string>();
            var result = parser.Process(reader, accountNumbers).FirstOrDefault();

            //Assert
            Assert.IsNotNull(result);
            Assert.AreEqual("08006615332270008481", result.Account);
            Assert.AreEqual("TOLED", result.UtilityCode);
            Assert.AreEqual(60, result.Interval);
            Assert.IsTrue(result.Data.All(d => d.Values != null && d.Values.Count == 24));
            Assert.IsTrue(result.Data.All(d => d.Unit == "kWh"));
            Assert.AreEqual(new DateTime(2011, 9, 1), result.Data[0].Date);
            Assert.AreEqual(18275.8M, result.Data[0].Values[5]);
        }
	}
}

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
	public class NySegMultipleParserTestFixture
	{
		readonly IList<string> _resourceFileList = new List<string>
		{
			"IdrUsageTests.Resources.Parsers.NySegMultiple.ESCO_Hourly_Data_6_2_2010_1_48_20_PM.csv",
			"IdrUsageTests.Resources.Parsers.NySegMultiple.ESCO_Hourly_Data_6_2_2010_1_49_13_PM.csv",
			"IdrUsageTests.Resources.Parsers.NySegMultiple.ESCO_Hourly_Data_6_2_2010_1_49_56_PM.csv",
			"IdrUsageTests.Resources.Parsers.NySegMultiple.ESCO_Hourly_Data_6_2_2010_1_50_21_PM.csv",
			"IdrUsageTests.Resources.Parsers.NySegMultiple.ESCO_Hourly_Data_6_2_2010_1_50_03_PM.csv",
			"IdrUsageTests.Resources.Parsers.NySegMultiple.ESCO_Hourly_Data_6_2_2010_1_49_38_PM.csv",
			"IdrUsageTests.Resources.Parsers.NySegMultiple.ESCO_Hourly_Data_6_2_2010_1_50_32_PM.csv",
			"IdrUsageTests.Resources.Parsers.NySegMultiple.ESCO_Hourly_Data_6_2_2010_1_48_35_PM.csv",
			"IdrUsageTests.Resources.Parsers.NySegMultiple.ESCO_Hourly_Data_6_2_2010_1_49_20_PM.csv",
			"IdrUsageTests.Resources.Parsers.NySegMultiple.ESCO_Hourly_Data_6_2_2010_1_49_47_PM.csv",
			"IdrUsageTests.Resources.Parsers.NySegMultiple.ESCO_Hourly_Data_6_2_2010_1_49_02_PM.csv",
			"IdrUsageTests.Resources.Parsers.NySegMultiple.ESCO_Hourly_Data_6_2_2010_1_49_29_PM.csv"
		};

        [TestMethod]
        public void ParseSingleFile()
        {
            //Arrange
            var data = Assembly.GetExecutingAssembly().GetManifestResourceStream(_resourceFileList[0]);

            var parser = new NySegMultipleParser();

            //Act
            var reader = RawParserService.GetReaderForFile(_resourceFileList[0], data);
            var accountNumbers = new Dictionary<string, string>();
            var result = parser.Process(reader, accountNumbers).FirstOrDefault();

            //Assert
            Assert.IsNotNull(result);
            Assert.AreEqual("N01000020729638", result.Account);
            Assert.AreEqual("NYSEG", result.UtilityCode);
            Assert.AreEqual(60, result.Interval);
            Assert.AreEqual(30, result.Data.Count);

            Assert.IsTrue(result.Data.All(d => d.Values != null && d.Values.Count == 24));

            Assert.AreEqual(new DateTime(2010, 4, 1), result.Data[0].Date);
            Assert.AreEqual(new DateTime(2010, 4, 30), result.Data[29].Date);


            Assert.AreEqual(5205.84M, result.Data[5].Values[4]);
            Assert.AreEqual(5056.56M, result.Data[2].Values[8]);
            Assert.AreEqual(5226.96M, result.Data[26].Values[0]);
            Assert.AreEqual(5507.04M, result.Data[15].Values[15]);
            Assert.AreEqual(4657.68M, result.Data[0].Values[2]);
        }

        [TestMethod]
        public void CanParseFileWithRepeatedHeaders()
        {
            //Arrange
            var data = Assembly.GetExecutingAssembly().GetManifestResourceStream(_resourceFileList[11]);

            var parser = new NySegMultipleParser();

            //Act
            var reader = RawParserService.GetReaderForFile(_resourceFileList[11], data);
            var accountNumbers = new Dictionary<string, string>();
            var result = parser.Process(reader, accountNumbers).FirstOrDefault();

            //Assert
            Assert.IsNotNull(result);
            Assert.AreEqual("N01000020729638", result.Account);
            Assert.AreEqual("NYSEG", result.UtilityCode);
            Assert.AreEqual(60, result.Interval);
            Assert.AreEqual(32, result.Data.Count);

            Assert.IsTrue(result.Data.All(d => d.Values.Count == 24));

            Assert.AreEqual(new DateTime(2009, 11, 1), result.Data[0].Date);
            Assert.AreEqual(new DateTime(2009, 12, 2), result.Data[31].Date);

            Assert.AreEqual(4998.24M, result.Data[0].Values[1]);
            Assert.AreEqual(4947.6M, result.Data[1].Values[1]);
        }

        [TestMethod]
		public void ParseMultipleFile()
		{
			//Arrange
			var parser = new NySegMultipleParser();


            foreach (var file in _resourceFileList)
            {
                var data = Assembly.GetExecutingAssembly().GetManifestResourceStream(file);
                var reader = RawParserService.GetReaderForFile(file, data);

                // Act
                var accountNumbers = new Dictionary<string, string>();
                var result = parser.Process(reader, accountNumbers).FirstOrDefault();

                // Assert
				Assert.IsNotNull( result );
				Assert.AreEqual( "N01000020729638", result.Account );
				Assert.AreEqual( "NYSEG", result.UtilityCode );
                Assert.AreEqual(60, result.Interval);
				Assert.IsTrue( result.Data.Count > 0);
            }
		}

        [TestMethod]
        public void ParseZipFile()
        {
            //Arrange
            var zipStream = Assembly.GetExecutingAssembly().GetManifestResourceStream("IdrUsageTests.Resources.Parsers.NySegMultiple.NYSEG_IDR_N01000020729638.zip");
            var unzipedStreams = ZipFileManager.Unzip(zipStream);
            var parser = new NySegMultipleParser();

            foreach (var stream in unzipedStreams)
            {
                var reader = RawParserService.GetReaderForFile(stream.Key, stream.Value);
                var accountNumbers = new Dictionary<string, string>();
                var result = parser.Process(reader, accountNumbers).First();
                //Assert
                Assert.IsNotNull(result);
                Assert.AreEqual("N01000020729638", result.Account);
                Assert.AreEqual("NYSEG", result.UtilityCode);
                Assert.AreEqual(60, result.Interval);
                Assert.IsTrue(result.Data.Count > 0);
            }
        }

		[TestMethod]
		public void ParseZipFileR01000058548264()
		{
			//Arrange
			var zipStream = Assembly.GetExecutingAssembly().GetManifestResourceStream( "IdrUsageTests.Resources.Parsers.NySegMultiple.IDR_R01000058548264_NYSEG_Multiple.zip" );
			var unzipedStreams = ZipFileManager.Unzip( zipStream );
			var parser = new NySegMultipleParser();

			foreach( var stream in unzipedStreams )
			{
                var reader = RawParserService.GetReaderForFile(stream.Key, stream.Value);
                var accountNumbers = new Dictionary<string, string>();
                var result = parser.Process(reader, accountNumbers).First();
                //Assert
				Assert.IsNotNull( result );
				Assert.AreEqual( "R01000058548264", result.Account );
				Assert.AreEqual( "NYSEG", result.UtilityCode );
                Assert.AreEqual(60, result.Interval);
				Assert.IsTrue( result.Data.Count > 0 );
			}
		}
    }
}

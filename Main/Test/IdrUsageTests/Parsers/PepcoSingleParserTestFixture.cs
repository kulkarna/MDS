using System;
using System.Reflection;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using LibertyPower.Business.MarketManagement.IdrUsageManagement;
using LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers;
using LibertyPower.Business.MarketManagement.IdrUsageManagement.Readers;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace IdrUsageTests.Parsers
{
	[TestClass]
	public class PepcoSingleParserTestFixture
	{
        [TestMethod]
        public void ParseSingleFile()
        {
            //Arrange
			var data = Assembly.GetExecutingAssembly().GetManifestResourceStream( "IdrUsageTests.Resources.Parsers.PepcoSingle.PEPCO_8550056014_MD_Pepco_IDR2.LD" );

	        var parser = new PepcoDcSingleParser();

            //Act
            var reader = RawParserService.GetReaderForFile("PEPCO_8550056014_MD_Pepco_IDR2.LD", data);
            var accountNumbers = new Dictionary<string, string>();
            var result = parser.Process(reader, accountNumbers);

            //Assert
            Assert.IsNotNull(result);

			//Parser must have extracted data for two accounts.
			Assert.AreEqual(1, result.Count());
			Assert.AreEqual( "5003400008", result.First().Account );
			Assert.AreEqual( "PEPCO-DC", result.First().UtilityCode );
            Assert.AreEqual(15, result.First().Interval);

			Assert.AreEqual(new DateTime(2010, 4, 13), result.First().Data[0].Date);
        }

        [TestMethod]
        public void ParseSingleFileTwoAccounts()
        {
            //Arrange
            var data = Assembly.GetExecutingAssembly().GetManifestResourceStream("IdrUsageTests.Resources.Parsers.PepcoSingle.PEPCO_8550056014_MD_Pepco_IDR2_Two_Accounts.LD");

            var parser = new PepcoMdSingleParser();

            //Act
            var reader = RawParserService.GetReaderForFile("PEPCO_8550056014_MD_Pepco_IDR2_Two_Accounts.LD", data);
            var accountNumbers = new Dictionary<string, string>();
            var result = parser.Process(reader, accountNumbers);

            //Assert
            Assert.IsNotNull(result);

            //Parser must have extracted data for two accounts.
            Assert.AreEqual(2, result.Count());
            Assert.AreEqual("5003400008", result.First().Account);
            Assert.AreEqual("PEPCO-MD", result.First().UtilityCode);
            Assert.AreEqual(new DateTime(2010, 4, 13), result.First().Data[0].Date);

            Assert.AreEqual("5003400009", result.Last().Account);
            Assert.AreEqual("PEPCO-MD", result.Last().UtilityCode);
            Assert.AreEqual(new DateTime(2010, 4, 13), result.Last().Data[0].Date);
        }

        [TestMethod]
        public void ParseSingleFileMeterNumberInDifferentPositions()
        {
            //Arrange
            var data = Assembly.GetExecutingAssembly().GetManifestResourceStream("IdrUsageTests.Resources.Parsers.PepcoSingle.AMC_Pepco_DC_0776260044_IDR_1.txt");

            var parser = new PepcoDcSingleParser();

            //Act
            var reader = RawParserService.GetReaderForFile("AMC_Pepco_DC_0776260044_IDR_1.txt", data);
            var accountNumbers = new Dictionary<string, string>();
            var result = parser.Process(reader, accountNumbers);

            //Assert
            Assert.IsNotNull(result);

            var idrRawDatas = result as IEnumerable<IdrRawData> ?? result.ToList();
            var rawDatas = idrRawDatas as IdrRawData[] ?? idrRawDatas.ToArray();
            Assert.AreEqual(3, rawDatas.Count());

            Assert.AreEqual("0776260101", rawDatas[0].Account);
            Assert.AreEqual("PEPCO-DC", rawDatas[0].UtilityCode);
            Assert.AreEqual("00000000005816903", rawDatas[0].Data[0].Meter);

            Assert.AreEqual("0776260200", rawDatas[1].Account);
            Assert.AreEqual("PEPCO-DC", rawDatas[1].UtilityCode);
            Assert.AreEqual("028478109000000000", rawDatas[1].Data[0].Meter);

            Assert.AreEqual("0776260408", rawDatas[2].Account);
            Assert.AreEqual("PEPCO-DC", rawDatas[2].UtilityCode);
            Assert.AreEqual("028478110000000000", rawDatas[2].Data[0].Meter);
        }
    }
}

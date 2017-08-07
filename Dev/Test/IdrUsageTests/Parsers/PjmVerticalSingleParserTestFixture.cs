using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Reflection;
using LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers;

namespace IdrUsageTests.Parsers
{
    [TestClass]
    public class PjmVerticalSingleParserTestFixture
    {
        [TestMethod]
        public void ParseJcplSingleFile()
        {
            //Arrange
            var data = Assembly.GetExecutingAssembly().GetManifestResourceStream("IdrUsageTests.Resources.Parsers.PjmVerticalSingle.JCPL_Liberty08014784410000139411.csv");

            var parser = new JcplVerticalSingleParser { AccountNumber = "08014784410000139411" };
            var accounts = new Dictionary<string, string> { { "08014784410000139411", "08014784410000139411" } };

            //Act
            var reader = RawParserService.GetReaderForFile("JCPL_Liberty08014784410000139411.csv", data);
            reader.Reset();
            var result = parser.Process(reader, accounts).FirstOrDefault();

            //Assert
            Assert.IsNotNull(result);
            Assert.AreEqual("08014784410000139411", result.Account);
            Assert.AreEqual("JCP&L", result.UtilityCode);
            Assert.AreEqual(60, result.Interval);
            Assert.AreEqual(417, result.Data.Count);

            Assert.IsTrue(result.Data.All(d => d.Values != null && d.Values.Count == 24));
            Assert.IsTrue(result.Data.All(d => d.Unit == "kWh"));
            Assert.AreEqual(240.660009M, result.Data.Single(v => v.Date == new DateTime(2008, 9, 1)).Values[5]);
            Assert.AreEqual(1448.280057M, result.Data.Single(v => v.Date == new DateTime(2009, 10, 22)).Values[10]);
            Assert.AreEqual(1303.380052M, result.Data.Single(v => v.Date == new DateTime(2009, 10, 22)).Values[23]);
        }

        [TestMethod]
        public void ParseJcplSingleFileWithAllUnit()
        {
            //Arrange
            var data = Assembly.GetExecutingAssembly().GetManifestResourceStream("IdrUsageTests.Resources.Parsers.PjmVerticalSingle.JCPL_08000374270000130795.xls");

            var parser = new JcplVerticalSingleParser { AccountNumber = "08000374270000130795" };
            var accounts = new Dictionary<string, string> { { "08000374270000130795", "08000374270000130795" } };

            //Act
            var reader = RawParserService.GetReaderForFile("JCPL_08000374270000130795.xls", data);
            var result = parser.Process(reader, accounts).FirstOrDefault();

            //Assert
            Assert.IsNotNull(result);
            Assert.AreEqual("08000374270000130795", result.Account);
            Assert.AreEqual("JCP&L", result.UtilityCode);
            Assert.AreEqual(60, result.Interval);
            Assert.AreEqual(9504/24*3, result.Data.Count);

            Assert.IsTrue(result.Data.All(d => d.Values != null && d.Values.Count == 24));
            Assert.AreEqual(43.8M, result.Data.Single(v => v.Unit == "kWh" && v.Date == new DateTime(2008, 7, 1)).Values[5]);
            Assert.AreEqual(121.200004M, result.Data.Single(v => v.Unit == "kVarh" && v.Date == new DateTime(2008, 7, 1)).Values[5]);
            Assert.AreEqual(128.871568M, result.Data.Single(v => v.Unit == "kVah" && v.Date == new DateTime(2008, 7, 1)).Values[5]);

            Assert.AreEqual(982.20004M, result.Data.Single(v => v.Unit == "kWh" && v.Date == new DateTime(2009, 7, 31)).Values[10]);
            Assert.AreEqual(887.400036M, result.Data.Single(v => v.Unit == "kVarh" && v.Date == new DateTime(2009, 7, 31)).Values[10]);
            Assert.AreEqual(1323.705308M, result.Data.Single(v => v.Unit == "kVah" && v.Date == new DateTime(2009, 7, 31)).Values[10]);

            Assert.AreEqual(711.000028M, result.Data.Single(v => v.Unit == "kWh" && v.Date == new DateTime(2009, 7, 31)).Values[23]);
            Assert.AreEqual(786.600032M, result.Data.Single(v => v.Unit == "kVarh" && v.Date == new DateTime(2009, 7, 31)).Values[23]);
            Assert.AreEqual(1060.311582M, result.Data.Single(v => v.Unit == "kVah" && v.Date == new DateTime(2009, 7, 31)).Values[23]);
        }
    }
}

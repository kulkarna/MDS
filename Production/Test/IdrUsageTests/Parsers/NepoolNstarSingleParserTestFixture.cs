using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace IdrUsageTests.Parsers
{
	[TestClass]
	public class NepoolNstarSingleParserTestFixture
	{
		[TestMethod]
		public void ParseBosSingleFile()
		{
			//Arrange
            var data = Assembly.GetExecutingAssembly().GetManifestResourceStream("IdrUsageTests.Resources.Parsers.NepoolNstarSingle.NSTAR_BOS_COSTCO_RUSTCRAFT_RD_26232771001_2.xls");

			var parser = new NepoolNstarBosSingleParser();
            var accountNumbers = new Dictionary<string, string>();

			//Act
            var reader = RawParserService.GetReaderForFile("NSTAR_BOS_COSTCO_RUSTCRAFT_RD_26232771001_2.xls", data);
            var result = parser.Process(reader, accountNumbers).FirstOrDefault();

			//Assert
			Assert.IsNotNull( result );
            Assert.AreEqual("26232771001", result.Account);
            Assert.AreEqual("NSTAR-BOS", result.UtilityCode);
		    Assert.AreEqual(60, result.Interval);

		    Assert.IsTrue(result.Data.All(d => d.Values != null && d.Values.Count == 24));
		    Assert.IsTrue(result.Data.All(d => d.Unit == "kWh"));
		    Assert.AreEqual(new DateTime(2009, 1, 1), result.Data[0].Date);
		    Assert.IsNull(result.Data[0].Meter);
            Assert.AreEqual(188.572M, result.Data[0].Values[5]);
		}
	}
}

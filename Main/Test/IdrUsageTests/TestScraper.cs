using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using LibertyPower.Business.MarketManagement.UtilityManagement;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace IdrUsageTests
{
	[TestClass]
	public  class TestScraper
	{
		[TestMethod]
        public void TestComed()
        {
			string strMsg="";
			ScraperFactory.RunScraper( "5777048002", "ameren", "", out strMsg );
        }



	}
}

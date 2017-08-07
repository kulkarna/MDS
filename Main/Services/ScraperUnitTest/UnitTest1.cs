using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using LibertyPower.DataAccess.WebAccess.WebScraperManagement;
using LibertyPower.Business.MarketManagement.UtilityManagement;
namespace ScraperUnitTest
{
    [TestClass]
    public class UnitTest1
    {
        [TestMethod()]
        public void TestComedScraper()
        {
            string userName = System.Security.Principal.WindowsIdentity.GetCurrent().Name;
            userName = (string)userName.Split('\\').GetValue(1);

            string accountNumber = "9306006916", exceptions = "", meterNum = "07860096";
         // Comed actual;
           WebAccountList actual;

          // actual = ScraperFactory.RunComedScraper(accountNumber, userName, out exceptions, meterNum);
           actual = ScraperFactory.RunAmerenScraper(accountNumber, userName, out exceptions);
            Assert.IsNotNull(actual);
            if (actual != null)
            {
               Assert.IsTrue(actual.Count > 0);
               // Assert.IsTrue(actual.WebUsageList.Count > 0);
            }
            //Assert.IsTrue(actual.WebUsageList.Count > 0);
        }
    }
}
